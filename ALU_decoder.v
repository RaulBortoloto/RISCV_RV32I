// RETIRADO DA TABELA 7.3 NA PÁGINA 409 DA BIBLIOGRAFIA

module ALU_decoder (
    input [1:0] ALUOp,
    input [2:0] funct3,
    input funct7, op,
    output reg [2:0] ALUControl
);

// operações possíveis da ALU
localparam ADD = 3'b000,
           SUB = 3'b001,
           AND = 3'b010,
           OR =  3'b011,
           SLT = 3'b101;

always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = ADD; // instruction lw,sw
        2'b01: ALUControl = SUB; // instruction beq
        2'b10: begin
            case (funct3)
                3'b000: begin
                    if ({op,funct7} == 2'b11) begin
                        ALUControl = SUB; // instruction sub
                    end else begin
                        ALUControl = ADD; // instruction add
                    end
                end
                3'b010: ALUControl = SLT; // instruction slt
                3'b110: ALUControl = OR; // instruction or
                3'b111: ALUControl = AND; // instruction AND
                default: ALUControl = ADD; // caso inválido
            endcase
        end
        default: ALUControl = ADD; // caso inválido
    endcase
end

endmodule