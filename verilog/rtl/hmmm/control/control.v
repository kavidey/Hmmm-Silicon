module control
(
    input wire clk,
    input wire rst,

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
        
        if (rst)
            microcode_instruction <= 3'b0;
        else
            if (microcode_instruction < 3'd2)
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
            else
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
                        control_out_reg <= {12'b0, ir_data[11:8]};
                        control_out_enable <= 1'b1;
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
                    endcase
                end
                endcase
    end
endmodule