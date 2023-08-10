module control
(
    input wire clk,
    input wire rst,
    input wire writing_program,

    // RAM
    output reg mar_in,
    output reg mdr_in,
    output reg mdr_out,

    // Program Counter
    output reg pc_out,
    output reg pc_jump,
    output reg pc_increment,

    // ALU
    output reg tmp0_in,
    output reg tmp0_out,
    output reg alu_out,
    output reg [2:0] alu_op,
    output reg tmp1_in,
    output reg tmp1_out,
    output reg flags_in,
    input wire [2:0] flags_data, // [carry, zero, sign]

    // Register File
    output reg [3:0] reg_sel,
    output reg reg_in,
    output reg reg_out,

    // Instruction Register
    output reg ir_in,
    output reg ir_out,
    input wire [15:0] ir_data,

    // IO
    output reg in_out,
    output reg out_in,

    // Halt
    output reg halt,

    // Control
    inout wire [15:0] bus
);
    reg [2:0] microcode_instruction = 3'b0;

    reg [15:0] control_out_reg;
    reg control_out_enable;

    assign bus = control_out_enable ? control_out_reg : {16{1'bZ}};

    always @(negedge clk) begin
        // Control
        control_out_enable <= 1'b0;

        // RAM
        mar_in <= 1'b0;
        mdr_in <= 1'b0;
        mdr_out <= 1'b0;

        // Program Counter
        pc_out <= 1'b0;
        pc_jump <= 1'b0;
        pc_increment <= 1'b0;

        // ALU
        tmp0_in <= 1'b0;
        tmp0_out <= 1'b0;
        alu_out <= 1'b0;
        tmp1_in <= 1'b0;
        tmp1_out <= 1'b0;
        flags_in <= 1'b0;

        // Register File
        reg_in <= 1'b0;
        reg_out <= 1'b0;

        // Instruction Register
        ir_in <= 1'b0;
        ir_out <= 1'b0;

        // IO
        in_out <= 1'b0;
        out_in <= 1'b0;

        // Halt
        halt <= 1'b0;
        
        if (rst) begin
            microcode_instruction <= 3'b0;
        end
        else if (!writing_program) begin
            if (microcode_instruction < 3'd2) begin
                case(microcode_instruction)
                3'd0: begin
                    pc_out <= 1'b1; // pc_out
                    mar_in <= 1'b1; // mar_in
                    microcode_instruction <= 3'd1;
                end
                3'd1: begin
                    mdr_out <= 1'b1; // mdr_out
                    ir_in <= 1'b1; // ir_in
                    pc_increment <= 1'b1; // pc_increment
                    microcode_instruction <= 3'd2;
                end
                default: ;
                endcase
            end
            else begin
                case(ir_data[15:12])
                4'b0000: begin // halt, read, write, jump
                    case(ir_data[1:0])
                    2'b00: begin // halt
                        halt <= 1'b1;
                    end
                    2'b01: begin // read
                        in_out <= 1'b1;
                        reg_sel <= ir_data[11:8];
                        reg_in <= 1'b1;
                    end
                    2'b10: begin // write
                        out_in <= 1'b1;
                        reg_sel <= ir_data[11:8];
                        reg_out <= 1'b1;
                    end
                    2'b11: begin // jump
                        pc_jump <= 1'b1;
                        reg_sel <= ir_data[11:8];
                        reg_out <= 1'b1;
                    end
                    endcase
                    microcode_instruction <= 3'd0;
                end
                4'b0001: begin // setn
                    reg_sel <= ir_data[11:8];
                    reg_in <= 1'b1;
                    control_out_reg <= {8'b0, ir_data[7:0]};
                    control_out_enable <= 1'b1;
                    microcode_instruction <= 3'd0;
                end
                4'b0010: begin // loadn
                    case(microcode_instruction)
                    3'd2: begin // move memory address to mar
                        mar_in <= 1'b1; // mar_in
                        control_out_enable <= 1'b1;
                        control_out_reg <= {8'b0, ir_data[7:0]};
                        microcode_instruction <= 3'd3;
                    end
                    3'd3: begin // move memory data to register
                        mdr_out <= 1'b1;
                        reg_sel <= ir_data[11:8];
                        reg_in <= 1'b1;
                        microcode_instruction <= 3'd0;
                    end
                    default: $stop;
                    endcase
                end
                4'b0011: begin // storen
                    case(microcode_instruction)
                    3'd2: begin // move memory address to mar
                        mar_in <= 1'b1;
                        control_out_enable <= 1'b1;
                        control_out_reg <= {8'b0, ir_data[7:0]};
                        microcode_instruction <= 3'd3;
                    end
                    3'd3: begin // move register to memory data
                        mdr_in <= 1'b1;
                        reg_sel <= ir_data[11:8];
                        reg_out <= 1'b1;
                        microcode_instruction <= 3'd0;
                    end
                    default: $stop;
                    endcase
                end
                4'b0100: begin // loadr, storer, popr, pushr
                    if (ir_data[1] == 0) begin// loadr, storer
                        case(microcode_instruction)
                        3'd2: begin // move address from register into mar
                            mar_in <= 1'b1;
                            reg_sel <= ir_data[7:4];
                            reg_out <= 1'b1;
                            microcode_instruction <= 3'd3;
                        end
                        3'd3: begin 
                            // if ir_data[0] == 0, load register from memory
                            // if ir_data[0] == 1, store register to memory
                            mdr_out <= ~ir_data[0];
                            mdr_in <= ir_data[0];

                            reg_sel <= ir_data[11:8];

                            reg_in <= ~ir_data[0];
                            reg_out <= ir_data[0];

                            microcode_instruction <= 3'd0;
                        end
                        default: $stop;
                        endcase
                    end
                    else begin// pushr, popr
                        if (ir_data[0] == 0) begin // popr
                            case(microcode_instruction)
                            3'd2: begin // load tmp0 with address from register
                                reg_sel <= ir_data[7:4];
                                reg_out <= 1'b1;
                                tmp0_in <= 1'b1;
                                microcode_instruction <= 3'd3;
                            end
                            3'd3: begin // load tmp1 with -1
                                control_out_reg <= 16'b1111_1111_1111_1111;
                                control_out_enable <= 1'b1;
                                tmp1_in <= 1'b1;
                                microcode_instruction <= 3'd4;
                            end
                            3'd4: begin // add tmp0 and tmp1 (this subtracts one from the initial register), then read this new value into mar and the original register
                                alu_op <= 3'b000;
                                alu_out <= 1'b1;
                                reg_sel <= ir_data[7:4];
                                reg_in <= 1'b1;
                                mar_in <= 1'b1;
                                microcode_instruction <= 3'd5;
                            end
                            3'd5: begin // move memory data to register
                                mdr_out <= 1'b1;
                                reg_sel <= ir_data[11:8];
                                reg_in <= 1'b1;
                                microcode_instruction <= 3'd0;
                            end
                            default: $stop;
                            endcase
                        end
                        else begin // pushr
                            case(microcode_instruction)
                            3'd2: begin // move address from register into mar and tmp0
                                mar_in <= 1'b1;
                                tmp0_in <= 1'b1;
                                reg_sel <= ir_data[7:4];
                                reg_out <= 1'b1;
                                microcode_instruction <= 3'd3;
                            end
                            3'd3: begin // move memory data into address
                                mdr_in <= 1'b1;
                                reg_sel <= ir_data[11:8];
                                reg_out <= 1'b1;
                                microcode_instruction <= 3'd4;
                            end
                            3'd4: begin // load tmp1 with 1
                                control_out_reg <= 16'b0000_0000_0000_0001;
                                control_out_enable <= 1'b1;
                                tmp1_in <= 1'b1;
                                microcode_instruction <= 3'd5;
                            end
                            3'd5: begin // add tmp0 and tmp1 (this adds one to the initial register), then read this new value into mar and the original register
                                alu_op <= 3'b000;
                                alu_out <= 1'b1;
                                reg_sel <= ir_data[7:4];
                                reg_in <= 1'b1;
                                mar_in <= 1'b1;
                                microcode_instruction <= 3'd0;
                            end
                            default: $stop;
                            endcase
                        end
                    end
                end
                4'b0101: begin // addn
                    case(microcode_instruction)
                    3'd2: begin // move immediate into tmp0
                        control_out_reg <= {{8{ir_data[7]}}, ir_data[7:0]};
                        control_out_enable <= 1'b1;
                        tmp0_in <= 1'b1;
                        microcode_instruction <= 3'd3;  
                    end
                    3'd3: begin // move register into tmp1
                        reg_sel <= ir_data[11:8];
                        reg_out <= 1'b1;
                        tmp1_in <= 1'b1;
                        microcode_instruction <= 3'd4;
                    end
                    3'd4: begin // add tmp0 and tmp1 and store in register
                        alu_op <= 3'b000;
                        alu_out <= 1'b1;
                        reg_sel <= ir_data[11:8];
                        reg_in <= 1'b1;
                        microcode_instruction <= 3'd0;
                    end
                    default: $stop;
                    endcase
                end
                4'b0110: begin // nop, copy, add
                    // the source code for these is the same
                    // nop means r0 = r0 + r0
                    // copy means rx = ry + r0
                    // add means rx = ry + rz
                    // r0 is always 0, so we can just use it as a dummy register
                    case(microcode_instruction)
                    3'd2: begin // move register z into tmp0
                        reg_sel <= ir_data[3:0];
                        reg_out <= 1'b1;
                        tmp0_in <= 1'b1;
                        microcode_instruction <= 3'd3;
                    end
                    3'd3: begin // move register y into tmp1
                        reg_sel <= ir_data[7:4];
                        reg_out <= 1'b1;
                        tmp1_in <= 1'b1;
                        microcode_instruction <= 3'd4;
                    end
                    3'd4: begin // add tmp0 and tmp1 and store in register x
                        alu_op <= 3'b000;
                        alu_out <= 1'b1;
                        reg_sel <= ir_data[11:8];
                        reg_in <= 1'b1;
                        microcode_instruction <= 3'd0;
                    end
                    default: $stop;
                    endcase
                end
                4'b0111: begin // neg, sub
                    // the source code for these is the same
                    // neg means rx = 0 - ry
                    // sub means rx = ry - rz
                    case(microcode_instruction)
                    3'd2: begin // move register y into tmp0
                        reg_sel <= ir_data[7:4];
                        reg_out <= 1'b1;
                        tmp0_in <= 1'b1;
                        microcode_instruction <= 3'd3;
                    end
                    3'd3: begin // move register z into tmp1
                        reg_sel <= ir_data[3:0];
                        reg_out <= 1'b1;
                        tmp1_in <= 1'b1;
                        microcode_instruction <= 3'd4;
                    end
                    3'd4: begin // subtract tmp0 and tmp1 and store in register x
                        alu_op <= 3'b001;
                        alu_out <= 1'b1;
                        reg_sel <= ir_data[11:8];
                        reg_in <= 1'b1;
                        microcode_instruction <= 3'd0;
                    end
                    default: $stop;
                    endcase
                end
                4'b1000: begin // mul
                    case(microcode_instruction)
                    3'd2: begin // move register z into tmp0
                        reg_sel <= ir_data[3:0];
                        reg_out <= 1'b1;
                        tmp0_in <= 1'b1;
                        microcode_instruction <= 3'd3;
                    end
                    3'd3: begin // move register y into tmp1
                        reg_sel <= ir_data[7:4];
                        reg_out <= 1'b1;
                        tmp1_in <= 1'b1;
                        microcode_instruction <= 3'd4;
                    end
                    3'd4: begin // multiply tmp0 and tmp1 and store in register x
                        alu_op <= 3'b010;
                        alu_out <= 1'b1;
                        reg_sel <= ir_data[11:8];
                        reg_in <= 1'b1;
                        microcode_instruction <= 3'd0;
                    end
                    default: $stop;
                    endcase
                end
                4'b1001: begin // div
                    case(microcode_instruction)
                    3'd2: begin // move register z into tmp0
                        reg_sel <= ir_data[3:0];
                        reg_out <= 1'b1;
                        tmp0_in <= 1'b1;
                        microcode_instruction <= 3'd3;
                    end
                    3'd3: begin // move register y into tmp1
                        reg_sel <= ir_data[7:4];
                        reg_out <= 1'b1;
                        tmp1_in <= 1'b1;
                        microcode_instruction <= 3'd4;
                    end
                    3'd4: begin // divide tmp0 and tmp1 and store in register x
                        alu_op <= 3'b011;
                        alu_out <= 1'b1;
                        reg_sel <= ir_data[11:8];
                        reg_in <= 1'b1;
                        microcode_instruction <= 3'd0;
                    end
                    default: $stop;
                    endcase
                end
                4'b1010: begin // mod
                    case(microcode_instruction)
                    3'd2: begin // move register z into tmp1
                        reg_sel <= ir_data[3:0];
                        reg_out <= 1'b1;
                        tmp1_in <= 1'b1;
                        microcode_instruction <= 3'd3;
                    end
                    3'd3: begin // move register y into tmp0
                        reg_sel <= ir_data[7:4];
                        reg_out <= 1'b1;
                        tmp0_in <= 1'b1;
                        microcode_instruction <= 3'd4;
                    end
                    3'd4: begin // mod tmp0 and tmp1 and store in register x
                        alu_op <= 3'b100;
                        alu_out <= 1'b1;
                        reg_sel <= ir_data[11:8];
                        reg_in <= 1'b1;
                        microcode_instruction <= 3'd0;
                    end
                    default: $stop;
                    endcase
                end
                4'b1011: begin // jumpn, call
                    if (ir_data[11:8] == 4'b0000) begin// jumpn
                        control_out_reg <= {8'b0, ir_data[7:0]};
                        control_out_enable <= 1'b1;
                        pc_jump <= 1'b1;
                        microcode_instruction <= 3'd0;
                    end
                    else begin // call
                        case(microcode_instruction)
                        3'd2: begin // move pc into register x
                            reg_sel <= ir_data[11:8];
                            reg_in <= 1'b1;
                            pc_out <= 1'b1;
                            microcode_instruction <= 3'd3;
                        end
                        3'd3: begin // set pc to jump address
                            control_out_reg <= {8'b0, ir_data[7:0]};
                            control_out_enable <= 1'b1;
                            pc_jump <= 1'b1;
                            microcode_instruction <= 3'd0;
                        end
                        default: $stop;
                        endcase
                    end
                end
                4'b1100, 4'b1101, 4'b1110, 4'b1111: begin // jeqz, jnez, jltz, jgtz
                    case(microcode_instruction)
                    3'd2: begin // move register x into tmp0
                        reg_sel <= ir_data[11:8];
                        reg_out <= 1'b1;
                        tmp0_in <= 1'b1;
                        microcode_instruction <= 3'd3;
                    end
                    3'd3: begin // move 0 into tmp1
                        tmp1_in <= 1'b1;
                        control_out_reg <= 16'b0;
                        control_out_enable <= 1'b1;
                        microcode_instruction <= 3'd4;
                    end
                    3'd4: begin // compare tmp0 and tmp1
                        alu_op <= 3'b000;
                        flags_in <= 1'b1;
                        microcode_instruction <= 3'd5;
                    end
                    3'd5: begin // if zero bit is set, jump
                        if (ir_data[13:12] == 2'b00 && flags_data[1] == 1'b1 || ir_data[13:12] == 2'b01 && flags_data[1] == 1'b0 || ir_data[13:12] == 2'b10 && flags_data[2:1] == 2'b01 || ir_data[13:12] == 2'b11 && flags_data[2] == 1'b1) begin
                            control_out_reg <= {8'b0, ir_data[7:0]};
                            control_out_enable <= 1'b1;
                            pc_jump <= 1'b1;
                        end
                        microcode_instruction <= 3'd0;
                    end
                    default: $stop;
                    endcase
                end
                endcase
            end
        end
    end
endmodule
