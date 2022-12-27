module alu_tb();
    reg signed [15:0] tmp1, tmp2;
    reg [2:0] op;
    reg enable;
    wire signed [15:0] result;
    wire zero;
    wire carry;

    alu uut (
        .tmp1(tmp1),
        .tmp2(tmp2),
        .op(op),
        .enable(enable),
        .result(result),
        .zero(zero),
        .carry(carry)
    );

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        tmp1 = -16'd1;
        tmp2 = -16'd2;
        op = 3'd0;
        enable = 1'b1;
        #1;
        
        tmp1 = 16'd32767;
        tmp2 = 16'd2;
        op = 3'd0;
        enable = 1'b1;
        #1;

        tmp1 = 16'd3;
        tmp2 = 16'd2;
        op = 3'd0;
        enable = 1'b1;
        #1;

        tmp1 = -16'd32767;
        tmp2 = -16'd2;
        op = 3'd0;
        enable = 1'b1;
        #1;
    end
endmodule