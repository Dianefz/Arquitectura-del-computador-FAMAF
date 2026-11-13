module signext (
	input logic [31:0] a,
	output logic [63:0] y
);
	logic [10:0] opcode;
	always_comb begin
		opcode = a[31:21];
		casez (opcode)
			11'b111_1100_0010: y = {{55{a[20]}}, a[20:12]};  //LDUR
			11'b111_1100_0000: y = {{55{a[20]}}, a[20:12]};  //STUR
			11'b101_1010_0???: y = {{45{a[23]}}, a[23:5]};   //CBZ
			11'b010_1010_0???: y = {{45{a[23]}}, a[23:5]};   //(2)B.cond
			11'b100_1000_100?, 11'b110_1000_100?, 11'b111_1000_100?, 11'b101_1000_100?: y = {{52{1'b0}}, a[21:10]}; //(1)ADDI, SUBI, (2)ADDIS, SUBIS
			default: y = 0;
		endcase
	end
endmodule