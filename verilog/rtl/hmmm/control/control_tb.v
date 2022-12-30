`timescale 1ns / 100ps

module control_tb();
    reg clk, rst;
    wire [15:0] bus;

    wire mar_in, mdr_in, mdr_out;
    wire pc_out, pc_jump, pc_increment;
    wire tmp0_in, tmp0_out, alu_out, tmp1_in, tmp1_out, flags_in;
    wire [2:0] alu_op, flags_data;
    wire [3:0] reg_sel;
    wire reg_in, reg_out;
    wire ir_in, ir_out;
    wire in_out, out_in;
    wire halt;


    reg [15:0] fake_ir = 16'b0001_0001_0010_1010;

    always begin
        #5;
        clk <= ~clk;
    end

    control uut (
        .clk(clk),
        .rst(rst),

        .mar_in(mar_in),
        .mdr_in(mdr_in),
        .mdr_out(mdr_out),

        .pc_out(pc_out),
        .pc_jump(pc_jump),
        .pc_increment(pc_increment),

        .tmp0_in(tmp0_in),
        .tmp0_out(tmp0_out),
        .alu_out(alu_out),
        .alu_op(alu_op),
        .tmp1_in(tmp1_in),
        .tmp1_out(tmp1_out),
        .flags_in(flags_in),
        .flags_data(flags_data),

        .reg_sel(reg_sel),
        .reg_in(reg_in),
        .reg_out(reg_out),

        .ir_in(ir_in),
        .ir_out(ir_out),
        .ir_data(fake_ir),

        .in_out(in_out),
        .out_in(out_in),

        .halt(halt),

        .bus(bus)
    );

    initial begin
        $dumpfile("control_tb.vcd");
        $dumpvars(0, control_tb);

        rst <= 1'b0;
        clk <= 1'b0;

        rst <= 1'b1;
        #10;
        rst <= 1'b0;

        #100

        rst <= 1'b1;
        #10;

        $finish;
    end

endmodule