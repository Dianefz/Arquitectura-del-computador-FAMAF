module imem #(parameter N = 32) (
	input logic [7:0] addr,
	output logic [N-1:0] q
);
	logic [N-1:0] rom [0:159];

	initial begin
		rom = '{default:0};
		$readmemh("progs/test", rom);
	end

	assign q = rom[addr];
endmodule
