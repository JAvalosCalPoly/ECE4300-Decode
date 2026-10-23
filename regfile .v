module regfile(
    input wire clk, rst, regwrite,
    input wire [4:0] rs, rt, rd,
    input wire [31:0] writedata,
    output reg [31:0] A_readdat1, B_readdat2
);

reg [31:0] registers [31:0];
initial begin
    registers[0] = 'h002300AA; //$zero
    registers[1] = 'h10654321; //$v0
    registers[2] = 'h00100022; //$v1
    registers[3] = 'h8C123456;
    registers[4] = 'h8F123456;
    registers[5] = 'hAD654321;
    registers[6] = 'h60000066;
    registers[7] = 'h13012345;
    registers[8] = 'hAC654321;
    registers[9] = 'h12012345;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        A_readdat1 <= 32'b0;
        B_readdat2 <= 32'b0;
    end else begin
        if (regwrite) registers[rd] <= writedata;
        A_readdat1 <= registers[rs];
        B_readdat2 <= registers[rt];
    end
end
endmodule