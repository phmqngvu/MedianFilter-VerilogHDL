`include "parameter.v"

module find_min_mid_max(
	input [`PIXEL_WIDTH - 1 : 0] a,
	input [`PIXEL_WIDTH - 1 : 0] b,
	input [`PIXEL_WIDTH - 1 : 0] c,
	output [`PIXEL_WIDTH - 1 : 0] min,
	output [`PIXEL_WIDTH - 1 : 0] mid,
	output [`PIXEL_WIDTH - 1 : 0] max
);

	wire [`PIXEL_WIDTH - 1 : 0] ab_min;
	wire [`PIXEL_WIDTH - 1 : 0] ab_max;
	wire [`PIXEL_WIDTH - 1 : 0] mid_temp;

	find_min_max u1(.a(a), .b(b), .min(ab_min), .max(ab_max));
	find_min_max u2(.a(ab_max), .b(c), .min(mid_temp), .max(max));
	find_min_max u3(.a(ab_min), .b(mid_temp), .min(min), .max(mid));

endmodule



