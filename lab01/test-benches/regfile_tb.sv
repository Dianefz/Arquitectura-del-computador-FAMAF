module regfile_tb();
	parameter N = 64;
	parameter TESTVECTOR_BITS = 1 + 5 + 5 + 5 + 64 + 64 + 64;
	parameter TESTCASES = 100;

	logic clk;
	logic we3;
	logic [4:0] ra1, ra2;
	logic [4:0] wa3;
	logic [N-1:0] wd3;
	logic [N-1:0] rd1, rd2;

	logic [31:0] vectornum, errors;
	logic [TESTVECTOR_BITS-1:0] testvectors [0:TESTCASES-1];
	logic [N-1:0] rd1_expected, rd2_expected;

	// instantiate device under test
	regfile dut(clk, we3, ra1, ra2, wa3, wd3, rd1, rd2);

	// generate clock
	always // no sensitivity list, so it always executes
		begin
			#10ns; clk = ~clk;
		end

	// at start of test pulse reset
	initial
		begin
			// Busca en el path simulation/modelsim/
			$readmemb("testvectors/regfile_testvectors", testvectors);
			clk = 1;
			vectornum = 0;
			errors = 0;
		end

	// apply test vectors on rising edge of clk
	always @(posedge clk)
		begin
			#1ns;
			{we3, ra1, ra2, wa3, wd3,
			rd1_expected, rd2_expected} = testvectors[vectornum];
		end

	// check results on falling edge of clk
	always @(negedge clk)
		begin
			if ({rd1, rd2} !== {rd1_expected, rd2_expected}) begin
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
