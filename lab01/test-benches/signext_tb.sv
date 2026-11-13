module signext_tb();
	logic clk;
	logic [31:0] a;
	logic [63:0] y;
	logic [31:0] vectornum, errors;
	logic [31:0] testvectors [0:9] = '{
		// opcode + DT_address + 12 bits
		32'b11111000010_010000000_000000000000, // LDUR DT_address positivo
		32'b11111000010_100000000_000000000000, // LDUR DT_address negativo
		32'b11111000000_010000000_000000000000, // STUR DT_address positivo
		32'b11111000000_100000000_000000000000, // STUR DT_address negativo
		// opcode + COND_BR_address + 5 bits
		32'b10110100_0100000000000000000_00000, // CBZ COND_BR_address positivo
		32'b10110100_1000000000000000000_00000, // CBZ COND_BR_address negativo

		32'h4580_0000, // ADD
		32'h6580_0000, // SUB
		32'h4500_0000, // AND
		32'h5500_0000  // ORR
	};
	logic [63:0] testresults [0:9] = '{
		{{55{1'b0}}, 9'b010000000}, // LDUR DT_address positivo
		{{55{1'b1}}, 9'b100000000}, // LDUR DT_address negativo
		{{55{1'b0}}, 9'b010000000}, // STUR DT_address positivo
		{{55{1'b1}}, 9'b100000000}, // STUR DT_address negativo
		{{45{1'b0}}, 19'b0100000000000000000}, // CBZ COND_BR_address positivo
		{{45{1'b1}}, 19'b1000000000000000000}, // CBZ COND_BR_address negativo
		64'b0, // ADD
		64'b0, // SUB
		64'b0, // AND
		64'b0 // ORR
	};

	// instantiate device under test
	signext dut(a, y);

	// generate clock
	always // no sensitivity list, so it always executes
		begin
			clk = 1; #10ns; clk = 0; #10ns;
		end

	// at start of test pulse reset
	initial
		begin
			vectornum = 0;
			errors = 0;
		end

	// apply test vectors on rising edge of clk
	always @(posedge clk)
		begin
			#1ns;
			a = testvectors[vectornum];
		end

	// check results on falling edge of clk
	always @(negedge clk)
		begin
			if (y !== testresults[vectornum]) begin
				$display("vectornum %d: (y, yexpected) = (%b, %b)", vectornum, y, testresults[vectornum]);
				errors += 1;
			end
			vectornum = vectornum + 1;
			if (testvectors[vectornum] === 32'bx) begin
				$display("%d tests completed with %d errors", vectornum, errors);
				$stop;
			end
		end
endmodule
