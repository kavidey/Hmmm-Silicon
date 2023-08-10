// `define BITS_TO_FIT(N) ( \
// N <= 2 ? 1 : \
// N <= 4 ? 2 : \
// N <= 8 ? 3 : \
// N <= 16 ? 4 : \
// N <= 32 ? 5 : \
// N <= 64 ? 6 : \
// 7 )

module register_file
// #(
//     parameter NUM_REGISTERS = 16,
//     parameter N = 16
// )
(
    input wire clk,
    input wire rst,
    input wire [3:0] register_select,
    input wire reg_file_in,
    input wire reg_file_out,
    inout wire [15:0] data
);
    // localparam COUNTWIDTH = `BITS_TO_FIT(NUM_REGISTERS);
    
    // integer i;
    reg [15:0] registers[15:0];

    assign data = reg_file_out ? registers[register_select] : {16{1'bZ}};
    
    always @(posedge clk) begin
        if (rst) begin
            // for (i = 0; i < 16; i = i + 1) begin
            //     registers[i] = 16'b0; 
            // end 
            registers[0] <= 16'b0;
            registers[1] <= 16'b0;
            registers[2] <= 16'b0;
            registers[3] <= 16'b0;
            registers[4] <= 16'b0;
            registers[5] <= 16'b0;
            registers[6] <= 16'b0;
            registers[7] <= 16'b0;
            registers[8] <= 16'b0;
            registers[9] <= 16'b0;
            registers[10] <= 16'b0;
            registers[11] <= 16'b0;
            registers[12] <= 16'b0;
            registers[13] <= 16'b0;
            registers[14] <= 16'b0;
            registers[15] <= 16'b0;
        end
        else if (reg_file_in) begin
            registers[register_select] <= data;
        end
    end
endmodule
