module register (
    input wire clk,
    input wire rst,
    input wire write,
    input wire read,
    inout wire [15:0] data
);
    reg [15:0] internal_register;

    assign data = read ? internal_register : 16'bZ;

    always @(posedge clk) begin
        if (rst)
            internal_register <= 16'b0;
        else if (write)
            internal_register <= data;
    end

endmodule