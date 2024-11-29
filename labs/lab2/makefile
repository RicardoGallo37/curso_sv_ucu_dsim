worklib :
	vlib ./target/sim_static/work

compile :
	vlog -sv  -work ./target/sim_static/work -l ./target/log/compile.log ./src/counter_ud.sv ./src/counter_ud_tb.sv

optimize :
	vopt +acc -work ./target/sim_static/work counter_ud_tb -o counter_ud_tb_opt

sim :
	vsim -c -do sim.do -work ./target/sim_static/work counter_ud_tb_opt \
	-wlf ./target/sim_static/counter_ud_tb_opt.wlf -logfile ./target/log/simulation.log

gui :
	vsim -view ./target/sim_static/counter_ud_tb_opt.wlf

all : setup_sim worklib compile optimize sim
	

clean :
	rm -rf ./target
	rm -rf ./dsim_work

setup_sim :
	mkdir -p target/log
	mkdir -p target/sim_static

run_dsim :
	mkdir -p dsim_work
	cd dsim_work
	dvlcom -sv -F ./filelist
	dsim -top counter_ud_tb -sv -j 10 -L work +acc +b -g -timescale 1ns/1ps -waves waves_counter.mxd -build-all
