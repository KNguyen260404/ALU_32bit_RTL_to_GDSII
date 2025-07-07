###############################################################################
# ALU Design Constraints
# Created for OpenLane flow
###############################################################################

# Clock definition
create_clock -name clk -period 3.33 [get_ports clk]

# Input delays
set_input_delay -clock clk -max 1.0 [get_ports operand_a*]
set_input_delay -clock clk -max 1.0 [get_ports operand_b*]
set_input_delay -clock clk -max 0.8 [get_ports alu_control*]
set_input_delay -clock clk -max 0.8 [get_ports shift_amount*]
set_input_delay -clock clk -max 0.5 [get_ports is_signed]

# Output delays
set_output_delay -clock clk -max 1.0 [get_ports result*]
set_output_delay -clock clk -max 0.5 [get_ports zero]
set_output_delay -clock clk -max 0.5 [get_ports overflow]

# Multicycle paths for pipelined operations
set_multicycle_path 3 -setup -from [get_ports operand_a*] -to [get_ports result*] -through [get_cells *multiplier*]
set_multicycle_path 2 -hold -from [get_ports operand_a*] -to [get_ports result*] -through [get_cells *multiplier*]
set_multicycle_path 4 -setup -from [get_ports operand_a*] -to [get_ports result*] -through [get_cells *divider*]
set_multicycle_path 3 -hold -from [get_ports operand_a*] -to [get_ports result*] -through [get_cells *divider*]

# Clock uncertainty
set_clock_uncertainty 0.1 [get_clocks clk]

# Clock transition
set_clock_transition 0.15 [get_clocks clk]

# Load capacitance
set_load 0.05 [all_outputs]

# Driving cell
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 [all_inputs]

# Max fanout
set_max_fanout 5 [current_design]

# Max transition
set_max_transition 0.75 [current_design]

# False paths
set_false_path -from [get_ports reset]

# Area constraints
set_max_area 0

# Power optimization
set_max_leakage_power 0.1
set_max_dynamic_power 1.0

###############################################################################
# End of constraints
###############################################################################
