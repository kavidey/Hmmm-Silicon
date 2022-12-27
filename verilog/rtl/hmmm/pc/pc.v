module pc 
#(
    parameter N = 8
)
(
    input wire clk,
    input wire rst,
    input wire pc_out,
    input wire jump,
    input wire increment,
    inout wire [N-1:0] data
);

    reg [N-1:0] internal_pc;

    assign data = pc_out ? internal_pc : {N{1'bZ}};

    always @(posedge clk) begin
        if (rst)
            internal_pc <= 0;
        else if (jump)
            internal_pc <= data;
        else if (increment)
            internal_pc <= internal_pc + 1;
    end

endmodule