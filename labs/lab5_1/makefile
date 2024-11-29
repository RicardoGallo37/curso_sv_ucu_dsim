worklib :
	vlib ./target/sim_static/work

compile :
	vlog -sv  -work ./target/sim_static/work -l ./target/log/compile.log \
	./src/definitions_pkg.sv ./src/cnt_if.sv ./src/counter_ud.sv ./src/cnt_tb.sv

#foreign : foreign.c
#	gcc -I$(QUESTA_HOME)/include -shared -g -o foreign.so foreign.c

optimize :
	vopt +acc -work ./target/sim_static/work cnt_tb -o cnt_tb_opt

sim :
	vsim -c -do sim.do -work ./target/sim_static/work cnt_tb_opt \
	-wlf ./target/sim_static/cnt_tb_opt.wlf -logfile ./target/log/simulation.log

gui :
	vsim -view ./target/sim_static/cnt_tb_opt.wlf

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
	dsim -top cnt_tb -sv -j 10 -L work +acc +b -g -timescale 1ns/1ps -waves waves_counter_intf.mxd -build-all -dump-agg
