GHDL ?= ghdl
STD  := --std=08

.PHONY: build test wave clean

build:
	$(GHDL) -a $(STD) rtl/alu4.vhd tb/tb_alu4.vhd
	$(GHDL) -e $(STD) tb_alu4

test: build
	$(GHDL) -r $(STD) tb_alu4 --assert-level=error

wave: build
	$(GHDL) -r $(STD) tb_alu4 --assert-level=error --vcd=alu4.vcd

clean:
	rm -f work-obj08.cf tb_alu4 alu4.vcd
