module regfile(
    input wire clk_i, // positive clock
    input wire rst_ni, // low negative reset
    input wire [4:0] rs1_addr, // rs1 address
    input wire [4:0] rs2_addr, // rs2 address
    input wire [4:0] rd_addr, // rd address
    input wire [31:0] rd_data, // write data for rd
    input wire rd_wren, // 1 if write to rd
    output wire [31:0] rs1_data, // rs1 data
    output wire [31:0] rs2_data // rs2 data
);

    // Declare a 32-entry register file, each register is 32-bit
    reg [31:0] regfile [31:0];

    // Initialize the register file at startup
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            regfile[i] = 32'b0; // Initialize each register to 0
        end
        // Write the initial contents of the register file to a file
        $writememb("regfile.data", regfile);
    end

    // Assign read data directly from the register file
    assign rs1_data = regfile[rs1_addr];
    assign rs2_data = regfile[rs2_addr];

    // On the falling edge of the clock
    always @(negedge clk_i) begin
        // If reset is asserted (active low)
        if (!rst_ni) begin
            // Reset the register file (set all registers to 0)
            for (i = 0; i < 32; i = i + 1) begin
                regfile[i] = 32'b0;
            end
        end else begin
            // Check if we need to write data to rd
            if (rd_wren) begin
                // Do not write to register 0 (RISC-V specification)
                if (rd_addr != 5'b00000) begin
                    regfile[rd_addr] = rd_data;
                end
            end
        end
        
        // Ensure that register 0 remains 0 as per RISC-V specification
        regfile[5'b00000] = 32'b0;

        // Write the contents of the register file to a file on every clock cycle
        $writememb("regfile.data", regfile);
    end

endmodule
