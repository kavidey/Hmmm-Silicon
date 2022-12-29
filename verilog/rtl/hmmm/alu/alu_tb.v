`timescale 1 ns/10 ps

module alu_tb();
    reg signed [15:0] tmp1, tmp2;
    reg [2:0] op;
    reg enable;
    wire signed [15:0] result;
    wire zero, carry, sign;

    alu uut (
        .tmp1(tmp1),
        .tmp2(tmp2),
        .op(op),
        .enable(enable),
        .result(result),
        .zero(zero),
        .carry(carry),
        .sign(sign)
    );

    initial begin
        $dumpfile("alu_tb.vcd");
        $dumpvars(0, alu_tb);

        // should not output anything because enable is off
        tmp1 = 16'd40;
        tmp2 = 16'd2;
        op = 3'd0;
        enable = 1'b0;
        #1;

        // -1 + 1 = 0 (should trigger zero)
        tmp1 = -16'd1;
        tmp2 = 16'd1;
        op = 3'd0;
        enable = 1'b1;
        #1;

        // -1 + -2 = -3
        tmp1 = -16'd1;
        tmp2 = -16'd2;
        op = 3'd0;
        enable = 1'b1;
        #1;
        
        // 32767 + 2 (should trigger carry)
        tmp1 = 16'd32767;
        tmp2 = 16'd2;
        op = 3'd0;
        enable = 1'b1;
        #1;

        // 3 + 2 = 5
        tmp1 = 16'd3;
        tmp2 = 16'd2;
        op = 3'd0;
        enable = 1'b1;
        #1;

        // -32768 + -2 (should trigger carry)
        tmp1 = -16'd32767;
        tmp2 = -16'd2;
        op = 3'd0;
        enable = 1'b1;
        #1;

        // -7 - -7 = 0 (should trigger zero)
        tmp1 = -16'd7;
        tmp2 = -16'd7;
        op = 3'd1;
        enable = 1'b1;
        #1;

        // 5 - 2 = 3
        tmp1 = 16'd5;
        tmp2 = 16'd2;
        op = 3'd1;
        enable = 1'b1;
        #1;

        // -3 - -2 = -1
        tmp1 = -16'd3;
        tmp2 = -16'd2;
        op = 3'd1;
        enable = 1'b1;
        #1;

        // -32767 - 2 (should trigger carry)
        tmp1 = -16'd32767;
        tmp2 = 16'd2;
        op = 3'd1;
        enable = 1'b1;
        #1;

        // 32767 - -2 (should trigger carry)
        tmp1 = 16'd32767;
        tmp2 = -16'd2;
        op = 3'd1;
        enable = 1'b1;
        #1;

        // 3 * 2 = 6
        tmp1 = 16'd3;
        tmp2 = 16'd2;
        op = 3'd2;
        enable = 1'b1;
        #1;

        // -3 * -2 = 6
        tmp1 = -16'd3;
        tmp2 = -16'd2;
        op = 3'd2;
        enable = 1'b1;
        #1;

        // 3 * -2 = -6
        tmp1 = 16'd3;
        tmp2 = -16'd2;
        op = 3'd2;
        enable = 1'b1;
        #1;

        // 15 / 3 = 5
        tmp1 = 16'd15;
        tmp2 = 16'd3;
        op = 3'd3;
        enable = 1'b1;
        #1;

        // -15 / -3 = 5
        tmp1 = -16'd15;
        tmp2 = -16'd3;
        op = 3'd3;
        enable = 1'b1;
        #1;

        // 15 / -3 = -5
        tmp1 = 16'd15;
        tmp2 = -16'd3;
        op = 3'd3;
        enable = 1'b1;
        #1;

        // -15 / 3 = -5
        tmp1 = -16'd15;
        tmp2 = 16'd3;
        op = 3'd3;
        enable = 1'b1;
        #1;

        // 12 % 5 = 2
        tmp1 = 16'd12;
        tmp2 = 16'd5;
        op = 3'd4;
        enable = 1'b1;
        #1;

        // -12 % -5 = -2
        tmp1 = -16'd12;
        tmp2 = -16'd5;
        op = 3'd4;
        enable = 1'b1;
        #1;

        // 12 % -5 = 2
        tmp1 = 16'd12;
        tmp2 = -16'd5;
        op = 3'd4;
        enable = 1'b1;
        #1;

        // -12 % 5 = -2
        tmp1 = -16'd12;
        tmp2 = 16'd5;
        op = 3'd4;
        enable = 1'b1;
        #1;

        // 12 % 3 = 0 (should trigger zero)
        tmp1 = 16'd12;
        tmp2 = 16'd3;
        op = 3'd4;
        enable = 1'b1;
        #1;

        $finish;
    end
endmodule