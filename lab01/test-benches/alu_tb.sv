module alu_tb();
	parameter N = 64;
	parameter TESTVECTOR_BITS = 64 + 64 + 4 + 64 + 1;
	parameter TESTCASES = 100;
	logic [N-1:0] a, b;
	logic [3:0] ALUControl;
	logic [N-1:0] result;
	logic zero;

	logic clk;
	logic [31:0] vectornum, errors;
	logic [TESTVECTOR_BITS-1:0] testvectors [0:TESTCASES-1];
	logic [N-1:0] result_expected;
	logic zero_expected;

	// instantiate device under test
	alu dut(a, b, ALUControl, result, zero);

	// generate clock
	always // no sensitivity list, so it always executes
		begin
			clk = 1; #10ns; clk = 0; #10ns;
		end

	// at start of test pulse reset
	initial
		begin
			// Busca en el path simulation/modelsim/
			$readmemb("testvectors/alu_testvectors", testvectors);
			vectornum = 0;
			errors = 0;
		end

	// apply test vectors on rising edge of clk
	always @(posedge clk)
		begin
			#1ns;
			{a, b, ALUControl, result_expected, zero_expected} = testvectors[vectornum];
		end

	// check results on falling edge of clk
	always @(negedge clk)
		begin
			if (result !== result_expected || zero !== zero_expected) begin
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
