module execute #(parameter N = 64) (
	input logic AluSrc,
	input logic [3:0] AluControl,
	input logic [N-1:0] PC_E, signImm_E, readData1_E, readData2_E,
	output logic [N-1:0] PCBranch_E, aluResult_E, writeData_E,
	output logic zero_E, negative_E, carry_E, overflow_E, writeFlags_E //Ej 2 lab 1
);
	logic [N-1:0] MUX_out;
	logic [N-1:0] sl2_out;

	assign writeData_E = readData2_E;

	mux2 #(N) MUX(readData2_E, signImm_E, AluSrc, MUX_out);
	alu #(N) alu_(readData1_E, MUX_out, AluControl, aluResult_E, zero_E, negative_E, carry_E, overflow_E, writeFlags_E);
	sl2 #(N) sl2(signImm_E, sl2_out);
	adder #(N) adder(PC_E, sl2_out, PCBranch_E);

endmodule
