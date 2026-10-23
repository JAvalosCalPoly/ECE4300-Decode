module control(
    input wire          clk, rst,
    input wire [5:0]    opcode,
    output reg [1:0]    wb,
    output reg [2:0]    mem,
    output reg [3:0]    ex
);
localparam R_FORM = 6'b000000,
           LW     = 6'b100011,
           SW     = 6'b101011,
           BEQ    = 6'b000100;
initial begin
    wb <= 2'b00;
    mem <= 3'b000;
    ex <= 4'b0000;
end

/*
            | Execution/Address Calculation Stage | Memory Access Stage     |  WriteBack Control Lines
               REGDst  ALUOp1  ALUOp0  ALUSrc      Branch  MemRead  MemWrite  RegWrite  MemToReg
R-Format :       1          1       0       0        0       0         0        1         0
LW       :       0          0       0       1        0       1         0        1         1
SW       :       X          0       0       1        0       0         1        0         X
BEQ      :       X          0       1       0        1       0         0        0         X
*/

always @(posedge clk) begin
    if (rst) begin
        wb <= 2'b00;
        mem <= 3'b000;
        ex <= 4'b0000;
    end else begin
        case (opcode)
            R_FORM: begin
                ex  <= 4'b1100;
                mem <= 3'b000;
                wb  <= 2'b10;
            end
            LW: begin
                ex  <= 4'b0001;
                mem <= 3'b010;
                wb  <= 2'b11;
            end
            SW: begin
                ex  <= 4'b0001;
                mem <= 3'b001;
                wb  <= 2'b00;
            end
            BEQ: begin
                ex  <= 4'b0010;
                mem <= 3'b100;
                wb  <= 2'b00;
            end
            default: begin
                $display("Opcode not recognized: %b", opcode);
                ex  <= 4'b0000;
                mem <= 3'b000; 
                wb  <= 2'b00;
            end
        endcase
    end
end
    

endmodule