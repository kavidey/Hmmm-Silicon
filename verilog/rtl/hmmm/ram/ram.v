module ram 
(
    input clk,
    input rst,
    input write,
    input [7:0] address,
    input [15:0] data_in,
    output [15:0] data_out
);

    reg [15:0] memory [255:0];

    assign data_out = memory[address];

    always @(posedge clk) begin
        if (rst)
            memory[address] <= 16'b0;
        else if (write)
            memory[address] <= data_in;
    end

endmodule