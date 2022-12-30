module ir(
    input wire clk,
    input wire rst,
    input wire ir_out,
    input wire ir_in,
    inout wire [15:0] data,
    output wire [15:0] ir_data
);
    reg [15:0] internal_ir;
    assign ir_data = internal_ir;

    assign data = ir_out ? {8'b0, internal_ir[7:0]} : {16{1'bZ}};

    always @(posedge clk) begin
        if (rst)
            internal_ir <= 16'b0;
        else if (ir_in)
            internal_ir <= data;
    end
endmodule