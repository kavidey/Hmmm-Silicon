`timescale 1ns / 100ps

module register_tb();
    reg clk, rst, read, write;
    wire [15:0] bus;
    reg [15:0] ram = 16'd42;

    assign bus = read ? ram : 16'bZ;

    always begin
        #5;
        clk <= ~clk;
    end

    register uut (
        .clk(clk),
        .rst(rst),
        .write(read),
        .read(write),
        .data(bus)
    );

    initial begin
        $dumpfile("register_tb.vcd");
        $dumpvars(0, register_tb);

        rst <= 1'b0;
        read <= 1'b0;
        write <= 1'b0;
        clk <= 1'b0;
        

        rst <= 1'b1;
        #10;
        rst <= 1'b0;
        #10;

        read <= 1'b1;
        #10;
        read <= 1'b0;
        #10;

        write <= 1'b1;
        #10;
        write <= 1'b0;
        #20;

        rst <= 1'b1;
        write <= 1'b1;
        #10;

        $finish;
    end

endmodule