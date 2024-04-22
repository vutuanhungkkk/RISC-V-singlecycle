module mux_3(
input wire op_b_sel,
input wire [31:0] rs2_data,
input wire [31:0] Imm,
output reg [31:0] operand_b
);
always @(*) begin
if (op_b_sel)
      operand_b = Imm;
else 
      operand_b = rs2_data;
end
endmodule