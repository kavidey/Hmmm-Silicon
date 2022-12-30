module register 
#(
    parameter N = 16
)
(
    input wire clk,
    input wire rst,
    input wire register_in,
    input wire register_out,
    inout wire [N-1:0] data,
    output wire [N-1:0] register_data
);
    reg [N-1:0] internal_register;
    assign register_data = internal_register;

    assign data = register_out ? internal_register : {N{1'bZ}};

    always @(posedge clk) begin
        if (rst)
            internal_register <= 0;
        else if (register_in)
            internal_register <= data;
    end

endmodule