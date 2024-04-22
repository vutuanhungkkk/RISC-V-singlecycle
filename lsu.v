module lsu (
    input wire clk_i,
    input wire rst_ni,
    input wire [31:0] addr,
    input wire [31:0] st_data,
    input wire st_en,
    input wire [31:0] io_sw,
    output reg [31:0] ld_data,
    output reg [31:0] io_lcd,
    output reg [31:0] io_ledg,
    output reg [31:0] io_ledr,
    output reg [31:0] io_hex0,
    output reg [31:0] io_hex1,
    output reg [31:0] io_hex2,
    output reg [31:0] io_hex3,
    output reg [31:0] io_hex4,
    output reg [31:0] io_hex5,
    output reg [31:0] io_hex6,
    output reg [31:0] io_hex7
);

always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
        // Đặt lại tất cả các đầu ra khi reset
        ld_data <= 32'b0;
        io_lcd <= 32'b0;
        io_ledg <= 32'b0;
        io_ledr <= 32'b0;
        io_hex0 <= 32'b0;
        io_hex1 <= 32'b0;
        io_hex2 <= 32'b0;
        io_hex3 <= 32'b0;
        io_hex4 <= 32'b0;
        io_hex5 <= 32'b0;
        io_hex6 <= 32'b0;
        io_hex7 <= 32'b0;
    end else begin
        if (st_en) begin
            // Nếu là hoạt động ghi
            case (addr)
                32'h800: io_hex0 <= st_data;
                32'h810: io_hex1 <= st_data;
                32'h820: io_hex2 <= st_data;
                32'h830: io_hex3 <= st_data;
                32'h840: io_hex4 <= st_data;
                32'h850: io_hex5 <= st_data;
                32'h860: io_hex6 <= st_data;
                32'h870: io_hex7 <= st_data;
                32'h880: io_ledr <= st_data;
                32'h890: io_ledg <= st_data;
                32'h8A0: io_lcd <= st_data;
                
                default: ;
            endcase
        end else begin
            case (addr)
                32'h900: ld_data <= io_sw;
                default: ld_data <= 32'b0;
            endcase
        end
    end
end
endmodule
