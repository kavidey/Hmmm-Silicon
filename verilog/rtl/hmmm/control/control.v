module control
(
    input wire clk,
    input wire rst,

    // RAM
    output wire mar_in, // 0
    output wire mdr_in, // 1
    output wire mdr_out, // 2

    // Program Counter
    output wire pc_out, // 3
    output wire pc_jump, // 4
    output wire pc_increment, // 5

    // ALU
    output wire tmp0_in, // 6
    output wire tmp0_out, // 7
    output wire alu_out, // 8
    output wire [3:0] alu_op, // 9-12
    output wire tmp1_in, // 13
    output wire tmp1_out, // 14

    // Register File
    output wire [3:0] reg_sel, // 15-18
    output wire reg_in, // 19
    output wire reg_out, // 20

    // Instruction Register
    output wire ir_in, // 21
    output wire ir_out, // 22
    input wire [15:0] ir_data,

    // IO
    output wire in_out, // 23
    output wire out_in, // 24

    // Halt
    output wire halt, // 25

    // Control
    input wire [15:0] bus,
    output wire [7:0] control_out
);
    reg [2:0] microcode_instruction = 3'b0;
    reg [24:0] control_reg;

    assign mar_in = control_reg[0];
    assign mdr_in = control_reg[1];
    assign mdr_out = control_reg[2];
    assign pc_out = control_reg[3];
    assign pc_jump = control_reg[4];
    assign pc_increment = control_reg[5];
    assign tmp0_in = control_reg[6];
    assign tmp0_out = control_reg[7];
    assign alu_out = control_reg[8];
    assign alu_op = control_reg[12:9];
    assign tmp1_in = control_reg[13];
    assign tmp1_out = control_reg[14];
    assign reg_sel = control_reg[18:15];
    assign reg_in = control_reg[19];
    assign reg_out = control_reg[20];
    assign ir_in = control_reg[21];
    assign ir_out = control_reg[22];
    assign in_out = control_reg[23];
    assign out_in = control_reg[24];
    assign halt = control_reg[25];

    always @(negedge clk) begin
        if (rst)
            microcode_instruction <= 3'b0;
        else
            control_reg = 25'b0;

            if (microcode_instruction < 3'd2)
                case(microcode_instruction)
                3'd0: begin
                    control_reg[3] = 1'b1; // pc_out
                    control_reg[0] = 1'b1; // mar_in
                    microcode_instruction = 3'd1;
                end
                3'd1: begin
                    control_reg[2] = 1'b1; // mdr_out
                    contorl_reg[21] = 1'b1; // ir_in
                    control_reg[5] = 1'b1; // pc_increment
                    microcode_instruction = 3'd2;
                end
                endcase
            else
                case(ir_data[15:12])
                4'b000: begin // halt, read, write, jump
                    case(ir_data[1:0])
                    2'b00: begin // halt
                        control_reg[25] = 1'b1; // halt
                    end
                    2'b01: begin // read
                        control_reg[23] = 1'b1; // in_out
                        control_reg[15:12] = ir_data[11:8]; // reg_sel
                        control_reg[19] = 1'b1; // reg_in
                    end
                    2'b10: begin // write
                        control_reg[24] = 1'b1; // out_in
                        control_reg[15:12] = ir_data[11:8]; // reg_sel
                        control_reg[20] = 1'b1; // reg_out
                    end
                    2'b11: begin // jump
                        control_reg[4] = 1'b1; // pc_jump
                        bus = {12'b0, ir_data[11:8]}; // bus
                    end
                    endcase
                end
                4'b001: begin // setn
                    control_reg[18:15] = ir_data[11:8]; // reg_sel
                    control_reg[19] = 1'b1; // reg_in
                    bus = {8'b0, ir_data[7:0]}; // bus
                end
                endcase
    end

endmodule