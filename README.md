# verilog_modules
Collection of Verilog modules, implemented in FPGA.

random_pulse_generator.v
// Poisson process generator. 
// Generate Poisson process with desired inversed rate (number of clocks per hit).
// The rate is defined by parameter LN2_PERIOD. For example, the LN2_PERIOD=4 will generate 
// in average one pulse per 16 clocks.

StopCounter(len,start,clk,ce,rst,q,tc,y);
// Generate pulse on Y for len clocks, terminal count tc on len-th clock

