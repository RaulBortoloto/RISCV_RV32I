module Memory_stage (
    input wire clk,
    input wire MemWrite_MEM,
    input wire [2:0] funct3_MEM,
    input wire [31:0] WriteData_MEM,
    input wire [31:0] ALUResult_MEM,
    output wire [31:0] ReadData_MEM
);

//DATA_MEMORY
memTopo32LittleEndian #(
    .DATA_WIDTH(32),
    .ADDRESS_WIDTH(6)
) DATA_MEMORY (
    .clk(clk),      //!Clock
    .addr(ALUResult_MEM[5:0]),  //!Endereço de leitura/escrita
    .din(WriteData_MEM), //!Dados a serem escritos
    .writeEnable(MemWrite_MEM),  //!Sinal de habilitação de escrita (ativo em 1)            
    .dout(ReadData_MEM),   //!Dados lidos da DATA_MEMORY
    .size(funct3_MEM[1:0]),
    .sign_ext(funct3_MEM[2])
);
    
endmodule