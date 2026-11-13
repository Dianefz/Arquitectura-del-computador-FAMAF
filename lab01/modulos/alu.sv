module alu #(parameter N = 64) (
	input logic [63:0] a, b,
	input logic [3:0] ALUControl,
	output logic [63:0] result,
	output logic zero, Negative, Carry, oVerflow,
	output logic write_flags
);
	logic [63:0] complement_b;

	always_comb begin
		complement_b = (~b + 1);
		casez (ALUControl)
				
		4'b0000: begin
			result = a & b;
			Carry = 0;
			oVerflow = 0;
			write_flags = 0;
		end
		4'b0001: begin
			result = a | b;
			Carry = 0;
			oVerflow = 0;
			write_flags = 0;
		end
		4'b0010: begin 
			result = a + b;
			Carry = 0;
			oVerflow = 0;
			write_flags = 0;
		end 
		4'b0110: begin 
			result = a + complement_b;
			Carry = 0;
			oVerflow = 0;
			write_flags = 0;
		end
		4'b0111: begin 
			result = b;
			Carry = 0;
			oVerflow = 0;
			write_flags = 0;
		end
		4'b1010: begin
			result = a + b;
			Carry = (a[N-1] & b[N-1]) | ((a[N-1] ^ b[N-1]) & ~result[N-1]);
			oVerflow = ((a[N-1] == b[N-1]) & (result[N-1] != a[N-1]));
			write_flags = 1;
		end
		4'b1110: begin
			result = a + complement_b;
			Carry = (a[N-1] & complement_b[N-1]) | ((a[N-1] ^ complement_b[N-1]) & ~result[N-1]);
			oVerflow = ((a[N-1] == complement_b[N-1]) & (result[N-1] != a[N-1]));
			write_flags = 1;
		end		
		default: begin 
			result = 64'b0;
			Carry = 0;
			oVerflow = 0;
			write_flags = 0;
		end
		
	endcase
	
zero = (result == 64'b0);
Negative = result[N-1];
end 
endmodule
