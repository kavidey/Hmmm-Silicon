`timescale 1ns / 100ps

module hmmm_tb();
    reg clk, rst;
    reg pgrm_addr, pgrm_data;
    wire read, write, halt;

    reg [15:0] data = 16'b0;
    wire [15:0] out;

    always begin
        #5;
        clk <= ~clk;
    end

    hmmm uut (
        .clk(clk),
        .rst(rst),
        .pgrm_addr(pgrm_addr),
        .pgrm_data(pgrm_data),
        .read(read),
        .write(write),
        .in(data),
        .out(out),
        .halt(halt)
    );

    initial begin
        $dumpfile("hmmm_tb.vcd");
        $dumpvars(0, hmmm_tb);

        rst <= 1'b0;
        pgrm_addr <= 1'b0;
        pgrm_data <= 1'b0;
        clk <= 1'b0;

        rst <= 1'b1;
        #10;
        rst <= 1'b0;

        // Quadruple the input number
        data <= 16'd0;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0001_1111_0110_0100;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;
        data <= 16'd1;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0000_0001_0000_0001;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;
        data <= 16'd2;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b1011_1110_0000_0111;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;
        data <= 16'd3;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0000_1101_0000_0010;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;
        data <= 16'd4;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0000_0000_0000_0000;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;
        data <= 16'd5;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0110_1101_0001_0001;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;
        data <= 16'd6;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0000_1110_0000_0011;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;
        data <= 16'd7;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0100_1110_1111_0011;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;
        data <= 16'd8;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b1011_1110_0000_0101;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;
        data <= 16'd9;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0100_1110_1111_0010;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;
        data <= 16'd10;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0110_0001_1101_0000;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;
        data <= 16'd11;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0100_1110_1111_0011;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;
        data <= 16'd12;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b1011_1110_0000_0101;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;
        data <= 16'd13;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0100_1110_1111_0010;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;
        data <= 16'd14;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0000_1110_0000_0011;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;
        data <= 16'd15;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0000_0000_0000_0000;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;

        rst <= 1'b1;
        #10;
        rst <= 1'b0;
        data <= 16'd42;

        #1000;

        $finish;
    end
endmodule