module alu (
    input signed [15:0] tmp1, tmp2,
    input [2:0] op,
    input enable,
    output signed [15:0] result,
    output zero,
    output carry,
    output sign
);
    reg signed [16:0] result_with_carry;
    assign carry = result_with_carry[16];
    // TODO: make this output Z when enable is off
    assign result = enable ? result_with_carry[15:0] : 16'dZ;
    // assign zero = (result == 0) ? 1'b1 : 1'b0;
    assign zero = ~|result_with_carry[15:0];
    assign sign = result_with_carry[15];

    always @* begin
        case(op) 
            3'b000: begin // +
                result_with_carry = tmp1 + tmp2;
                if ((!tmp1[15]) && (!tmp2[15]) && result_with_carry[15]) // positive + positive = negative
                    result_with_carry[16] = 1'b1;
                else if (tmp1[15] && tmp2[15] && (!result_with_carry[15])) // negative + negative = positive
                    result_with_carry[16] = 1'b1;
                else
                    result_with_carry[16] = 1'b0;
            end
            3'b001: begin // -
                result_with_carry = tmp1 - tmp2;
                if ((!tmp1[15]) && tmp2[15] && result_with_carry[15]) // positive - negative = positive
                    result_with_carry[16] = 1'b1;
                else if (tmp1[15] && (!tmp2[15]) && (!result_with_carry[15])) // negative - positive = negative
                    result_with_carry[16] = 1'b1;
                else
                    result_with_carry[16] = 1'b0;
            end
            3'b010: result_with_carry = tmp1 * tmp2; // *
            3'b011: begin // /
                result_with_carry[15:0] = tmp1 / tmp2;
                result_with_carry[16] = 1'b0;
            end
            3'b100: result_with_carry = {1'b0, tmp1 % tmp2}; // %
            default: result_with_carry = 17'b0;
        endcase
    end
endmodule