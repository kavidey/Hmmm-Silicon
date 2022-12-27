`timescale 1ns / 100ps

module ir_tb();
    reg clk, rst, read, write;
    wire [15:0] bus;
    reg [15:0] ram = 16'b0;

    assign bus = read ? ram : 16'bZ;

    always begin
        #5;
        clk <= ~clk;
    end
    
    ir uut (
        .clk(clk),
        .rst(rst),
        .ir_in(read),
        .ir_out(write),
        .data(bus)
    );

    initial begin
        $dumpfile("ir_tb.vcd");
        $dumpvars(0, ir_tb);

        rst <= 1'b0;
        read <= 1'b0;
        write <= 1'b0;
        clk <= 1'b0;

        rst <= 1'b1;
        #10;
        rst <= 1'b0;
        #10;

        ram <= 16'b0001_0101_00101010;
        read <= 1'b1;
        #10;
        read <= 1'b0;
        #10;

        write <= 1'b1;
        #10;
        rst <= 1'b1;
        #10;

        $finish;
    end

endmodule