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

setup_sim :
	mkdir -p target/log
	mkdir -p target/sim_static
