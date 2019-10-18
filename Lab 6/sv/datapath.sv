module datapath ( 
	input logic Clk, Reset,
	// Control signals for loading
	input logic LD_MAR, LD_MDR, LD_IR, LD_BEN, LD_CC, LD_REG, LD_PC, LD_LED,
	// Mux Select signals
	input logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX,
	input logic [1:0] PCMUX, ADDR2MUX, ALUK,
	input logic GatePC, GateMDR, GateALU, GateMARMUX,
	
	input logic [15:0] MDR_In,
	input logic MIO_EN,
	
	output logic [11:0] LED,
	// Outputs to BUS
	output logic [15:0] MAR, MDR, IR, PC,
	output logic BEN);
	
	assign LED = IR [11:0] ;
	logic [15:0] BUS;
	logic [15:0] SR1_OUT, SR2_OUT;
	logic [15:0] ADDR_ADD_OUT, ADDR2_OUT, ADDR1_OUT;
	logic [15:0] ALU_OUT;
	logic [15:0] PC_MUX_OUT, MDR_MUX_OUT, SR2_MUX_OUT;
	logic [2:0] DR_MUX_OUT, SR1_MUX_OUT;
	logic [15:0] s10_0, s8_0, s5_0, s4_0;
	logic [19:0] z15_0;
	
	logic N, Z, P;
	
	
	// Initialize ADDER
	adder ADDR_adder(.ADDR2_OUT(ADDR2_OUT), .ADDR1_OUT(ADDR1_OUT), .out(ADDR_ADD_OUT)); 
	
	// Initialize PC MUX
	pc_mux pc_m(.sel(PCMUX), .curr_pc(PC), .bus(BUS), .adder(ADDR_ADD_OUT),.out(PC_MUX_OUT));
	
	// Initialize BUS MUX
	bus_mux bus_m(.gate_PC(GatePC), .gate_MDR(GateMDR), .gate_ALU(GateALU), .gate_MARMUX(GateMARMUX), 
		.PC(PC), .MDR(MDR), .ALU(ALU_OUT), .MARMUX(ADDR_ADD_OUT), .out(BUS));
	
	// Initialize DR MUX
	dr_mux dr_m(.sel(DRMUX), .IR11_9(IR[11:9]), .out(DR_MUX_OUT));
	
	// Initialize ADDR MUXES
	adr1_mux adr1_m(.sel(ADDR1MUX), .PC(PC), .SR1_out(SR1_OUT), .out(ADDR1_OUT));
	adr2_mux adr2_m(.sel(ADDR2MUX), .SEXT10_0(s10_0), .SEXT8_0(s8_0), .SEXT5_0(s5_0), .out(ADDR2_OUT));
	
	// Initialize SR MUXES
	sr1_mux sr1_m(.sel(SR1MUX), .IR11_9(IR[11:9]), .IR8_6(IR[8:6]), .out(SR1_MUX_OUT));
	sr2_mux sr2_m(.sel(SR2MUX), .SR2_out(SR2_OUT), .SEXT4_0(s4_0), .out(SR2_MUX_OUT));
	
	// Initialize MDR MUX
	mdr_mux mdr_m(.sel(MIO_EN), .bus(BUS), .mem2IO(MDR_In), .out(MDR_MUX_OUT));
	
	// Initialize Extend Modules
	sext10_0 s_10_0(.in(IR[10:0]), .out(s10_0));
	sext8_0 s_8_0(.in(IR[8:0]), .out(s8_0));
	sext5_0 s_5_0(.in(IR[5:0]), .out(s5_0));
	sext4_0 s_4_0(.in(IR[4:0]), .out(s4_0));
	zext15_0 z_15_0(.in(IR[15:0]), .out(z15_0));
	
	// Initialize Registers
	reg_16 IR_reg(.in(BUS), .clk(Clk), .reset(Reset), .load(LD_IR), .out(IR));
	reg_16 MAR_reg(.in(BUS), .clk(Clk), .reset(Reset), .load(LD_MAR), .out(MAR));
	reg_16 MDR_reg(.in(MDR_MUX_OUT), .clk(Clk), .reset(Reset), .load(LD_MDR), .out(MDR));
	reg_16 PC_reg(.in(PC_MUX_OUT), .clk(Clk), .reset(Reset), .load(LD_PC), .out(PC));
	
	//BEN Register
	BEN_reg benreg(.IR_nzp(IR[11:9]),
			.N(N), .Z(Z), .P(P),
			.Clk(Clk), .Reset(Reset), .LD_BEN(LD_BEN),
			.BEN(BEN));
	
	//ALU
	ALU ALU_unit( .sel(ALUK), .A(SR1_OUT), .B(SR2_MUX_OUT), .out(ALU_OUT));
	
	//NZP Register
	
	NZP_reg nzpreg( .LD_CC(LD_CC), .Clk(Clk), .Reset(Reset),
			.in(BUS), .N(N), .Z(Z), .P(P)) ;
	// Initialize Register File 
	RegFile reg_file (.LD_REG(LD_REG), .Reset(Reset), .Clk(Clk), 
						.in(BUS), 
						.SR1(SR1_MUX_OUT), .SR2(IR[2:0]), .DR(DR_MUX_OUT),
						.SR1_OUT(SR1_OUT), .SR2_OUT(SR2_OUT) );
						

	

	
	
endmodule