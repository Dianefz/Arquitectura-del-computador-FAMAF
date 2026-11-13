// Etapa: MEMORY

module memory 	(input logic clk, Branch_M, writeFlags_M, condBranch,
				input logic [3:0] flags,
				input logic [3:0] bCond,					
				output logic PCSrc_M);
					
	logic [3:0] q;
	logic cond;
	logic PCSrc;
	regflags CPSR_flags(clk, writeFlags_M, flags, q);
	bCondCheck bcond(bCond, q, cond);
	mux2 mymux(PCSrc, cond, condBranch, PCSrc_M);
	assign PCSrc = Branch_M & flags[3];
	
endmodule