module pc(
input[31:0] nxt_pc, 
input clk,
output reg [31:0] pc
);
always @(posedge clk) begin
pc <= nxt_pc;
end	
endmodule 

