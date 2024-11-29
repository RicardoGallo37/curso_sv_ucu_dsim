worklib :
	vlib ./target/sim_static/work

compile :
	vlog -sv  -work ./target/sim_static/work -l ./target/log/compile.log \
	./src/test/fifo_tb.sv

optimize :
	vopt +acc -work ./target/sim_static/work fifo_tb -o fifo_tb_opt

sim :
	vsim -c -do sim.do -work ./target/sim_static/work fifo_tb \
	-wlf ./target/sim_static/fifo_tb.wlf -logfile ./target/log/simulation.log

gui :
	vsim -view ./target/sim_static/fifo_tb.wlf

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
	dsim -top fifo_tb -sv -j 10 -L work +acc +b -g -timescale 1ns/1ps -waves waves_lab_7.mxd -build-all
