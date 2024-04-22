module ctrl_unit(
    input wire [31:0] instr,
    input wire br_less,
    input wire br_equal,
    output reg br_sel,
    output reg br_unsigned,
    output reg rd_wren,
    output reg mem_wren,
    output reg op_a_sel,
    output reg op_b_sel, 
    output reg [3:0] alu_op,
    output reg [2:0] wb_sel
);

always @(*) begin
    case(instr[6:0])
        7'b0010111: begin br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 1; alu_op = 4'd0; wb_sel = 3'b01; end // Lui
        7'b0110111: begin br_sel = 1; rd_wren = 1; op_a_sel = 0; op_b_sel = 1; alu_op = 4'd0; wb_sel = 3'b01; end // auipc
        7'b1101111: begin br_sel = 0; rd_wren = 1; op_a_sel = 0; op_b_sel = 1; alu_op = 4'd0; wb_sel = 3'b00; end // JAL
        7'b1100111: begin br_sel = 0; rd_wren = 1; op_a_sel = 1; op_b_sel = 1; alu_op = 4'd0; wb_sel = 3'b00; end // JALR
        7'b1100011: begin
                        if (instr[14:12] == 3'b000) begin
                            if (br_equal == 1 && br_less == 0) begin
                                br_sel = 0; rd_wren = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 4'd0;
                            end else begin
                                br_sel = 1; rd_wren = 0;
                            end
                        end
                        else if (instr[14:12] == 3'b001) begin
                            if (br_equal == 0) begin
                                br_sel = 0; rd_wren = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 4'd0;
                            end else begin
                                br_sel = 1; rd_wren = 0;
                            end
                        end
                        else if (instr[14:12] == 3'b100) begin
                            if (br_less == 1) begin
                                br_sel = 0; rd_wren = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 4'd0;
                            end else begin
                                br_sel = 1; rd_wren = 0;
                            end
                        end
                        else if (instr[14:12] == 3'b110) begin
                            if (br_less == 1) begin
                                br_sel = 0; rd_wren = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 4'd0;
                            end else begin
                                br_sel = 1; rd_wren = 0; br_unsigned = 1;
                            end
                        end
                        else if (instr[14:12] == 3'b101) begin
                            if (br_less == 0) begin
                                br_sel = 0; rd_wren = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 4'd0;
                            end else begin
                                br_sel = 1; rd_wren = 0;
                            end
                        end
                        else if (instr[14:12] == 3'b111) begin
                            if (br_less == 0) begin
                                br_sel = 0; rd_wren = 0; op_a_sel = 0; op_b_sel = 1; alu_op = 4'd0;
                            end else begin
                                br_sel = 1; rd_wren = 0; br_unsigned = 1;
                            end
                        end
                    end // conditional branch instructions
        7'b0010011: begin
                        case(instr[14:12])
                            3'b000: begin br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 1; alu_op = 4'd0; wb_sel = 3'b01; end // addi
                            3'b010: begin br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 1; alu_op = 4'd2; wb_sel = 3'b01; end // slti
                            3'b011: begin br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 1; alu_op = 4'd2; wb_sel = 3'b01; br_unsigned = 1; end // sltiu
                            3'b100: begin br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 1; alu_op = 4'd4; wb_sel = 3'b01; end // xori
                            3'b110: begin br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 1; alu_op = 4'd5; wb_sel = 3'b01; end // ori
                            3'b111: begin br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 1; alu_op = 4'd6; wb_sel = 3'b01; end // andi
                            default: begin br_sel = 0; rd_wren = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 4'd0; wb_sel = 3'b00; end
                        endcase
                    end // immediate instructions
        7'b0100011: begin
                        case(instr[14:12])
                            3'b001: begin br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 1; alu_op = 4'd7; wb_sel = 3'b01; end // slli
                            3'b101: begin
                                        if (instr[30] == 0) begin
                                            br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 1; alu_op = 4'd8; wb_sel = 3'b01; end // srli
                                        
                                        else begin
                                            br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 1; alu_op = 4'd9; wb_sel = 3'b01; end // srai
                                    end
                            default: begin br_sel = 0; rd_wren = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 4'd0; wb_sel = 3'b00; end
                        endcase
                    end // store instructions
        7'b0110011: begin
                        case(instr[14:12])
                            3'b000: begin
                                        if (instr[30] == 0) begin
                                            br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 0; alu_op = 4'd0; wb_sel = 3'b01; end // add
                                        
                                        else begin
                                            br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 0; alu_op = 4'd1; wb_sel = 3'b01; end // sub
                                    end
                            3'b001: begin br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 0; alu_op = 4'd7; wb_sel = 3'b01; end // sll
                            3'b010: begin br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 0; alu_op = 4'd2; wb_sel = 3'b01; end // slt
                            3'b011: begin br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 0; alu_op = 4'd2; wb_sel = 3'b01; br_unsigned = 1; end // sltu
                            3'b100: begin br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 0; alu_op = 4'd4; wb_sel = 3'b01; end // xor
                            3'b101: begin
                                        if (instr[30] == 0) begin
                                            br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 0; alu_op = 4'd8; wb_sel = 3'b01; end // srl
                                        
                                        else begin
                                            br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 0; alu_op = 4'd9; wb_sel = 3'b01; end // sra
                                    end
                            3'b110: begin br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 0; alu_op = 4'd5; wb_sel = 3'b01; end // or
                            3'b111: begin br_sel = 1; rd_wren = 1; op_a_sel = 1; op_b_sel = 0; alu_op = 4'd6; wb_sel = 3'b01; end // and
                            default: begin br_sel = 0; rd_wren = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 4'd0; wb_sel = 3'b00; end
                        endcase
                    end // R-type instructions
        default: begin br_sel = 0; rd_wren = 0; op_a_sel = 0; op_b_sel = 0; alu_op = 4'd0; wb_sel = 3'b00; end
    endcase
end

endmodule
