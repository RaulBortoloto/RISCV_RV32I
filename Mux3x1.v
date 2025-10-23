module Mux3x1 #(parameter N = 32)
(
    input [N-1:0] a,
    input [N-1:0] b,
    input [N-1:0] c,
    input [1:0] sel,
    output reg [N-1:0] y

);
    always @(*) begin
        case (sel)
            2'b00: y = a;
            2'b01: y = b;
            2'b10: y = c;
            default: y = a;
        endcase
    end
endmodule