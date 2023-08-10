module mdr (
    input wire clk,
    // input wire rst,
    input wire mdr_in,
    input wire mdr_out,
    inout wire [15:0] data,
    input wire [15:0] ram_out,
    output wire [15:0] ram_in
);

    // reg [15:0] internal_mdr;

    assign ram_in = mdr_in ? data : {16{1'bZ}};
    // assign data = mdr_out ? internal_mdr : {16{1'bZ}};
    assign data = mdr_out ? ram_out : {16{1'bZ}};

    // This introduces an unnecessary delay
    // always @(posedge clk) begin
    //     if (mdr_out)
    //         internal_mdr <= ram_out;
    // end

endmodule
