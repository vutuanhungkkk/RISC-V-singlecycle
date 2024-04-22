module mux_2(
input wire op_a_sel,
input wire [31:0] rs1_data,
input wire [31:0] pc,
output reg [31:0] operand_a
);
always @(*) begin
if (op_a_sel)
      operand_a = rs1_data;
else 
      operand_a = pc;
end
endmodule