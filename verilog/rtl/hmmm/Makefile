#------------------------------------------------------------------------------
# Simple makefile to simulate Verilog HDL designs under OSX.
# Modify the variables below to suit your own files.
#------------------------------------------------------------------------------
# <ihsan@kehribar.me> - 2016
#------------------------------------------------------------------------------
TESTBENCH = hmmm_tb
SRCS	  = hmmm.v alu/alu.v control/control.v ir/ir.v pc/pc.v ram/mar.v ram/ram.v ram/mdr.v register/register.v register/register_file.v

#------------------------------------------------------------------------------
# You should't be changing what is below
#------------------------------------------------------------------------------
all: simulate

lint:
	verilator --lint-only $(SRCS)

simulate:
	iverilog -o $(TESTBENCH).vvp $(SRCS) $(TESTBENCH).v
	vvp $(TESTBENCH).vvp > $(TESTBENCH)_log.txt

gtkwave: simulate
	gtkwave $(TESTBENCH).vcd

scansion: simulate
	open /Applications/Scansion.app $(TESTBENCH).vcd

clean:
	rm -rf $(TESTBENCH).vvp $(TESTBENCH).vcd $(TESTBENCH)_log.txt
