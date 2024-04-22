module brcomp (
    input wire [31:0] rs1_data, // First operand (A)
    input wire [31:0] rs2_data, // Second operand (B)
    input wire br_unsigned, // 1 if the comparison is unsigned
    output reg br_less, // 1 if A < B
    output reg br_equal // 1 if A = B
);

reg [31:0] difference;

always @(*) begin

    br_equal = (rs1_data == rs2_data) ? 1 : 0;
    difference = rs1_data + (~rs2_data) + 1;
    if (br_unsigned) begin
        br_less = (rs1_data[31] == 0 && rs2_data[31] == 1) ? 1 :
                  (rs1_data[31] == 1 && rs1_data[31] == 0) ? 0 : difference[31];
    end else begin
        br_less = difference[31];
    end
end
endmodule
