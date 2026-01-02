`timescale 1ns/1ps
`include "parameter.v"

module tb_median_filter;
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

   reg [`PIXEL_WIDTH - 1 : 0] p0, p1, p2;
	reg [`PIXEL_WIDTH - 1 : 0] p3, p4, p5;
	reg [`PIXEL_WIDTH - 1 : 0] p6, p7, p8;
   wire [`PIXEL_WIDTH - 1 : 0] median;

   median_3x3 dut(
      .clk(clk),
      .i_p0(p0), .i_p1(p1), .i_p2(p2),
      .i_p3(p3), .i_p4(p4), .i_p5(p5),
      .i_p6(p6), .i_p7(p7), .i_p8(p8),
      .o_median(median)
   );

   wire is_top = (y == 0);
   wire is_bottom = (y == `IMAGE_HEIGHT-1);
   wire is_left = (x == 0);
   wire is_right  = (x == `IMAGE_WIDTH-1); 
	reg done;
	
	initial begin
		clk = 0;
		rst_n = 0;
		#20;
		rst_n = 1;
	end

   always @(posedge clk) begin
		if (!rst_n) begin
			x <= 0; y <= 0; i <= 0; done <= 0;
			p0 <= 0; p1 <= 0; p2 <= 0;
			p3 <= 0; p4 <= 0; p5 <= 0;
			p6 <= 0; p7 <= 0; p8 <= 0;
		end 
		else begin
			if ((x == 0 && y == 0) ||(x == `IMAGE_WIDTH - 1 && y == 0) || 
		       (x == 0 && y == `IMAGE_HEIGHT - 1) || (x == `IMAGE_WIDTH - 1 && y == `IMAGE_HEIGHT - 1)) begin
				p0 <= mem[y * `IMAGE_WIDTH + x]; p1 <= mem[y * `IMAGE_WIDTH + x]; p2 <= mem[y * `IMAGE_WIDTH + x];
            p3 <= mem[y * `IMAGE_WIDTH + x]; p4 <= mem[y * `IMAGE_WIDTH + x]; p5 <= mem[y * `IMAGE_WIDTH + x];
            p6 <= mem[y * `IMAGE_WIDTH + x]; p7 <= mem[y * `IMAGE_WIDTH + x]; p8 <= mem[y * `IMAGE_WIDTH + x];
			end

			else if (is_top || is_bottom) begin
            p0 <= mem[y * `IMAGE_WIDTH + (x - 1)]; p1 <= mem[y * `IMAGE_WIDTH + (x)]; p2 <= mem[y * `IMAGE_WIDTH + (x + 1)];
				p3 <= mem[y * `IMAGE_WIDTH + (x - 1)]; p4 <= mem[y * `IMAGE_WIDTH + (x)]; p5 <= mem[y * `IMAGE_WIDTH + (x + 1)];
				p6 <= mem[y * `IMAGE_WIDTH + (x - 1)]; p7 <= mem[y * `IMAGE_WIDTH + (x)]; p8 <= mem[y * `IMAGE_WIDTH + (x + 1)];
			end

			else if (is_left || is_right) begin
            p0 <= mem[(y - 1) * `IMAGE_WIDTH + x]; p1 <= mem[(y - 1) * `IMAGE_WIDTH + x]; p2 <= mem[(y - 1) * `IMAGE_WIDTH + x];
            p3 <= mem[(y) * `IMAGE_WIDTH + x]; p4 <= mem[(y) * `IMAGE_WIDTH + x]; p5 <= mem[(y) * `IMAGE_WIDTH + x];
            p6 <= mem[(y + 1) * `IMAGE_WIDTH + x]; p7 <= mem[(y + 1) * `IMAGE_WIDTH + x]; p8 <= mem[(y + 1) * `IMAGE_WIDTH + x];
			end

			else begin
            p0 <= mem[(y-1) * `IMAGE_WIDTH + (x-1)]; p1 <= mem[(y-1) * `IMAGE_WIDTH + (x)]; p2 <= mem[(y-1) * `IMAGE_WIDTH + (x+1)];
            p3 <= mem[(y) * `IMAGE_WIDTH + (x-1)]; p4 <= mem[(y) * `IMAGE_WIDTH + (x)]; p5 <= mem[(y) * `IMAGE_WIDTH + (x+1)];
				p6 <= mem[(y+1) * `IMAGE_WIDTH + (x-1)]; p7 <= mem[(y+1) * `IMAGE_WIDTH + (x)]; p8 <= mem[(y+1) * `IMAGE_WIDTH + (x+1)];
			end

			if (i >= 4) out_mem[i-4] <= median;
			i <= i + 1;

			if (x == `IMAGE_WIDTH-1) begin
				x <= 0;
            if (y == `IMAGE_HEIGHT-1) begin
					y <= 0;
					done <= 1;
            end
            else y <= y + 1;
        end
        else x <= x + 1;
		end
	end

   initial begin
      wait(done == 1'b1);
		repeat (5) @(posedge clk);
      $writememh("D:/02_UniversityOfInformationTechnology/00_CE213_DigitalSystemDesignWithHDL/LAB02/verilog.hex", out_mem);
      $finish;
   end

endmodule