module mux_1(
    input wire [31:0] pc_four,
    input wire br_sel,
    input wire [31:0] alu_data,
    output reg [31:0] nxt_pc
);
always @* begin
    if (br_sel)
        nxt_pc = pc_four;
    else 
        nxt_pc = alu_data;
end
endmodule
