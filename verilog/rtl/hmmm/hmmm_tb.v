`timescale 1ns / 100ps

module hmmm_tb();
    reg clk, rst;
    reg pgrm_addr, pgrm_data;
    wire read, write, halt;

    reg [15:0] data = 16'b0;
    wire [15:0] io = (read || pgrm_addr || pgrm_data) ? data : 16'bZ;

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
        .bus(io),
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

        // 0 setn r1 5
        data <= 16'd0;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0001_0001_0000_0101;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;

        // 1 setn r2 3
        data <= 16'd1;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0001_0010_0000_0011;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;

        // 2 sub r3 r1 r2
        data <= 16'd2;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0111_0011_0001_0010;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;

        // 3 nop
        data <= 16'd3;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0110_0000_0000_0000;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;

        // 4 jgtzn r3 7
        data <= 16'd4;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b1110_0011_0000_0111;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;

        // 5 write r1
        data <= 16'd5;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0000_0001_0000_0010;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;

        // 6 jumpn 8
        data <= 16'd6;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b1011_0000_0000_1000;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;

        // 7 write r2
        data <= 16'd7;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        data <= 16'b0000_0010_0000_0010;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;

        // 8 halt
        data <= 16'd8;
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

        #400;

        $finish;
    end
endmodule