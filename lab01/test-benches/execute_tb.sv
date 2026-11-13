module execute_tb();
	parameter N = 64;
	parameter TESTVECTOR_BITS = (1 + 4 + 64 * 4) + (64 * 3 + 1);
	parameter TESTCASES = 100;

	logic clk;

	// input
	logic AluSrc;
	logic [3:0] AluControl;
	logic [N-1:0] PC_E, signImm_E, readData1_E, readData2_E;
	// output
	logic [N-1:0] PCBranch_E, aluResult_E, writeData_E;
	logic zero_E;

	logic [31:0] vectornum, errors;
	logic [TESTVECTOR_BITS-1:0] testvectors [0:TESTCASES-1];

	// expected output
	logic [N-1:0] expected_PCBranch_E, expected_aluResult_E, expected_writeData_E;
	logic expected_zero_E;

	// instantiate device under test
	execute dut(AluSrc, AluControl, PC_E, signImm_E, readData1_E, readData2_E,
		PCBranch_E, aluResult_E, writeData_E, zero_E);

	// generate clock
	always // no sensitivity list, so it always executes
		begin
			#10ns; clk = ~clk;
		end

	// at start of test pulse reset
	initial
		begin
			// Busca en el path simulation/modelsim/
			$readmemb("testvectors/execute_testvectors", testvectors);
			clk = 1;
			vectornum = 0;
			errors = 0;
		end

	// apply test vectors on rising edge of clk
	always @(posedge clk)
		begin
			#1ns;
			{AluSrc, AluControl, PC_E, signImm_E, readData1_E, readData2_E,
			expected_PCBranch_E, expected_aluResult_E, expected_writeData_E,
			expected_zero_E} = testvectors[vectornum];
		end

	// check results on falling edge of clk
	always @(negedge clk)
		begin
			if ({PCBranch_E, aluResult_E, writeData_E, zero_E} !==
				{expected_PCBranch_E, expected_aluResult_E,
				expected_writeData_E, expected_zero_E}) begin
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
