module ir(
    input wire clk,
    input wire rst,
    input wire ir_out,
    input wire ir_in,
    inout wire [15:0] data
);
    reg [15:0] internal_ir;

    assign data = ir_out ? internal_ir : {16{1'bZ}};

    always @(posedge clk) begin
        if (rst)
            internal_ir <= 16'b0;
        else if (ir_in)
            internal_ir[7:0] <= data[7:0];
    end
endmodule