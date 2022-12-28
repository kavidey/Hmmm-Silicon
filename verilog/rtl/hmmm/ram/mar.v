`include "../register/register.v"

module mar (
    input wire clk,
    input wire rst,
    input wire mar_in,
    input wire [7:0] address,
    output wire [7:0] ram_address
);

    reg [7:0] internal_mar;

    assign ram_address = internal_mar;

    always @(posedge clk) begin
        if (rst)
            internal_mar <= 0;
        else if (mar_in)
            internal_mar <= address;
        else
            internal_mar <= internal_mar;
    end

    // register #(
    //     .N(8)
    // ) mar_register (
    //     .clk(clk),
    //     .rst(rst),
    //     .register_in(mar_in),
    //     .register_out(1'b1),
    //     .data(address)
    // );

endmodule