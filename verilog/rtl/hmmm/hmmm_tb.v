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

        // address 0
        data <= 16'b0000_0000_0000_0000;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;
        
        // setn r1 42
        data <= 16'b0001_0001_0010_1010;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;

        // address 1
        data <= 16'b0000_0000_0000_0001;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;

        // write r1
        data <= 16'b0000_0001_0000_0010;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;

        // address 2
        data <= 16'b0000_0000_0000_0010;
        pgrm_addr <= 1'b1;
        #10;
        pgrm_addr <= 1'b0;

        // halt
        data <= 16'b0000_0000_0000_0000;
        pgrm_data <= 1'b1;
        #10;
        pgrm_data <= 1'b0;

        rst <= 1'b1;
        #10;
        rst <= 1'b0;

        #100;

        $finish;
    end
endmodule