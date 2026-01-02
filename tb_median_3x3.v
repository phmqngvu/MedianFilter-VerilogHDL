`include "parameter.v"
`timescale 1ns/1ps

module tb_median_3x3();
   reg clk;
   reg [`PIXEL_WIDTH - 1 : 0] p0, p1, p2;
   reg [`PIXEL_WIDTH - 1 : 0] p3, p4, p5;
   reg [`PIXEL_WIDTH - 1 : 0] p6, p7, p8;
   wire [`PIXEL_WIDTH - 1 : 0] median;

   median_3x3 dut (
      .clk(clk),
      .i_p0(p0), .i_p1(p1), .i_p2(p2),
      .i_p3(p3), .i_p4(p4), .i_p5(p5),
      .i_p6(p6), .i_p7(p7), .i_p8(p8),
      .o_median(median)
   );

   initial begin
      clk = 0;
      forever #5 clk = ~clk;
   end

   initial begin
      p0=0; p1=0; p2=0; p3=0; p4=0; p5=0; p6=0; p7=0; p8=0;
      #20;

      @(negedge clk);
      p0=1; p1=2; p2=3;
      p3=4; p4=5; p5=6;
      p6=7; p7=8; p8=9;

      @(negedge clk);
      p0=10;  p1=01; p2=30;
      p3=50;  p4=90;  p5=20;
      p6=150; p7=40;  p8=5;

      @(negedge clk);
      p0=0;   p1=0;   p2=255;
      p3=255; p4=100; p5=0;
      p6=255; p7=0;   p8=255;
		
		@(negedge clk);
      p0=1;   p1=100; p2=101;
      p3=1;   p4=102; p5=103;
      p6=1;   p7=104; p8=105;
		
		@(negedge clk);
      p0=255; p1=255; p2=255;
      p3=255; p4=255; p5=255;
      p6=255; p7=255; p8=255;
      
      @(negedge clk);
      p0=0; p1=0; p2=0; p3=0; p4=0; p5=0; p6=0; p7=0; p8=0;

      #100;
      $finish;
   end
   
   always @(posedge clk) begin
      #1;
      if (median != 0)
         $display("Time: %t | Median Out: %d", $time, median);
   end

endmodule