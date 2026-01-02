`include "parameter.v"

module median_3x3(
	input clk,
	input [`PIXEL_WIDTH - 1 : 0] i_p0, i_p1, i_p2,
	input [`PIXEL_WIDTH - 1 : 0] i_p3, i_p4, i_p5,
	input [`PIXEL_WIDTH - 1 : 0] i_p6, i_p7, i_p8,
	output reg [`PIXEL_WIDTH - 1 : 0] o_median
);

	// Stage 1. Find min, mid and max of each rows
	wire [`PIXEL_WIDTH - 1 : 0] w_r0_min, w_r0_mid, w_r0_max;
	wire [`PIXEL_WIDTH - 1 : 0] w_r1_min, w_r1_mid, w_r1_max;
	wire [`PIXEL_WIDTH - 1 : 0] w_r2_min, w_r2_mid, w_r2_max;

	find_min_mid_max u1(.a(i_p0), .b(i_p1), .c(i_p2), .min(w_r0_min), .mid(w_r0_mid), .max(w_r0_max));
	find_min_mid_max u2(.a(i_p3), .b(i_p4), .c(i_p5), .min(w_r1_min), .mid(w_r1_mid), .max(w_r1_max));
	find_min_mid_max u3(.a(i_p6), .b(i_p7), .c(i_p8), .min(w_r2_min), .mid(w_r2_mid), .max(w_r2_max));
	
	reg [`PIXEL_WIDTH - 1 : 0] r0_min, r0_mid, r0_max;
	reg [`PIXEL_WIDTH - 1 : 0] r1_min, r1_mid, r1_max;
	reg [`PIXEL_WIDTH - 1 : 0] r2_min, r2_mid, r2_max;
	
	// Stage 2. Find max of min column, mid of mid column and min of max column
	wire [`PIXEL_WIDTH - 1 : 0] w_max_of_min, w_mid_of_mid, w_min_of_max;
	
	find_min_mid_max u4(.a(r0_min), .b(r1_min), .c(r2_min), .max(w_max_of_min));
	find_min_mid_max u5(.a(r0_mid), .b(r1_mid), .c(r2_mid), .mid(w_mid_of_mid));
	find_min_mid_max u6(.a(r0_max), .b(r1_max), .c(r2_max), .min(w_min_of_max));
	
	reg [`PIXEL_WIDTH - 1 : 0] max_of_min, mid_of_mid, min_of_max;
	
	// Stage 3. Find median
	wire [`PIXEL_WIDTH - 1 : 0] w_median;
	find_min_mid_max u7(.a(max_of_min), .b(mid_of_mid), .c(min_of_max), .mid(w_median));
	
	always @(posedge clk) begin
		// Stage 1. Find min, mid and max of each rows
		r0_min <= w_r0_min; r0_mid <= w_r0_mid; r0_max <= w_r0_max; 
		r1_min <= w_r1_min; r1_mid <= w_r1_mid; r1_max <= w_r1_max; 
		r2_min <= w_r2_min; r2_mid <= w_r2_mid; r2_max <= w_r2_max; 
		
		// Stage 2. Find max of min column, mid of mid column and min of max column
		max_of_min <= w_max_of_min;
		mid_of_mid <= w_mid_of_mid;
		min_of_max <= w_min_of_max;
		
		// Stage 3. Find median
		o_median <= w_median;
	end
endmodule