module alu(
    input wire [31:0] operand_a, // rs1
    input wire [31:0] operand_b, // rs2 or imm depending on the type of operation
    input wire [3:0] alu_op, // Operation code for the ALU (see the table)
    output reg [31:0] alu_data // Output of the ALU operation
);
    reg [31:0] diff; 
// Define operation codes
localparam ADD = 4'd0; // ADD operation
localparam SUB = 4'd1; // SUB operation
localparam SLT = 4'd2; // SLT operation
localparam SLTU = 4'd3; // SLTU operation
localparam XOR = 4'd4; // XOR operation
localparam OR = 4'd5; // OR operation
localparam AND = 4'd6; // AND operation
localparam SLL = 4'd7; // SLL operation
localparam SRL = 4'd8; // SRL operation
localparam SRA = 4'd9; // SRA operation

// ALU behavior based on the alu_op input
always @(*) begin
    diff = operand_a + (~operand_b) + 1;
    case (alu_op)
        ADD: alu_data = operand_a + operand_b;
        SUB: alu_data = diff; // Two's complement subtraction
        SLT: alu_data =  (operand_a[31] == 0 && operand_b[31] == 1) ? 32'd0 :
                         (operand_a[31] == 1 && operand_b[31] == 0) ? 32'd1 : diff[31];
        SLTU: alu_data = (operand_a[31] == 0 && operand_b[31] == 1) ? 32'd1 :
                         (operand_a[31] == 1 && operand_b[31] == 0) ? 32'd0 : diff[31];
        XOR: alu_data = operand_a ^ operand_b;
        OR: alu_data = operand_a | operand_b;
        AND: alu_data = operand_a & operand_b;
        SLL: alu_data = operand_a << operand_b[4:0];
        SRL: alu_data = operand_a >> operand_b[4:0];
        SRA: alu_data = operand_a >>> operand_b[4:0]; // Arithmetic right shift
        default: alu_data = 32'd0; // Default case to handle unknown alu_op values
    endcase
end
endmodule
