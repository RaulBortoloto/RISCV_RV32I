module ALU (
    input [31:0] SrcA,
    input [31:0] SrcB,
    input [2:0] ALUControl,
    output reg [31:0] ALUResult,
    output reg Zero
);

    always @ (*) begin

        case (ALUControl)
            3'b000: ALUResult = SrcA + SrcB; // Soma
            3'b001: ALUResult = SrcA - SrcB; // Subtração
            3'b010: ALUResult = SrcA & SrcB; // AND
            3'b011: ALUResult = SrcA | SrcB; // OR
            3'b101: ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0; // SLT  
            default: ALUResult = 32'd0; 
        endcase

        if (ALUResult == 32'd0) begin
            Zero = 1'b1;
        end else begin
            Zero = 1'b0;
        end
    end
    
endmodule