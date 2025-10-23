module tb_CPU_Pipeline;
    
reg clk;
reg rst;

CPU_Pipeline DUT (
    .clk(clk),
    .rst(rst)
);

/* DECLARAÇÃO DOS SINAIS QUE SERÃO MONITORADOS PARA COMPROVAR O FUNCIONAMENTO DO CIRCUITO */
wire [31:0] PC; assign PC = DUT.PC_IF; //!Endereço a ser lido pela INSTRUCTRION_MEMORY
wire [31:0] PC_Instruction; assign PC_Instruction = DUT.Instr_IF; //!Instruções fornecidas pelo INSTRUCTION_MEMORY

wire [31:0] t0; assign t0 = DUT.INSTRUCTION_DECODER.REGISTER_FILE.registers[5];
wire [31:0] t1; assign t1 = DUT.INSTRUCTION_DECODER.REGISTER_FILE.registers[6];
wire [31:0] t2; assign t2 = DUT.INSTRUCTION_DECODER.REGISTER_FILE.registers[7];
wire [31:0] t3; assign t3 = DUT.INSTRUCTION_DECODER.REGISTER_FILE.registers[28];
wire [31:0] t4; assign t4 = DUT.INSTRUCTION_DECODER.REGISTER_FILE.registers[29];
wire [31:0] t5; assign t5 = DUT.INSTRUCTION_DECODER.REGISTER_FILE.registers[30];
wire [31:0] t6; assign t6 = DUT.INSTRUCTION_DECODER.REGISTER_FILE.registers[31];

// Posição 0
wire [31:0] mem_address_0x00;
assign mem_address_0x00 = {DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte3.mem[0], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte2.mem[0],
    DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte1.mem[0], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte0.mem[0]};

// Posição 1
wire [31:0] mem_address_0x04;
assign mem_address_0x04 = {DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte3.mem[1], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte2.mem[1],
    DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte1.mem[1], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte0.mem[1]};

// Posição 2
wire [31:0] mem_address_0x08;
assign mem_address_0x08 = {DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte3.mem[2], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte2.mem[2],
    DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte1.mem[2], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte0.mem[2]};

// Posição 3
wire [31:0] mem_address_0x0C;
assign mem_address_0x0C = {DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte3.mem[3], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte2.mem[3],
    DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte1.mem[3], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte0.mem[3]};

// Posição 4
wire [31:0] mem_address_0x10;
assign mem_address_0x10 = {DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte3.mem[4], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte2.mem[4],
    DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte1.mem[4], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte0.mem[4]};

// Posição 5
wire [31:0] mem_address_0x14;
assign mem_address_0x14 = {DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte3.mem[5], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte2.mem[5],
    DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte1.mem[5], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte0.mem[5]};

// Posição 6
wire [31:0] mem_address_0x18;
assign mem_address_0x18 = {DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte3.mem[6], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte2.mem[6],
    DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte1.mem[6], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte0.mem[6]};

// Posição 7
wire [31:0] mem_address_0x1C;
assign mem_address_0x1C = {DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte3.mem[7], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte2.mem[7],
    DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte1.mem[7], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte0.mem[7]};

// Posição 8
wire [31:0] mem_address_0x20;
assign mem_address_0x20 = {DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte3.mem[8], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte2.mem[8],
    DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte1.mem[8], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte0.mem[8]};

// Posição 9
wire [31:0] mem_address_0x24;
assign mem_address_0x24 = {DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte3.mem[9], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte2.mem[9],
    DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte1.mem[9], DUT.MEMORY.DATA_MEMORY.mem_inst.mem_byte0.mem[9]};

/* LOOPS DO TESTBENCH */
initial clk = 0; always #5 clk = ~clk;   //!Ciclo do clock
 
initial begin rst = 1; #3 rst = 0;
    #500 $stop;
end

endmodule