module singlecycle(
    input clk,
    input reset,
    input [31:0] io_sw,
    output [31:0] pc_debug,
    output [31:0] io_lcd,
    output [31:0] io_ledg,
    output [31:0] io_ledr,
    output [31:0] io_hex0,
    output [31:0] io_hex1,
    output [31:0] io_hex2,
    output [31:0] io_hex3,
    output [31:0] io_hex4,
    output [31:0] io_hex5,
    output [31:0] io_hex6,
    output [31:0] io_hex7
); 

wire [4:0] rs1_addr;
wire [4:0] rs2_addr;
wire [4:0] rd_addr;
reg [31:0] rd_data;
wire rd_wren;
wire [31:0] rs1_data;
wire [31:0] rs2_data;
reg [31:0] st_data;
reg st_en;
wire [31:0] ld_data;
wire br_sel;
wire [31:0] alu_data;
wire [31:0] operand_a;
wire [31:0] Imm;
wire [31:0] operand_b;
wire br_less;
wire br_equal;
wire wb_data;
wire op_a_sel;
wire op_b_sel;
wire wb_sel;
wire alu_op;
wire [31:0] instr;
reg [31:0] addr;
reg [31:0] pc;
reg [32:0] pc_four;
wire br_unsigned;
wire mem_wren;

initial begin
    pc = 32'd0;
    addr = 32'd0;
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        addr <= 32'd0;
        pc <= 32'd0;
        pc_four <= 1'b0;
    end else begin
        addr <= addr + 1;
        pc_four <= pc_four + 4;
    end
end

pc debug_pc(
    .clk(clk),
    .nxt_pc(pc),
    .pc(pc_debug)
);

InstructionMemory InMem(
    .clk(clk),
    .reset(reset),
    .addr(addr),
    .instr(instr)
);

decoder dec_inst(
    .clk(clk),
    .instr(instr),
    .rd_addr(rd_addr),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr)
);

regfile reg_file(
    .clk_i(clk),
    .rst_ni(reset),
    .rs1_addr(rs1_addr),
    .rs2_addr(rs2_addr),
    .rd_addr(rd_addr),
    .rd_data(rd_data),
    .rd_wren(rd_wren),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);

lsu load_store(
    .clk_i(clk),
    .rst_ni(reset),
    .addr(addr),
    .st_data(st_data),
    .st_en(st_en),
    .io_sw(io_sw),
    .ld_data(ld_data),
    .io_lcd(io_lcd),
    .io_ledg(io_ledg),
    .io_ledr(io_ledr),
    .io_hex0(io_hex0),
    .io_hex1(io_hex1),
    .io_hex2(io_hex2),
    .io_hex3(io_hex3),
    .io_hex4(io_hex4),
    .io_hex5(io_hex5),
    .io_hex6(io_hex6),
    .io_hex7(io_hex7)
);

mux_1 mux_nxtpc(
    .pc_four(pc_four),
    .br_sel(br_sel),
    .alu_data(alu_data),
    .nxt_pc() 
);


mux_2 mux_opa(
    .pc(pc),
    .rs1_data(rs1_data),
    .operand_a(operand_a)
);

ImmGen immgen(
    .instr(instr),
    .Imm(Imm)
);

brcomp br_comp(
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .br_unsigned(br_unsigned),
    .br_less(br_less),
    .br_equal(br_equal)
);

mux_3 mux_opb(
    .rs2_data(rs2_data),
    .Imm(Imm),
    .operand_b(operand_b),
);

mux_4 mux_wb(
    .pc_four(pc_four),
    .alu_data(alu_data),
    .ld_data(ld_data),
    .wb_data(wb_data)
);

alu Alu(
    .operand_a(operand_a),
    .operand_b(operand_b),
    .alu_op(alu_op),
    .alu_data(alu_data)
);

ctrl_unit control(
    .instr(instr),
    .br_unsigned(br_unsigned),
    .br_less(br_less),
    .br_equal(br_equal),
    .br_sel(br_sel),
    .rd_wren(rd_wren),
    .mem_wren(mem_wren),
    .op_a_sel(op_a_sel),
    .op_b_sel(op_b_sel),
    .alu_op(alu_op),
    .wb_sel(wb_sel)
);

endmodule
