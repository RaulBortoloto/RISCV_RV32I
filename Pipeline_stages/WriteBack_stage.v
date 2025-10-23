module WriteBack_stage (
    input wire [31:0] ReadData_WB,
    input wire [31:0] ALUResult_WB,
    input wire [31:0] PCPlus4_WB,
    input wire [1:0] ResultSrc_WB,
    output wire [31:0] Result_WB,
    input wire [4:0] Rd_WB,
    input wire RegWrite_WB
);

//MUX_RESULT
Mux3x1 #(
    .N(32)              //!Multiplexador 3x1 de 32 bits
) MUX_RESULT (      
    .a(ALUResult_WB),      //!Entrada "00"
    .b(ReadData_WB),       //!Entrada "01"
    .c(PCPlus4_WB),       //!Entrada "01"
    .sel(ResultSrc_WB),    //!Sinal de seleção
    .y(Result_WB)          //!Saída do multiplexador
);
    
endmodule