module Fetch_stage (
    input wire clk,
    input wire rst,
    input wire [31:0] PCTarget_EXE,
    input wire PCSrc_EXE,
    output wire [31:0] PCPlus4_IF,
    output wire [31:0] Instr_IF,
    output wire [31:0] PC_IF
);

wire [31:0] PCMux_IF;

//MUX_PCNEXT
Mux2x1 #(
    .N(32)          //!Multiplexador 2x1 de 32 bits
) MUX_PCNEXT (
    .a(PCPlus4_IF),    //!Entrada "0"
    .b(PCTarget_EXE),   //!Entrada "1"
    .sel(PCSrc_EXE),    //!Sinal de seleção
    .y(PCMux_IF)      //!Saída do multiplexador
);

//ADDER_PC
adder ADDER_PC (
    .a(PC_IF),         //!Endereço atual do PROGRAM_COUNTER para gerar PCNext
    .b(32'd4),      //!Constante "4" para gerar PCNext
    .sum(PCPlus4_IF)   //!Sinal de entrada do MUX do PCNext (Entrada 0)
);

//PROGRAM_COUNTER
program_counter PROGRAM_COUNTER (
    .clk(clk),          //!Clock
    .rst(rst),
    .PCNext(PCMux_IF),    //!Próximo endereço do PROGRAM_COUNTER
    .PC(PC_IF)             //!Endereço a ser lido pela INSTRUCTION_MEMORY
);

//INSTRUCTION_MEMORY
instruction_memory INSTRUCTION_MEMORY (
    .A(PC_IF),     //!Endereço a ser lido pela INSTRUCTION_MEMORY
    .RD(Instr_IF)  //!Dados lidos da INSTRUCTION_MEMORY
);
    
endmodule