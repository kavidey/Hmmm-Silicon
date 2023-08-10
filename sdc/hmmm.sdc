###############################################################################
# Created by write_sdc
# Thu Aug 10 05:06:52 2023
###############################################################################
current_design hmmm
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 25.0000 
set_clock_uncertainty 0.2500 clk
set_clock_latency -source -min 4.6500 [get_clocks {clk}]
set_clock_latency -source -max 5.5700 [get_clocks {clk}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.1900 [get_ports {halt}]
set_load -pin_load 0.1900 [get_ports {read}]
set_load -pin_load 0.1900 [get_ports {write}]
set_load -pin_load 0.1900 [get_ports {oeb[15]}]
set_load -pin_load 0.1900 [get_ports {oeb[14]}]
set_load -pin_load 0.1900 [get_ports {oeb[13]}]
set_load -pin_load 0.1900 [get_ports {oeb[12]}]
set_load -pin_load 0.1900 [get_ports {oeb[11]}]
set_load -pin_load 0.1900 [get_ports {oeb[10]}]
set_load -pin_load 0.1900 [get_ports {oeb[9]}]
set_load -pin_load 0.1900 [get_ports {oeb[8]}]
set_load -pin_load 0.1900 [get_ports {oeb[7]}]
set_load -pin_load 0.1900 [get_ports {oeb[6]}]
set_load -pin_load 0.1900 [get_ports {oeb[5]}]
set_load -pin_load 0.1900 [get_ports {oeb[4]}]
set_load -pin_load 0.1900 [get_ports {oeb[3]}]
set_load -pin_load 0.1900 [get_ports {oeb[2]}]
set_load -pin_load 0.1900 [get_ports {oeb[1]}]
set_load -pin_load 0.1900 [get_ports {oeb[0]}]
set_load -pin_load 0.1900 [get_ports {out[15]}]
set_load -pin_load 0.1900 [get_ports {out[14]}]
set_load -pin_load 0.1900 [get_ports {out[13]}]
set_load -pin_load 0.1900 [get_ports {out[12]}]
set_load -pin_load 0.1900 [get_ports {out[11]}]
set_load -pin_load 0.1900 [get_ports {out[10]}]
set_load -pin_load 0.1900 [get_ports {out[9]}]
set_load -pin_load 0.1900 [get_ports {out[8]}]
set_load -pin_load 0.1900 [get_ports {out[7]}]
set_load -pin_load 0.1900 [get_ports {out[6]}]
set_load -pin_load 0.1900 [get_ports {out[5]}]
set_load -pin_load 0.1900 [get_ports {out[4]}]
set_load -pin_load 0.1900 [get_ports {out[3]}]
set_load -pin_load 0.1900 [get_ports {out[2]}]
set_load -pin_load 0.1900 [get_ports {out[1]}]
set_load -pin_load 0.1900 [get_ports {out[0]}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 1.0000 [current_design]
set_max_fanout 16.0000 [current_design]
