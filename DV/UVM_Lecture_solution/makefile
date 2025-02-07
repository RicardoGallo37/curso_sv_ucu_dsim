DVLCOM_CMD = dvlcom -sv -F $(REPO_PATH)/Tops/FIFO_top/fifo_list.f -uvm 1.2
DSIM_CMD = dsim -j 10 -build-all -top work.fifo_top -waves ./waves.vcd -dump-agg -l dsim.log -L work +acc+b -info UdpExpectAllEdgesAllInputs -info TimeCheckNonPortEvt +UVM_VERBOSITY=UVM_HIGH +UVM_OBJECTION_TRACE +UVM_COMPONENT_CREATION_TRACE -uvm 1.2 

ALL:
	@mkdir -p work_dir/test; cd work_dir/test; $(DVLCOM_CMD); $(DSIM_CMD);

COMPILE:
	@mkdir -p work_dir/test; cd work_dir/test; $(DVLCOM_CMD);

RUN:
	@cd work_dir/test; $(DSIM_CMD);

CLEAN:
	@rm -r work_dir/*