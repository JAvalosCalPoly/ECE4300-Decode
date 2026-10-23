`timescale 1ns/1ps
module decodeTB;

// inputs
    reg         clk_tb = 0;
    reg         rst_tb;
    reg         wb_reg_write_tb;
    reg  [4:0]  wb_write_reg_location_tb;
    reg  [31:0] mem_wb_write_data_tb;
    reg  [31:0] if_id_instr_tb;
    reg  [31:0] if_id_npc_tb;

// outputs
    wire [1:0]  id_ex_wb_tb;
    wire [2:0]  id_ex_mem_tb;
    wire [3:0]  id_ex_execute_tb;
    wire [31:0] id_ex_npc_tb;
    wire [31:0] id_ex_readdat1_tb;
    wire [31:0] id_ex_readdat2_tb;
    wire [31:0] id_ex_sign_ext_tb;
    wire [4:0]  id_ex_instr_bits_20_16_tb;
    wire [4:0]  id_ex_instr_bits_15_11_tb;

    decode dut(
        .clk(clk_tb),
        .rst(rst_tb),
        .wb_reg_write(wb_reg_write_tb),
        .wb_write_reg_location(wb_write_reg_location_tb),
        .mem_wb_write_data(mem_wb_write_data_tb),
        .if_id_instr(if_id_instr_tb),
        .if_id_npc(if_id_npc_tb),
        .id_ex_wb(id_ex_wb_tb),
        .id_ex_mem(id_ex_mem_tb),
        .id_ex_execute(id_ex_execute_tb),
        .id_ex_npc(id_ex_npc_tb),
        .id_ex_readdat1(id_ex_readdat1_tb),
        .id_ex_readdat2(id_ex_readdat2_tb),
        .id_ex_sign_ext(id_ex_sign_ext_tb),
        .id_ex_instr_bits_20_16(id_ex_instr_bits_20_16_tb),
        .id_ex_instr_bits_15_11(id_ex_instr_bits_15_11_tb)
    );
// for waves
    wire [5:0] opcode;
    wire [1:0] wb;
    wire [2:0] mem;
    wire [3:0] ex;
assign opcode = if_id_instr_tb[31:26];
assign wb     = dut.wb_internal;   // control out
assign mem    = dut.mem_internal;
assign ex     = dut.ex_internal;


// 2ns clock
always #1 clk_tb = ~clk_tb;

initial begin
$dumpfile("decodeTB.vcd");
$dumpvars(0, decodeTB);
end

// MIPS Instruction Converter https://mips-converter.jeffsieu.com
initial begin
        rst_tb = 1;
        wb_reg_write_tb = 0;
        wb_write_reg_location_tb = 5'd2; // $v0
        mem_wb_write_data_tb = 32'h64;
        if_id_npc_tb = 32'h00000001;

// ADD $v0, $a1, $a0
        if_id_instr_tb = 32'h00a41020;

#2 // reset on

        rst_tb = 0;
#2 // decode RFORMAT

        if_id_npc_tb = 32'h00000002;
// BEQ $zero, $zero, 0x8
        if_id_instr_tb = 32'h10000008;
#2 // decode BEQ

        if_id_npc_tb = 32'h00000003;
// LW $v0, 2($a0)
        if_id_instr_tb = 32'h8c820002;
#2 // decode LW

        if_id_npc_tb = 32'h00000004;
// SW $v0, 2($a0)
        if_id_instr_tb = 32'hac820002;
#2 // decode SW

        if_id_npc_tb = 32'h00000005;
        wb_reg_write_tb = 1;
#2 // register[2] <= 'h64

// ADD $v0, $v0, $v0
        if_id_instr_tb = 32'h00421020;

        if_id_npc_tb = 32'h00000006;
        wb_reg_write_tb = 0;
#2 // check update
#2 // cycle delay
$display("Decode Complete");
$finish;
end

endmodule