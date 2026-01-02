`timescale 1ns/1ps
`include "parameter.v"

module tb_median_filter_pro;
   reg clk;
   reg rst_n;
   reg [`PIXEL_WIDTH - 1 : 0] mem [0 : `TOTAL_PIXELS - 1];
   reg [`PIXEL_WIDTH - 1 : 0] out_mem [0 : `TOTAL_PIXELS - 1];
   
   initial begin
      $readmemh("D:/02_UniversityOfInformationTechnology/00_CE213_DigitalSystemDesignWithHDL/LAB02/input.hex", mem);
   end

   always #5 clk = ~clk;

   reg [`X_WIDTH : 0] x;   
   reg [`Y_WIDTH : 0] y;   
   integer i;

   reg [`PIXEL_WIDTH - 1 : 0] p0_e, p1_e, p2_e, p3_e, p4_e, p5_e, p6_e, p7_e, p8_e;
   reg [`PIXEL_WIDTH - 1 : 0] p0_o, p1_o, p2_o, p3_o, p4_o, p5_o, p6_o, p7_o, p8_o;
   wire [`PIXEL_WIDTH - 1 : 0] median_e, median_o;

   median_3x3 dut_even(
      .clk(clk),
      .i_p0(p0_e), .i_p1(p1_e), .i_p2(p2_e), 
		.i_p3(p3_e), .i_p4(p4_e), .i_p5(p5_e), 
      .i_p6(p6_e), .i_p7(p7_e), .i_p8(p8_e),
      .o_median(median_e)
   );

   median_3x3 dut_odd(
      .clk(clk),
      .i_p0(p0_o), .i_p1(p1_o), .i_p2(p2_o), 
		.i_p3(p3_o), .i_p4(p4_o), .i_p5(p5_o), 
      .i_p6(p6_o), .i_p7(p7_o), .i_p8(p8_o),
      .o_median(median_o)
   );

   wire is_top    = (y == 0);
   wire is_bottom = (y == `IMAGE_HEIGHT-1);
   wire is_left_e   = (x == 0);
   wire is_right_o  = ((x + 1) == `IMAGE_WIDTH-1);

   reg done;
   
   initial begin
      clk = 0; rst_n = 0;
      #20; rst_n = 1;
   end

   always @(posedge clk) begin
      if (!rst_n) begin
         x <= 0; y <= 0; i <= 0; done <= 0;
         p0_e <= 0; p1_e <= 0; p2_e <= 0; p3_e <= 0; p4_e <= 0; p5_e <= 0; p6_e <= 0; p7_e <= 0; p8_e <= 0;
         p0_o <= 0; p1_o <= 0; p2_o <= 0; p3_o <= 0; p4_o <= 0; p5_o <= 0; p6_o <= 0; p7_o <= 0; p8_o <= 0;
      end 
      else begin
         if ((is_left_e && is_top) || (is_left_e && is_bottom)) begin 
            p0_e <= mem[y*`IMAGE_WIDTH + x]; p1_e <= mem[y*`IMAGE_WIDTH + x]; p2_e <= mem[y*`IMAGE_WIDTH + x]; 
            p3_e <= mem[y*`IMAGE_WIDTH + x]; p4_e <= mem[y*`IMAGE_WIDTH + x]; p5_e <= mem[y*`IMAGE_WIDTH + x]; 
            p6_e <= mem[y*`IMAGE_WIDTH + x]; p7_e <= mem[y*`IMAGE_WIDTH + x]; p8_e <= mem[y*`IMAGE_WIDTH + x];
         end
         else if (is_top || is_bottom) begin
            p0_e <= mem[y*`IMAGE_WIDTH + (x-1)]; p1_e <= mem[y*`IMAGE_WIDTH + (x)]; p2_e <= mem[y*`IMAGE_WIDTH + (x+1)];
            p3_e <= mem[y*`IMAGE_WIDTH + (x-1)]; p4_e <= mem[y*`IMAGE_WIDTH + (x)]; p5_e <= mem[y*`IMAGE_WIDTH + (x+1)];
            p6_e <= mem[y*`IMAGE_WIDTH + (x-1)]; p7_e <= mem[y*`IMAGE_WIDTH + (x)]; p8_e <= mem[y*`IMAGE_WIDTH + (x+1)];
         end
         else if (is_left_e) begin
            p0_e <= mem[(y-1)*`IMAGE_WIDTH + x]; p1_e <= mem[(y-1)*`IMAGE_WIDTH + x]; p2_e <= mem[(y-1)*`IMAGE_WIDTH + x];
            p3_e <= mem[(y)*`IMAGE_WIDTH + x];   p4_e <= mem[(y)*`IMAGE_WIDTH + x];   p5_e <= mem[(y)*`IMAGE_WIDTH + x];
            p6_e <= mem[(y+1)*`IMAGE_WIDTH + x]; p7_e <= mem[(y+1)*`IMAGE_WIDTH + x]; p8_e <= mem[(y+1)*`IMAGE_WIDTH + x];
         end
         else begin
            p0_e <= mem[(y-1)*`IMAGE_WIDTH + (x-1)]; p1_e <= mem[(y-1)*`IMAGE_WIDTH + (x)]; p2_e <= mem[(y-1)*`IMAGE_WIDTH + (x+1)];
            p3_e <= mem[(y)*`IMAGE_WIDTH + (x-1)];   p4_e <= mem[(y)*`IMAGE_WIDTH + (x)];   p5_e <= mem[(y)*`IMAGE_WIDTH + (x+1)];
            p6_e <= mem[(y+1)*`IMAGE_WIDTH + (x-1)]; p7_e <= mem[(y+1)*`IMAGE_WIDTH + (x)]; p8_e <= mem[(y+1)*`IMAGE_WIDTH + (x+1)];
         end

         if ((is_right_o && is_top) || (is_right_o && is_bottom)) begin
            p0_o <= mem[y*`IMAGE_WIDTH + (x+1)]; p1_o <= mem[y*`IMAGE_WIDTH + (x+1)]; p2_o <= mem[y*`IMAGE_WIDTH + (x+1)]; 
            p3_o <= mem[y*`IMAGE_WIDTH + (x+1)]; p4_o <= mem[y*`IMAGE_WIDTH + (x+1)]; p5_o <= mem[y*`IMAGE_WIDTH + (x+1)]; 
            p6_o <= mem[y*`IMAGE_WIDTH + (x+1)]; p7_o <= mem[y*`IMAGE_WIDTH + (x+1)]; p8_o <= mem[y*`IMAGE_WIDTH + (x+1)];
         end
         else if (is_top || is_bottom) begin
            p0_o <= mem[y*`IMAGE_WIDTH + ((x+1)-1)]; p1_o <= mem[y*`IMAGE_WIDTH + (x+1)]; p2_o <= mem[y*`IMAGE_WIDTH + ((x+1)+1)];
            p3_o <= mem[y*`IMAGE_WIDTH + ((x+1)-1)]; p4_o <= mem[y*`IMAGE_WIDTH + (x+1)]; p5_o <= mem[y*`IMAGE_WIDTH + ((x+1)+1)];
            p6_o <= mem[y*`IMAGE_WIDTH + ((x+1)-1)]; p7_o <= mem[y*`IMAGE_WIDTH + (x+1)]; p8_o <= mem[y*`IMAGE_WIDTH + ((x+1)+1)];
         end
         else if (is_right_o) begin
            p0_o <= mem[(y-1)*`IMAGE_WIDTH + (x+1)]; p1_o <= mem[(y-1)*`IMAGE_WIDTH + (x+1)]; p2_o <= mem[(y-1)*`IMAGE_WIDTH + (x+1)];
            p3_o <= mem[(y)*`IMAGE_WIDTH + (x+1)];   p4_o <= mem[(y)*`IMAGE_WIDTH + (x+1)];   p5_o <= mem[(y)*`IMAGE_WIDTH + (x+1)];
            p6_o <= mem[(y+1)*`IMAGE_WIDTH + (x+1)]; p7_o <= mem[(y+1)*`IMAGE_WIDTH + (x+1)]; p8_o <= mem[(y+1)*`IMAGE_WIDTH + (x+1)];
         end
         else begin
            p0_o <= mem[(y-1)*`IMAGE_WIDTH + ((x+1)-1)]; p1_o <= mem[(y-1)*`IMAGE_WIDTH + (x+1)]; p2_o <= mem[(y-1)*`IMAGE_WIDTH + ((x+1)+1)];
            p3_o <= mem[(y)*`IMAGE_WIDTH + ((x+1)-1)];   p4_o <= mem[(y)*`IMAGE_WIDTH + (x+1)];   p5_o <= mem[(y)*`IMAGE_WIDTH + ((x+1)+1)];
            p6_o <= mem[(y+1)*`IMAGE_WIDTH + ((x+1)-1)]; p7_o <= mem[(y+1)*`IMAGE_WIDTH + (x+1)]; p8_o <= mem[(y+1)*`IMAGE_WIDTH + ((x+1)+1)];
         end

         if (i >= 8) begin
            out_mem[i-8]     <= median_e;
            out_mem[(i-8)+1] <= median_o;
         end
         i <= i + 2;

         if (x >= `IMAGE_WIDTH-2) begin 
            x <= 0;
            if (y == `IMAGE_HEIGHT-1) begin
               y <= 0;
               done <= 1;
            end
            else y <= y + 1;
         end
         else x <= x + 2;
      end
   end

   initial begin
      wait(done == 1'b1);
      repeat (10) @(posedge clk);
      $writememh("D:/02_UniversityOfInformationTechnology/00_CE213_DigitalSystemDesignWithHDL/LAB02/verilog.hex", out_mem);
      $finish;
   end
endmodule