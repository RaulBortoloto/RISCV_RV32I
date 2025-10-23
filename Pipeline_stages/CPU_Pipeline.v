module CPU_Pipeline (
    input clk, rst
);

// --- Estágio IF (Instruction Fetch) ---
wire [31:0] PCPlus4_IF, Instr_IF, PC_IF;

// --- Estágio ID (Instruction Decode) ---
wire [31:0] RD1_ID, RD2_ID, ImmExt_ID;
wire [4:0] Rd_ID;
wire [2:0] ALUControl_ID, funct3_ID;
wire [1:0] ImmSrc_ID, ResultSrc_ID;
wire RegWrite_ID, MemWrite_ID, Branch_ID, ALUSrc_ID, Jump_ID;
reg [31:0] Instr_ID, PC_ID, PCPlus4_ID;

// --- Estágio EXE (Execute) ---
wire [31:0] ALUResult_EXE, WriteData_EXE, PCTarget_EXE;
wire PCSrc_EXE;
reg [31:0] RD1_EXE, RD2_EXE, PC_EXE, ImmExt_EXE, PCPlus4_EXE;
reg [4:0] Rd_EXE;
reg [2:0] ALUControl_EXE, funct3_EXE;
reg [1:0] ResultSrc_EXE;
reg Branch_EXE, ALUSrc_EXE, RegWrite_EXE, MemWrite_EXE, Jump_EXE;

// --- Estágio MEM (Memory Access) ---
wire [31:0] ReadData_MEM;
wire [31:0] WriteData_MEM;
wire [31:0] ALUResult_MEM;
wire [31:0] PCPlus4_MEM;
wire [4:0] Rd_MEM;
wire [2:0] funct3_MEM;
wire [1:0] ResultSrc_MEM;
wire MemWrite_MEM, RegWrite_MEM;

// --- Estágio WB (Write Back) ---
wire [31:0] Result_WB;
reg [31:0] ReadData_WB, ALUResult_WB, PCPlus4_WB;
reg [4:0] Rd_WB;
reg [1:0] ResultSrc_WB;
reg RegWrite_WB;

always @(posedge clk) begin
    // --- Propagação do estágio IF para o ID ---
    // A instrução e seu endereço (PC) avançam para o estágio de decodificação.
    Instr_ID <= Instr_IF;
    PC_ID    <= PC_IF;
    PCPlus4_ID <= PCPlus4_IF;

    // --- Propagação do estágio ID para o EXE ---
    // Os dados lidos do banco de registradores (RD1, RD2), o imediato, o endereço do registrador
    // de destino (Rd) e todos os sinais de controle avançam para o estágio de execução.
    PC_EXE          <= PC_ID;
    RD1_EXE         <= RD1_ID;
    RD2_EXE         <= RD2_ID;
    ImmExt_EXE      <= ImmExt_ID;
    Rd_EXE          <= Rd_ID;
    ALUControl_EXE  <= ALUControl_ID;
    ALUSrc_EXE      <= ALUSrc_ID;
    Branch_EXE      <= Branch_ID;
    MemWrite_EXE    <= MemWrite_ID;
    ResultSrc_EXE   <= ResultSrc_ID;
    Jump_EXE        <= Jump_ID;
    RegWrite_EXE    <= RegWrite_ID;
    funct3_EXE      <= funct3_ID;
    PCPlus4_EXE     <= PCPlus4_ID;

    // --- Propagação do estágio EXE para o MEM ---
    //


    // --- Propagação do estágio MEM para o WB ---
    // O dado lido da memória, o resultado da ALU (que passou direto pelo estágio MEM),
    // o Rd e os sinais de controle para WB avançam para o estágio de escrita.
    // O sinal MemWrite não avança, pois foi usado em MEM.
    ReadData_WB <= ReadData_MEM;
    ALUResult_WB <= ALUResult_MEM;
    Rd_WB <= Rd_MEM;
    ResultSrc_WB <= ResultSrc_MEM;
    RegWrite_WB <= RegWrite_MEM;
    PCPlus4_WB <= PCPlus4_MEM;
end

assign ALUResult_MEM = ALUResult_EXE;
assign WriteData_MEM = WriteData_EXE;
assign MemWrite_MEM = MemWrite_EXE;
assign ResultSrc_MEM = ResultSrc_EXE;
assign RegWrite_MEM = RegWrite_EXE;
assign Rd_MEM = Rd_EXE;
assign funct3_MEM = funct3_EXE;
assign PCPlus4_MEM = PCPlus4_EXE;

Fetch_stage INSTRUCTION_FETCH (
    .clk(clk),
    .rst(rst),
    .PCTarget_EXE(PCTarget_EXE),
    .PCSrc_EXE(PCSrc_EXE),
    .PCPlus4_IF(PCPlus4_IF),
    .Instr_IF(Instr_IF),
    .PC_IF(PC_IF)
);
    
Decoder_stage INSTRUCTION_DECODER (
    .clk(clk),
    .rst(rst),
    .RegWrite_WB(RegWrite_WB),
    .Instr_ID(Instr_ID),
    .Result_WB(Result_WB),
    .Rd_WB(Rd_WB),
    .RegWrite_ID(RegWrite_ID),
    .MemWrite_ID(MemWrite_ID),
    .Branch_ID(Branch_ID),
    .Jump_ID(Jump_ID),
    .ALUSrc_ID(ALUSrc_ID),
    .ResultSrc_ID(ResultSrc_ID),
    .ImmSrc_ID(ImmSrc_ID),
    .ALUControl_ID(ALUControl_ID),
    .Rd_ID(Rd_ID),
    .RD1_ID(RD1_ID),
    .RD2_ID(RD2_ID),
    .ImmExt_ID(ImmExt_ID),
    .PC_ID(PC_ID),
    .funct3_ID(funct3_ID)
);

Execution_stage EXECUTE (
    .Branch_EXE(Branch_EXE),
    .Jump_EXE(Jump_EXE),
    .ALUSrc_EXE(ALUSrc_EXE),
    .ALUControl_EXE(ALUControl_EXE),
    .RD1_EXE(RD1_EXE),
    .RD2_EXE(RD2_EXE),
    .PC_EXE(PC_EXE),
    .ImmExt_EXE(ImmExt_EXE),
    .ALUResult_EXE(ALUResult_EXE),
    .PCTarget_EXE(PCTarget_EXE),
    .WriteData_EXE(WriteData_EXE),
    .PCSrc_EXE(PCSrc_EXE),
    .ResultSrc_EXE(ResultSrc_EXE),
    .Rd_EXE(Rd_EXE)
);

Memory_stage MEMORY (
    .clk(clk),
    .WriteData_MEM(WriteData_MEM),
    .MemWrite_MEM(MemWrite_MEM),
    .ReadData_MEM(ReadData_MEM),
    .ALUResult_MEM(ALUResult_MEM),
    .funct3_MEM(funct3_MEM)
);

WriteBack_stage WriteBack (
    .ReadData_WB(ReadData_WB),
    .ALUResult_WB(ALUResult_WB),
    .ResultSrc_WB(ResultSrc_WB),
    .Result_WB(Result_WB),
    .Rd_WB(Rd_WB),
    .RegWrite_WB(RegWrite_WB),
    .PCPlus4_WB(PCPlus4_WB)
);

endmodule