module hmmm(
`ifdef USE_POWER_PINS
    inout vccd1,	// User area 1 1.8V power
	inout vssd1,	// User area 1 digital ground
`endif

    input wire clk,
    input wire rst,
    input wire pgrm_addr,
    input wire pgrm_data,
    input wire [15:0] in,
    output wire [15:0] out,
    output wire write,
    output wire read,
    output wire halt,
    output wire [15:0] oeb
);
    wire internal_clock = halt ? 1'b0 : clk;

    wire [15:0] bus = (read || pgrm_addr || pgrm_data) ? in : 16'bZ;
    // For debugging its useful to always be able to see what is on the bus
    // The "write" signal is used to indicate when the computer is outputting a value
    // assign out = write ? bus : 16'bZ;
    assign out = bus;
    assign oeb = {16{write}};

    wire mar_in, mdr_in, mdr_out;
    wire pc_out, pc_jump, pc_increment;
    wire tmp0_in, tmp0_out, alu_out, tmp1_in, tmp1_out, flags_in;
    wire [2:0] alu_op, alu_flags;
    wire [3:0] reg_sel;
    wire reg_in, reg_out;
    wire ir_in, ir_out;
    wire [15:0] ir_data;

    wire writing_program = (pgrm_addr || pgrm_data) ? 1'b1 : 1'b0;
    control internal_control (
        .clk(internal_clock),
        .rst(rst),
        .writing_program(writing_program),

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
        .ir_data(ir_data),

        .in_out(read),
        .out_in(write),

        .halt(halt),

        .bus(bus)
    );

    pc internal_pc (
        .clk(internal_clock),
        .rst(rst),

        .pc_out(pc_out),
        .jump(pc_jump),
        .increment(pc_increment),

        .data(bus)
    );

    ir internal_ir (
        .clk(internal_clock),
        .rst(rst),

        .ir_in(ir_in),
        .ir_out(ir_out),

        .data(bus),
        .ir_data(ir_data)
    );

    wire [7:0] ram_address;
    wire [15:0] ram_data_in;
    wire [15:0] ram_data_out;
    wire mar_in_conditional = mar_in | pgrm_addr;
    mar internal_mar (
        .clk(internal_clock),
        .rst(rst),

        .mar_in(mar_in_conditional),

        .address(bus[7:0]),

        .ram_address(ram_address)
    );
    wire mdr_in_conditional = mdr_in | pgrm_data;
    ram internal_ram (
        .clk(internal_clock),
        .rst(rst),

        .write(mdr_in_conditional),

        .address(ram_address),
        .data_in(ram_data_in),
        .data_out(ram_data_out)
    );
    mdr internal_mdr (
        .clk(internal_clock),

        .mdr_in(mdr_in_conditional),
        .mdr_out(mdr_out),

        .data(bus),

        .ram_in(ram_data_in),
        .ram_out(ram_data_out)
    );

    register_file internal_register_file (
        .clk(internal_clock),
        .rst(rst),

        .register_select(reg_sel),
        .reg_file_in(reg_in),
        .reg_file_out(reg_out),

        .data(bus)
    );

    wire [15:0] tmp0_data, tmp1_data;
    register tmp0_register (
        .clk(internal_clock),
        .rst(rst),

        .register_in(tmp0_in),
        .register_out(tmp0_out),

        .data(bus),
        .register_data(tmp0_data)
    );

    register tmp1_register (
        .clk(internal_clock),
        .rst(rst),

        .register_in(tmp1_in),
        .register_out(tmp1_out),

        .data(bus),
        .register_data(tmp1_data)
    );

    wire [2:0] flags_data;
    register #(.N(3)) flags_register (
        .clk(internal_clock),
        .rst(rst),

        .register_in(flags_in),
        .register_out(1'b0),

        .data(alu_flags),
        .register_data(flags_data)
    );

    alu internal_alu (
        .tmp1(tmp0_data),
        .tmp2(tmp1_data),

        .op(alu_op),
        .enable(alu_out),
        .result(bus),

        .carry(alu_flags[0]),
        .zero(alu_flags[1]),
        .sign(alu_flags[2])
    );

endmodule