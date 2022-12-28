`timescale 1ns / 100ps

module ram_tb();
    reg clk, rst, mar_in, mdr_in, mdr_out;
    wire [15:0] bus;
    reg [15:0] temp_data = 16'b0;

    assign bus = mdr_out ? 16'bZ : temp_data;

    always begin
        #5;
        clk <= ~clk;
    end
    
    wire [7:0] ram_address;
    wire [15:0] ram_in;
    wire [15:0] ram_out;
    mar uut0 (
        .clk(clk),
        .rst(rst),
        .mar_in(mar_in),
        .address(bus[7:0]),
        .ram_address(ram_address)
    );
    ram uut1 (
        .clk(clk),
        .rst(rst),
        .write(mdr_in),
        .address(ram_address),
        .data_in(ram_in),
        .data_out(ram_out)
    );
    mdr uut2 (
        .clk(clk),
        .mdr_in(mdr_in),
        .mdr_out(mdr_out),
        .data(bus),
        .ram_in(ram_in),
        .ram_out(ram_out)
    );

    initial begin
        $dumpfile("ram_tb.vcd");
        $dumpvars(2, ram_tb);

        clk <= 1'b0;
        rst <= 1'b0;
        mar_in <= 1'b0;
        mdr_in <= 1'b0;
        mdr_out <= 1'b0;

        rst <= 1'b1;
        #10;
        rst <= 1'b0;

        /// ONE READ WRITE CYCLE

        // address out, mar in
        temp_data <= 16'd42;
        mar_in <= 1'b1;
        #10;
        mar_in <= 1'b0;
        
        // data out, mdr in
        temp_data <= 16'd21;
        mdr_in <= 1'b1;
        #10;
        mdr_in <= 1'b0;

        // reset temp_data
        temp_data <= 16'd0;
        #10;

        // mdr out
        mdr_out <= 1'b1;
        #10;
        mdr_out <= 1'b0;

        /// ONE WRITE CYCLE

        // address out, mar in
        temp_data <= 16'd32;
        mar_in <= 1'b1;
        #10;
        mar_in <= 1'b0;

        // data out, mdr in
        temp_data <= 16'd24;
        mdr_in <= 1'b1;
        #10;
        mdr_in <= 1'b0;

        /// ONE WRITE CYCLE

        // address out, mar in
        temp_data <= 16'd33;
        mar_in <= 1'b1;
        #10;
        mar_in <= 1'b0;

        // data out, mdr in
        temp_data <= 16'd25;
        mdr_in <= 1'b1;
        #10;
        mdr_in <= 1'b0;

        /// ONE READ CYCLE

        // address out, mar in
        temp_data <= 16'd32;
        mar_in <= 1'b1;
        #10;
        mar_in <= 1'b0;

        // mdr out
        mdr_out <= 1'b1;
        #10;
        mdr_out <= 1'b0;
        
        /// ONE READ CYCLE

        // address out, mar in
        temp_data <= 16'd33;
        mar_in <= 1'b1;
        #10;
        mar_in <= 1'b0;

        // mdr out
        mdr_out <= 1'b1;
        #10;
        mdr_out <= 1'b0;

        $finish;
    end
endmodule