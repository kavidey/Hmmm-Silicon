`timescale 1ns / 100ps

module pc_tb();
    reg clk, rst, jump, increment, pc_out;
    wire [15:0] bus;
    reg [15:0] ram = 16'd42;

    assign bus = jump ? ram : 16'bZ;

    always begin
        #5;
        clk <= ~clk;
    end

    pc uut (
        .clk(clk),
        .rst(rst),
        .jump(jump),
        .increment(increment),
        .pc_out(pc_out),
        .data(bus[7:0])
    );

    initial begin
        $dumpfile("pc_tb.vcd");
        $dumpvars(0, pc_tb);

        rst <= 1'b0;
        jump <= 1'b0;
        increment <= 1'b0;
        pc_out <= 1'b0;
        clk <= 1'b0;
        
        rst <= 1'b1;
        #10;
        rst <= 1'b0;
        #10;

        pc_out <= 1'b1;
        increment <= 1'b1;
        #30;
        pc_out <= 1'b0;
        #20;
        increment <= 1'b0;
        pc_out <= 1'b1;
        #10;
        
        pc_out <= 1'b0;
        jump <= 1'b1;
        #10;
        jump <= 1'b0;
        pc_out <= 1'b1;
        #10;
        rst <= 1'b1;
        #10;

        $finish;
    end

endmodule