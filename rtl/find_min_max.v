`include "parameter.v"

module find_min_max(
	input [`PIXEL_WIDTH - 1 : 0] a,
	input [`PIXEL_WIDTH - 1 : 0] b,
	output [`PIXEL_WIDTH - 1 : 0] min,
	output [`PIXEL_WIDTH - 1 : 0] max
);

	assign min = (a > b) ? b : a;
	assign max = (a > b) ? a : b;

endmodule