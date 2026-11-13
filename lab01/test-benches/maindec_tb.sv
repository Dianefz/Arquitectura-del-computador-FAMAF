module maindec_tb();
	parameter TESTVECTOR_BITS = 11 + 7 + 2;
	parameter TESTCASES = 100;

	logic clk;

	// input
	logic [10:0] Op;
	// output
	logic Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
	logic [1:0] ALUOp;

	logic [31:0] vectornum, errors;
	logic [TESTVECTOR_BITS-1:0] testvectors [0:TESTCASES-1];

	// expected output
	logic e_Reg2Loc, e_ALUSrc, e_MemtoReg, e_RegWrite, e_MemRead, e_MemWrite,
		e_Branch;
	logic [1:0] e_ALUOp;

	// instantiate device under test
	maindec dut(Op, Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
		Branch, ALUOp);

	// generate clock
	always // no sensitivity list, so it always executes
		begin
			#10ns; clk = ~clk;
		end

	// at start of test pulse reset
	initial
		begin
			// Busca en el path simulation/modelsim/
			$readmemb("testvectors/maindec_testvectors", testvectors);
			clk = 1;
			vectornum = 0;
			errors = 0;
		end

	// apply test vectors on rising edge of clk
	always @(posedge clk)
		begin
			#1ns;
			{Op, e_Reg2Loc, e_ALUSrc, e_MemtoReg, e_RegWrite, e_MemRead,
			e_MemWrite, e_Branch, e_ALUOp} = testvectors[vectornum];
		end

	// check results on falling edge of clk
	always @(negedge clk)
		begin
			if ({Reg2Loc, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite,
				Branch, ALUOp} !== {e_Reg2Loc, e_ALUSrc, e_MemtoReg,
				e_RegWrite, e_MemRead, e_MemWrite, e_Branch, e_ALUOp}) begin
				$display("error: vectornum %d", vectornum);
				errors += 1;
			end
			vectornum = vectornum + 1;
			if (testvectors[vectornum] === {TESTVECTOR_BITS{1'bx}}) begin
				$display("%d tests completed with %d errors", vectornum, errors);
				$stop;
			end
		end
endmodule
