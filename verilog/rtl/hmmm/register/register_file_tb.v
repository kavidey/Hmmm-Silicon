`timescale 1ns / 100ps

module register_file_tb();
    reg clk, rst, reg_file_in, reg_file_out;
    reg [3:0] reg_select;
    wire [15:0] bus;
    reg [15:0] ram = 16'd0;

    assign bus = reg_file_in ? ram : 16'bZ;

    always begin
        #5;
        clk <= ~clk;
    end

    register_file uut (
        .clk(clk),
        .rst(rst),
        .register_select(reg_select),
        .reg_file_in(reg_file_in),
        .reg_file_out(reg_file_out),
        .data(bus)
    );

    initial begin
        $dumpfile("register_file_tb.vcd");
        $dumpvars(0, register_file_tb);

        rst <= 1'b0;
        reg_file_in <= 1'b0;
        reg_file_out <= 1'b0;
        clk <= 1'b0;
        reg_select <= 4'd0;

        ram <= 16'b0000000000101010;
        reg_select <= 4'd1;
        reg_file_in <= 1'b1;
        #10;
        reg_file_in <= 1'b0;
        ram <= 16'b0;
        #10;
        reg_file_out <= 1'b1;
        #10;
        reg_file_out <= 1'b0;

        // rst <= 1'b1;
        // #10;
        // rst <= 1'b0;
        // #10;

        // ram <= 16'd0;
        // reg_select <= 3'd0;
        // reg_file_in <= 1'b1;
        // #10;
        // reg_file_in <= 1'b0;
        // #10;

        // ram <= 16'd1;
        // reg_select <= 4'd1;
        // reg_file_in <= 1'b1;
        // #10;
        // reg_file_in <= 1'b0;
        // #10;

        // ram <= 16'd14;
        // reg_select <= 4'd14;
        // reg_file_in <= 1'b1;
        // #10;
        // reg_file_in <= 1'b0;
        // #10;

        // ram <= 16'd15;
        // reg_select <= 4'd15;
        // reg_file_in <= 1'b1;
        // #10;
        // reg_file_in <= 1'b0;
        // #10;

        // reg_select <= 4'd0;
        // reg_file_out <= 1'b1;
        // #10;
        // reg_select <= 4'd1;
        // #10;
        // reg_select <= 4'd14;
        // #10;
        // reg_select <= 4'd15;
        // #10;
        // reg_file_out <= 1'b0;

        // rst <= 1'b1;
        // #10;
        // rst <= 1'b0;
        // #10;

        // reg_select <= 4'd0;
        // reg_file_out <= 1'b1;
        // #10;
        // reg_select <= 4'd1;
        // #10;
        // reg_select <= 4'd14;
        // #10;
        // reg_select <= 4'd15;
        // #10;

        $finish;
    end
endmodule