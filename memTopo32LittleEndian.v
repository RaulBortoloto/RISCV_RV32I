module memReadManager (
    input wire [31:0] dout, //! Palavra lida da memória (sempre 32 bits)
    input wire [1:0] addr_offset , //! addr[1:0] (offset do byte)
    input wire [1:0] size, //! funct3[1:0] 00: byte, 01: half-word, 10: word
    input wire sign_extend , //! funct3[2] 0: extensão de sinal , 1: zero extension
    output reg [31:0] rdata //! Dado lido final , com extensão adequada
);
reg [7:0] byte_data;
reg [15:0] halfword_data;
always @(*) begin
    case (addr_offset)
        2'b00: begin
        byte_data = dout[7:0];
        halfword_data = dout[15:0];
        end
        2'b01: begin
        byte_data = dout[15:8];
        halfword_data = dout[23:8];
        end
        2'b10: begin
        byte_data = dout[23:16];
        halfword_data = dout[31:16];
        end
        2'b11: begin
        byte_data = dout[31:24];
        halfword_data = {8'b0, dout[31:24]}; // inválido p/ halfword
        end
        default: begin
        byte_data = 8'b0;
        halfword_data = 16'b0;
        end
    endcase
    case (size)
        2'b00: begin // byte
        rdata = ~sign_extend ?
        {{24{byte_data[7]}}, byte_data} :
        {24'b0, byte_data};
        end
        2'b01: begin // half-word
        rdata = ~sign_extend ?
        {{16{halfword_data[15]}}, halfword_data} :
        {16'b0, halfword_data};
        end
        2'b10: begin // word
        rdata = dout;
        end
        default: begin // valor padrao para debug "DEAD BEEF"
        rdata = 32'hDEADBEEF; // erro leitura inválida
        end
    endcase
end
endmodule

module memory_write_first #(
    parameter DATA_WIDTH    = 8,
    parameter ADDRESS_WIDTH = 4,
    parameter INIT_FILE     = "" // NOVO PARÂMETRO para o arquivo de inicialização
) (
    input wire clk,
    input wire we,
    input wire [ADDRESS_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0] din,
    output reg [DATA_WIDTH-1:0] dout
);

    localparam DEPTH = 1 << ADDRESS_WIDTH;
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // --- BLOCO DE INICIALIZAÇÃO ADICIONADO ---
    initial begin
        if (INIT_FILE != "") begin
            $readmemh(INIT_FILE, mem);
        end
    end
    // ------------------------------------------

    always @(posedge clk) begin
        if (we)
            mem[addr] <= din;
        // A lógica de prioridade de escrita já está no seu código, mas para
        // garantir a leitura correta após a inicialização, a leitura assíncrona
        // é suficiente. A linha abaixo é redundante com a always @(*)
        // dout <= we ? din : mem[addr]; 
    end

    // Leitura assíncrona, já presente no seu código original
    always @(*) begin
        dout <= mem[addr];
    end

endmodule

module memByteAddressable32WF #(
    parameter DATA_WIDTH    = 32,
    parameter ADDRESS_WIDTH = 6   
) (
    input  wire                     clk,
    input  wire [3:0]               byteEnable,
    input  wire [ADDRESS_WIDTH-1:0] addr,
    input  wire [DATA_WIDTH-1:0]    din,
    output wire [DATA_WIDTH-1:0]    dout
);  

    // Conecta 4 bancos de byte (LSB = byte 0)
    memory_write_first #(.DATA_WIDTH(8), .ADDRESS_WIDTH(6), .INIT_FILE("/home/aluno/Downloads/RISCV_RV32I-main/data_byte0.mem")) mem_byte0 (
        .clk(clk),
        .we(byteEnable[0]),
        .addr(addr),
        .din(din[7:0]),
        .dout(dout[7:0])
    );

    memory_write_first #(.DATA_WIDTH(8), .ADDRESS_WIDTH(6), .INIT_FILE("/home/aluno/Downloads/RISCV_RV32I-main/data_byte1.mem")) mem_byte1 (
        .clk(clk),
        .we(byteEnable[1]),
        .addr(addr),
        .din(din[15:8]),
        .dout(dout[15:8])
    );

    memory_write_first #(.DATA_WIDTH(8), .ADDRESS_WIDTH(6), .INIT_FILE("/home/aluno/Downloads/RISCV_RV32I-main/data_byte2.mem")) mem_byte2 (
        .clk(clk),
        .we(byteEnable[2]),
        .addr(addr),
        .din(din[23:16]),
        .dout(dout[23:16])
    );

    memory_write_first #(.DATA_WIDTH(8), .ADDRESS_WIDTH(6), .INIT_FILE("/home/aluno/Downloads/RISCV_RV32I-main/data_byte3.mem")) mem_byte3 (
        .clk(clk),
        .we(byteEnable[3]),
        .addr(addr),
        .din(din[31:24]),
        .dout(dout[31:24])
    );

endmodule

module byteEnableDecoder (
input wire [1:0] addr_offset , //! addr[1:0] mem alinhada
input wire [1:0] size, //! funct3[1:0] 00: byte, 01: half, 10: word
output reg [3:0] byteEnable , //! Saida em One Hot para Memoria
input writeEnable //! Habilita escrita (vem do controle)
);
always @(*) begin
    if (!writeEnable)
        byteEnable = 4'b0000;
    else begin
        case (size)
            2'b00: byteEnable = 4'b0001 << addr_offset; // SB
            2'b01: begin // SH
            case (addr_offset)
                2'b00: byteEnable = 4'b0011;
                2'b01: byteEnable = 4'b0110;
                2'b10: byteEnable = 4'b1100;
                default: byteEnable = 4'b0000; // desalinhado
            endcase
            end
            2'b10: byteEnable = 4'b1111; // SW
            default: byteEnable = 4'b0000;
        endcase
    end
end
endmodule

module memTopo32LittleEndian #(
parameter DATA_WIDTH = 32,
parameter ADDRESS_WIDTH = 6
) (
input wire clk, //! Clock
input wire [1:0] size, //! funct3[1:0] 00: byte, 01: half, 10: word
input wire [ADDRESS_WIDTH -1:0] addr, //! Endereco
input wire [DATA_WIDTH -1:0] din, //! Entrada de dados
input wire sign_ext , //! funct3[2] 0: extensão de sinal , 1: zero extension
input wire writeEnable , //! Habilita escrita (vem do controle)
output wire [DATA_WIDTH -1:0] dout //! Saida de dados
);

wire [3:0] byteEnable;
wire [31:0] mem_dout;
wire [31:0] rdata;

wire [31:0] din_to_mem; // O novo MUX de escrita

// Este 'assign' prepara os dados para a escrita:
// - Para 'sw' (10), usa o 'din' original.
// - Para 'sh' (01), replica a metade baixa {din[15:0], din[15:0]}.
// - Para 'sb' (00), replica o byte baixo {din[7:0], din[7:0], din[7:0], din[7:0]}.
assign din_to_mem = (size == 2'b10) ? din :
                    (size == 2'b01) ? {din[15:0], din[15:0]} :
                    {din[7:0], din[7:0], din[7:0], din[7:0]};

byteEnableDecoder decoder (
.addr_offset(addr[1:0]),
.size(size),
.byteEnable(byteEnable),
.writeEnable(writeEnable)
);

memByteAddressable32WF #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDRESS_WIDTH(ADDRESS_WIDTH)
) mem_inst (
.clk(clk),
.byteEnable(byteEnable),
.addr({{2'b00},addr[ADDRESS_WIDTH-1:2]}), // endereçamento por palavra (alinhado)
.din(din_to_mem),
.dout(mem_dout)
);

memReadManager read_inst (
.dout(mem_dout),
.addr_offset(addr[1:0]),
.size(size),
.sign_extend(sign_ext),
.rdata(rdata)
);

assign dout = rdata;

endmodule