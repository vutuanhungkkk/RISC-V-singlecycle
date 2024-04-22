module InstructionMemory(
    input wire clk,      
    input wire reset,    
    input wire [31:0] addr, 
    output reg [31:0] instr
);

    reg [31:0] memory [0:255];
    integer i;
    
    initial begin
        memory[0] = 32'h00088893;
        memory[1] = 32'h00a68693;
        memory[2] = 32'h00150513;
        memory[3] = 32'h00158593;
        memory[4] = 32'h00077713;
        memory[5] = 32'h011787b3;
        memory[6] = 32'h00058713;
        memory[7] = 32'h00a585b3;
        memory[8] = 32'h00a7a023;
        memory[9] = 32'h00070513;
        memory[10] = 32'h00478793;
        memory[11] = 32'hfff68693;
        memory[12] = 32'hfe0694e3;
        memory[13] = 32'h00000033;
        
        for (i = 14; i < 256; i = i + 1) begin
            memory[i] = 32'h00000000;
        end
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instr = 32'd0; 
        end else begin
            instr = memory[addr[7:0]];
        end
    end
    
endmodule
