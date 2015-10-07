////////////////////////////////////////////////////////////////////////////////
// File: StopCounter.v
////////////////////////////////////////////////////////////////////////////////
// Version 2014-12-03 Removed started 
// Version 2015-01-25 added or posedge rst
// Version 3  2015-0902. Start is front sensitive, Y lasts for len ticks
// Version 4  2015-0907. Parametrization

`timescale 1 ns/100 ps

// Generate pulse on Y for len clocks, terminal count tc on len-th clock
// Problem: may glitch when used with CE
module StopCounter(len,start,clk,ce,rst,q,tc,y);
  parameter WIDTH = 4;
  input clk,start,rst,ce;
  input [WIDTH-1:0] len;
  output [WIDTH-1:0] q;
  reg [WIDTH-1:0] q={WIDTH{1'b0}};
  output tc;
  output y;
  reg run=0;
  reg startd=0;
  wire front;

  always @ (posedge clk or posedge rst) 
    if (rst)
      begin run <= 1'b0; q <= {WIDTH{1'b0}}; end
    else begin
      startd <= start;
      if (front) begin
          q <= {WIDTH{1'b0}};
          run <= 1;
      end
      if (ce) begin
        if (run)
          q <= q + 1'b1;
        if (tc)
          run <= 0;
      end
    end
  assign front = start & (!startd);
  assign tc = (q==len);
  assign y = run & (!tc); 
  endmodule

module StopCounter_4bit(len,start,clk,ce,rst,q,tc,y);
  parameter WIDTH = 4;
  input clk,start,rst,ce;
  input [WIDTH-1:0] len;
  output [WIDTH-1:0] q;
  output tc;
  output y;

  StopCounter #(.WIDTH(WIDTH)) u0
  (.len(len), .start(start), .clk(clk),.ce(ce),.rst(rst),.q(q),.tc(tc),.y(y));
  endmodule

module StopCounter_8bit(len,start,clk,ce,rst,q,tc,y);
  parameter WIDTH = 8;
  input clk,start,rst,ce;
  input [WIDTH-1:0] len;
  output [WIDTH-1:0] q;
  output tc;
  output y;

  StopCounter #(.WIDTH(WIDTH)) u0
  (.len(len), .start(start), .clk(clk),.ce(ce),.rst(rst),.q(q),.tc(tc),.y(y));
  endmodule

module StopCounter_16bit(len,start,clk,ce,rst,q,tc,y);
  parameter WIDTH = 16;
  input clk,start,rst,ce;
  input [WIDTH-1:0] len;
  output [WIDTH-1:0] q;
  output tc;
  output y;

  StopCounter #(.WIDTH(WIDTH)) u0
  (.len(len), .start(start), .clk(clk),.ce(ce),.rst(rst),.q(q),.tc(tc),.y(y));
  endmodule

/**/
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Testbench for iverilog:
// iverilog -odut StopCounter.v
// vvp dut|less
//
module StopCounter_tb;
reg clk,rst,start;
wire tc,y;
reg ce=0;
reg bclk=0;
reg pbclk=0;
integer state;
wire [15:0] q;

StopCounter_4bit dut (4,start,clk,ce,rst,q,tc,y);

always #1 clk <= ~clk; // clocking device
always #8 bclk <= ~bclk;
always @ (posedge clk) begin
	ce<=pbclk&(~bclk);
	//ce <= 1;
	pbclk<=bclk;
end

initial begin
  $monitor("%g\t %0d: %b %b %b %b %h %b %b",$time,state,clk,ce,rst,start,q,tc,y);
end

initial begin
  state=0;
  clk=0; rst=0; start=0;
  #1 rst=1; #1 rst=0;
  #4 start=1; #4 start=0; state=1;
  #40 start=1; #2 start=0; state=2;
  #100 $finish;
end
endmodule
/**/
