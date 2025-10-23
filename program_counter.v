module program_counter (
    input wire clk,
    input wire rst,
    input wire [31:0] PCNext,
    output reg [31:0] PC
);
    
    always @(posedge clk, posedge rst) begin
        if (rst) begin
            PC <= 32'd0;
        end else begin
            PC <= PCNext;
        end
    end

endmodule