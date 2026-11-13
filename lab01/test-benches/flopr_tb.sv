module flopr_tb();
	parameter N = 64;
	logic clk, reset;
	logic [N-1:0] d, q;
	logic [31:0] vectornum, errors;
	logic [N-1:0] testvectors [0:9] = '{
		{{(N-4){1'b0}}, 4'b0001},
		{{(N-4){1'b0}}, 4'b0010},
		{{(N-4){1'b0}}, 4'b0011},
		{{(N-4){1'b0}}, 4'b0100},
		{{(N-4){1'b0}}, 4'b0101},
		{{(N-4){1'b0}}, 4'b0110},
		{{(N-4){1'b0}}, 4'b0111},
		{{(N-4){1'b0}}, 4'b1000},
		{{(N-4){1'b0}}, 4'b1001},
		{{(N-4){1'b0}}, 4'b1010}
	};

	// instantiate device under test
	flopr #(N) dut(clk, reset, d, q);

	// generate clock
	always // no sensitivity list, so it always executes
		begin
			clk = 1; #10ns; clk = 0; #10ns;
		end

	// at start of test pulse reset
	initial
		begin
			vectornum = 0; errors = 0;
			reset = 1; #95ns; reset = 0;
		end

	// apply test vectors on rising edge of clk
	always @(posedge clk)
		begin
			#1ns;
			d = testvectors[vectornum];
		end

	// check results on falling edge of clk
	always @(negedge clk)
		begin
			if (reset) begin
				if (q !== {N{1'b0}}) begin
					$display("Error: inputs (reset, d) = (%d, %d)", reset, d);
					$display("  outputs = %d (0 expected)", q);
					errors = errors + 1;
				end
			end
			else begin
				if (q !== testvectors[vectornum - 1]) begin
					$display("Error: inputs (reset, d) = (%d, %d)", reset, d);
					$display("  outputs = %d (%d expected)", q, testvectors[vectornum - 1]);
					errors = errors + 1;
				end
				if (testvectors[vectornum] === {N{1'bx}}) begin
					$display("%d tests completed with %d errors", vectornum, errors);
					// $finish;
					$stop;
				end
			end
			vectornum = vectornum + 1;
		end
endmodule
