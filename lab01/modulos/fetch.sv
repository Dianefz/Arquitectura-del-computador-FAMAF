module fetch #(parameter N=64) (input logic PCSrc_F,
					input logic clk,
					input logic reset,
					input logic [N-1:0] PCBranch_F,
					output logic [N-1:0] imem_addr_F);
					
logic [N-1:0] salida_mux2,salida_adder; // internal variables
					
					
mux2 mymux2(salida_adder,PCBranch_F,PCSrc_F,salida_mux2); // instance of mux2
flopr myflopr(clk,reset,salida_mux2,imem_addr_F); // instance of flopr
adder myadder(imem_addr_F,64'h4,salida_adder); // instance of adder

endmodule