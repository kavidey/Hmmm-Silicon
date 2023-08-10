module ram
(
    input wire clk,
    input wire rst,
    input wire [7:0] address,
    input wire write,
    input wire [15:0] data_in,
    output wire [15:0] data_out
);
    reg [15:0] memory[255:0];

    assign data_out = memory[address];
    
    always @(posedge clk) begin
        if (rst) begin
            memory[address] <= 16'b0;
        end
        else if (write) begin
            memory[address] <= data_in;
        end
    end
endmodule
