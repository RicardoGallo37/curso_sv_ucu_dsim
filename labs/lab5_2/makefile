worklib :
	vlib ./target/sim_static/work

compile :
	vlog -sv  -work ./target/sim_static/work -l ./target/log/compile.log \
	./src/test_FIFO.sv

#foreign : foreign.c
#	gcc -I$(QUESTA_HOME)/include -shared -g -o foreign.so foreign.c

optimize :
	vopt +acc -work ./target/sim_static/work test_FIFO -o test_FIFO_opt

sim :
	vsim -c -do sim.do -work ./target/sim_static/work test_FIFO_opt \
	-wlf ./target/sim_static/test_FIFO_opt.wlf -logfile ./target/log/simulation.log

gui :
	vsim -view ./target/sim_static/test_FIFO_opt.wlf

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
	dsim -top test_FIFO -sv -j 10 -L work +acc +b -g -timescale 1ns/100ps -waves waves_FIFO_lab_5_2.mxd -build-all
