module bCondCheck (input logic [3:0] sel,
				input logic [3:0] flags,
				output logic cond);
										
	always_comb begin
		case(sel)
			5'd0: cond = flags[3];
			5'd1: cond = ~flags[3];
			5'd2: cond = flags[1];
			5'd3: cond = ~flags[1];
			5'd4: cond = flags[2];
			5'd5: cond = ~flags[2];
			5'd6: cond = flags[0];
			5'd7: cond = ~flags[0];
			5'd8: cond = flags[1] & ~flags[3];
			5'd9: cond = ~flags[1] | flags[3];
			5'd10: cond = (flags[2] == flags[0]);
			5'd11: cond = (flags[2] != flags[0]);
			5'd12: cond = ~flags[3] & (flags[2] == flags[0]);
			5'd13: cond = flags[3] | (flags[2] != flags[0]);
			5'd14: cond = 0;
			5'd15: cond = 0;
		endcase
	end
endmodule