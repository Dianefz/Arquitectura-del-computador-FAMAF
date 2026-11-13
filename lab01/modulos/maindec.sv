module maindec (
	input logic [10:0] Op,
	output logic Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, condBranch,
	output logic [1:0] ALUOp
);
	always_comb begin
		condBranch = 0;
		casez (Op)
			11'b100_0101_1000, 11'b110_0101_1000, 11'b100_0101_0000,
			11'b101_0101_0000, 11'b101_0101_1000, 11'b111_0101_1000:  //R-format
				{Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
				Branch, ALUOp} = 9'b0001000_10;
			11'b111_1100_0010:  //LDUR
				{Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
				Branch, ALUOp} = 9'b0111100_00;
			11'b111_1100_0000:  //STUR
				{Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
				Branch, ALUOp} = 9'b1100010_00;
			11'b101_1010_0???:  //CBZ
				{Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
				Branch, ALUOp} = 9'b1000001_01;
			11'b100_1000_100?, 11'b110_1000_100?, 11'b111_1000_100?, 11'b101_1000_100?:  //(1)(ADDI, SUBI), (2)(ADDIS, SUBIS)
				{Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
				Branch, ALUOp} = 9'b0101000_10;
			11'b010_1010_0???:
				{Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
				Branch, ALUOp, condBranch} = 10'b0100000_10_1;  //(2)B.cond 
			default:
				{Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
				Branch, ALUOp} = 9'b0000000_00;
		endcase
	end

endmodule