module pc 
(
    input wire clk,
    input wire rst,
    input wire pc_out,
    input wire jump,
    input wire increment,
    inout wire [15:0] data
);

    reg [7:0] internal_pc;

    assign data = pc_out ? {8'b0, internal_pc} : {16'bZ};

    always @(posedge clk) begin
        if (rst)
            internal_pc <= 0;
        else if (jump)
            internal_pc <= data[7:0];
        else if (increment)
            internal_pc <= internal_pc + 1;
    end

endmodule