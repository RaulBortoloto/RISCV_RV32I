module instruction_memory (
    input [31:0] A,      //!Endereço de leitura
    output reg [31:0] RD //!Dados lidos da memória de instruções
);
    reg [31:0] memory [0:1023]; //!Memória de instruções de 32 bits e 1024 palavras

    initial begin
        $readmemh("/home/aluno/Downloads/aulas1423_jump/PROGRAM_atividade5.mem", memory);
    end

    always @(*) begin
        RD = memory[A[31:2]];
    end

endmodule