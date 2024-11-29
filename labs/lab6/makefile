worklib :
	vlib ./target/sim_static/work

compile :
	vlog -sv  -work ./target/sim_static/work -l ./target/log/compile.log \
	./src/test/tb.sv

optimize :
	vopt +acc -work ./target/sim_static/work tb -o tb_opt

sim :
	vsim -c -do sim.do -work ./target/sim_static/work tb_opt \
	-wlf ./target/sim_static/tb_opt.wlf -logfile ./target/log/simulation.log

all : setup_sim worklib compile optimize sim

gui :
	vsim -view ./target/sim_static/tb_opt.wlf

clean :
	rm -rf ./target
	rm -rf ./dsim_work

setup_sim :
	mkdir -p target/log
	mkdir -p target/sim_static
	. ./setup.sh

run_dsim :
	mkdir -p dsim_work
	cd dsim_work
	dvlcom -sv -F ./filelist
	dsim -top tb -sv -j 10 -L work +acc +b -g -timescale 1ns/1ps -waves waves_reg_lab_6.mxd -build-all
