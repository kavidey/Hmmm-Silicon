`timescale 1ns / 100ps

module register_tb();
    reg clk, rst, register_in, register_out;
    wire [15:0] bus;
    reg [15:0] ram = 16'd42;

    assign bus = register_in ? ram : 16'bZ;

    always begin
        #5;
        clk <= ~clk;
    end

    register uut (
        .clk(clk),
        .rst(rst),
        .register_in(register_in),
        .register_out(register_out),
        .data(bus)
    );

    initial begin
        $dumpfile("register_tb.vcd");
        $dumpvars(0, register_tb);

        rst <= 1'b0;
        register_in <= 1'b0;
        register_out <= 1'b0;
        clk <= 1'b0;
        

        rst <= 1'b1;
        #10;
        rst <= 1'b0;
        #10;

        register_in <= 1'b1;
        #10;
        register_in <= 1'b0;
        #10;

        register_out <= 1'b1;
        #10;
        register_out <= 1'b0;
        #20;

        rst <= 1'b1;
        register_out <= 1'b1;
        #10;

        $finish;
    end

endmodule