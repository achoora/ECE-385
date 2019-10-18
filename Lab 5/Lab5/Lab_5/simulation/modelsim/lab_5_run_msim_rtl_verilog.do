transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/Pouya/Desktop/Lab5/Lab_5 {C:/Users/Pouya/Desktop/Lab5/Lab_5/control_unit.sv}
vlog -sv -work work +incdir+C:/Users/Pouya/Desktop/Lab5/Lab_5 {C:/Users/Pouya/Desktop/Lab5/Lab_5/nine_bit_adder.sv}
vlog -sv -work work +incdir+C:/Users/Pouya/Desktop/Lab5/Lab_5 {C:/Users/Pouya/Desktop/Lab5/Lab_5/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/Pouya/Desktop/Lab5/Lab_5 {C:/Users/Pouya/Desktop/Lab5/Lab_5/full_adder.sv}
vlog -sv -work work +incdir+C:/Users/Pouya/Desktop/Lab5/Lab_5 {C:/Users/Pouya/Desktop/Lab5/Lab_5/eight_shift_register.sv}
vlog -sv -work work +incdir+C:/Users/Pouya/Desktop/Lab5/Lab_5 {C:/Users/Pouya/Desktop/Lab5/Lab_5/sync.sv}
vlog -sv -work work +incdir+C:/Users/Pouya/Desktop/Lab5/Lab_5 {C:/Users/Pouya/Desktop/Lab5/Lab_5/one_register.sv}
vlog -sv -work work +incdir+C:/Users/Pouya/Desktop/Lab5/Lab_5 {C:/Users/Pouya/Desktop/Lab5/Lab_5/Processor.sv}

vlog -sv -work work +incdir+C:/Users/Pouya/Desktop/Lab5/Lab_5 {C:/Users/Pouya/Desktop/Lab5/Lab_5/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 1000 ns