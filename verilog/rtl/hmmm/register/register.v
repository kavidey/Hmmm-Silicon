module register 
#(
    parameter N = 16
)
(
    input wire clk,
    input wire rst,
    input wire write,
    input wire read,
    inout wire [N-1:0] data
);
    reg [N-1:0] internal_register;

    assign data = read ? internal_register : {N{1'bZ}};

    always @(posedge clk) begin
        if (rst)
            internal_register <= 0;
        else if (write)
            internal_register <= data;
    end

endmodule