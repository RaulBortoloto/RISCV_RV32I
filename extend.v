module extend (
    input [31:7] instr,      //! Imediato da instrução a ser processada
    input [1:0]  immsrc,     //! Comando contendo o tipo de extensão a ser realizado
    output reg [31:0] immext //! Saída contendo a extensão da instrução
);

always @(*) begin
    case (immsrc)
        2'b00: immext = { {20{instr[31]}}, instr[31:20] }; // I-type
        2'b01: immext = { {20{instr[31]}}, instr[31:25], instr[11:7] }; // S-type (store)
        2'b10: immext = { {20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0 }; // B-type (branches)
        2'b11: immext = { {12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0 }; // J-type (jal)
        default: immext = 32'bx; // undefined
    endcase
end

endmodule
