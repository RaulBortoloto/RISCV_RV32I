module Control_Unit (
    input [6:0] Op,
    input [2:0] funct3,
    input funct7,
    output [1:0] ResultSrc,
    output MemWrite,
    output ALUSrc,
    output [1:0] ImmSrc,
    output RegWrite,
    output [2:0] ALUControl,
    output Branch,
    output Jump
);

wire [1:0] ALUOp;

Main_decoder MainDecoder (
.Op(Op),
.Branch(Branch),
.ResultSrc(ResultSrc),
.MemWrite(MemWrite),
.ALUSrc(ALUSrc),
.ImmSrc(ImmSrc),
.RegWrite(RegWrite),
.ALUOp(ALUOp),
.Jump(Jump)
);

ALU_decoder ALUDecoder (
.ALUOp(ALUOp),
.funct3(funct3),
.funct7(funct7),
.op(Op[5]),
.ALUControl(ALUControl)
);
    
endmodule