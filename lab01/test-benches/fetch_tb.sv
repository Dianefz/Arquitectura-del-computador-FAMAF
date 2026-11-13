module fetch_tb();
	parameter N = 64;
	parameter TESTVECTOR_BITS = 1 + 1 + 64 + 64;
	parameter TESTCASES = 100;

	logic PCSrc_F, clk, reset;
	logic [N-1:0] PCBranch_F;
	logic [N-1:0] imem_addr_F;

	logic [31:0] vectornum, errors;
	logic [TESTVECTOR_BITS-1:0] testvectors [0:TESTCASES-1];
	logic [N-1:0] expected_imem_addr_F;

	// instantiate device under test
	fetch dut(PCSrc_F, clk, reset, PCBranch_F, imem_addr_F);

	// generate clock
	always // no sensitivity list, so it always executes
		begin
			#10ns; clk = ~clk;
		end

	// at start of test pulse reset
	initial
		begin
			// Busca en el path simulation/modelsim/
			$readmemb("testvectors/fetch_testvectors", testvectors);
			clk = 1;
			vectornum = 0;
			errors = 0;
		end

	// apply test vectors on rising edge of clk
	always @(posedge clk)
		begin
			#1ns;
			{PCSrc_F, reset, PCBranch_F,
			expected_imem_addr_F} = testvectors[vectornum];
		end

	// check results on falling edge of clk
	always @(negedge clk)
		begin
			if (imem_addr_F !== expected_imem_addr_F) begin
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
