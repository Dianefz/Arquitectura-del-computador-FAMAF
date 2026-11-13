
module regflags (input logic clk,
						input logic write_enable,
						input logic [3:0] flags,
						output logic [3:0] q);
						
						
	logic x[3:0] = '{ 1'b0,
							1'b0,
							1'b0,
							1'b0}; 
							
	always_comb begin
		q[3] = x[3];
		q[2] = x[2];
		q[1] = x[1];
		q[0] = x[0];
	end

	
	always_ff @(posedge clk)
		if (write_enable) begin
			x[0] <= flags[0];
			x[1] <= flags[1];
			x[2] <= flags[2];
			x[3] <= flags[3];
		end
endmodule

		
						