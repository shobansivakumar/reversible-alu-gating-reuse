`timescale 1ns / 1ps

//  Fredkin Gate
// -----------------------------------------
module fredkin_gate(C, I1, I2, P, Q, R);
    input  [15:0] C, I1, I2;
    output [15:0] P, Q, R;
    assign P = C;
    assign Q = (~C & I1) | (C & I2);
    assign R = (~C & I2) | (C & I1);
endmodule

//  Peres Gate
// ---------------------------------------
module peres_gate(A, B, C, P, Q, R);
    input  [15:0] A, B, C;
    output [15:0] P, Q, R;
    assign P = A;
    assign Q = A ^ B;
    assign R = (A & B) ^ C;
endmodule

//  Peres Gate - 1-bit (used only in full adder)
// ----------------------------------------------
module peres_gate_1bit(A, B, C, P, Q, R);
    input  A, B, C;
    output P, Q, R;
    assign P = A;
    assign Q = A ^ B;
    assign R = (A & B) ^ C;
endmodule

//  Full Adder
// -----------------------------------------------------
module fulladder(a, b, c, sum, carry);
    input  a, b, c;
    output sum, carry;
    wire   gb1_fa, gb2_fa, w1, w2;
    peres_gate_1bit pg1(.A(a),  .B(b),  .C(1'b0),
                        .P(gb1_fa), .Q(w1), .R(w2));
    peres_gate_1bit pg2(.A(w1), .B(c),  .C(w2),
                        .P(gb2_fa), .Q(sum), .R(carry));
endmodule

//  4-bit Ripple Carry Adder
// ----------------------------------------------------------------------
module RIPPLE_CARRY_ADDER4BIT(A, B, Cin, SUM, CARRY);
    input  [3:0] A, B;
    input        Cin;
    output [3:0] SUM;
    output       CARRY;
    wire C1, C2, C3;
    fulladder fa1(.a(A[0]), .b(B[0]), .c(Cin), .sum(SUM[0]), .carry(C1));
    fulladder fa2(.a(A[1]), .b(B[1]), .c(C1),  .sum(SUM[1]), .carry(C2));
    fulladder fa3(.a(A[2]), .b(B[2]), .c(C2),  .sum(SUM[2]), .carry(C3));
    fulladder fa4(.a(A[3]), .b(B[3]), .c(C3),  .sum(SUM[3]), .carry(CARRY));
endmodule

//  8-bit Ripple Carry Adder
// ------------------------------------------------------------------
module RIPPLE_CARRY_ADDER8BIT(A, B, Cin, SUM, CARRY);
    input  [7:0] A, B;
    input        Cin;
    output [7:0] SUM;
    output       CARRY;
    wire C1;
    RIPPLE_CARRY_ADDER4BIT rca1(.A(A[3:0]), .B(B[3:0]), .Cin(Cin),
                                 .SUM(SUM[3:0]), .CARRY(C1));
    RIPPLE_CARRY_ADDER4BIT rca2(.A(A[7:4]), .B(B[7:4]), .Cin(C1),
                                 .SUM(SUM[7:4]), .CARRY(CARRY));
endmodule

//  16-bit Ripple Carry Adder
// -----------------------------------------------------------------------
module RIPPLE_CARRY_ADDER16BIT(A, B, Cin, SUM, CARRY);
    input  [15:0] A, B;
    input         Cin;
    output [15:0] SUM;
    output        CARRY;
    wire C1;
    RIPPLE_CARRY_ADDER8BIT rca1(.A(A[7:0]),  .B(B[7:0]),  .Cin(Cin),
                                 .SUM(SUM[7:0]),  .CARRY(C1));
    RIPPLE_CARRY_ADDER8BIT rca2(.A(A[15:8]), .B(B[15:8]), .Cin(C1),
                                 .SUM(SUM[15:8]), .CARRY(CARRY));
endmodule

//  16-bit Reversible Adder
// ------------------------------------------------------
module REV_ADDER16(A, B, SUM, CARRY);
    input  [15:0] A, B;
    output [15:0] SUM;
    output        CARRY;
    RIPPLE_CARRY_ADDER16BIT rca(.A(A), .B(B), .Cin(1'b0),
                                 .SUM(SUM), .CARRY(CARRY));
endmodule

//  16-bit Reversible Subtractor - garbage reuse
//  reuse 1: gb_sub_p from P output replaces Cin=1'b1 saving 1 ancilla
// ----------------------------------------------------------------
module REV_SUBTRACTOR16(A, B, DIFF, BOUT, gb_sub_p_out);
    input  [15:0] A, B;
    output [15:0] DIFF;
    output        BOUT;
    output [15:0] gb_sub_p_out;
    wire   [15:0] B_not;
    wire   [15:0] gb_sub_p;
    wire   [15:0] gb_sub_r;
    peres_gate pg_not(.A(16'hFFFF), .B(B), .C(16'h0000),
                      .P(gb_sub_p), .Q(B_not), .R(gb_sub_r));
    RIPPLE_CARRY_ADDER16BIT rca(.A(A), .B(B_not), .Cin(gb_sub_p[0]),
                                 .SUM(DIFF), .CARRY(BOUT));
    assign gb_sub_p_out = gb_sub_p;
endmodule

//  16-bit Reversible AND
// -------------------------------------------------
module REV_AND16(A, B, YAND);
    input  [15:0] A, B;
    output [15:0] YAND;
    wire   [15:0] gb_and_p;
    wire   [15:0] gb_and_q;
    peres_gate pg(.A(A), .B(B), .C(16'h0000),
                  .P(gb_and_p), .Q(gb_and_q), .R(YAND));
endmodule

//  16-bit Reversible OR - garbage reused
//  reuse 2: P output from subtractor replacing I2 input saving 16 ancilla inputs
// ----------------------------------------------------
module REV_OR16(A, B, YOR, gb_sub_p_in);
    input  [15:0] A, B;
    input  [15:0] gb_sub_p_in;
    output [15:0] YOR;
    wire   [15:0] gb_or_p;
    wire   [15:0] gb_or_r;
    fredkin_gate fk(.C(A), .I1(B), .I2(gb_sub_p_in),
                    .P(gb_or_p), .Q(YOR), .R(gb_or_r));
endmodule

//  16-bit Reversible XOR
// -----------------------------------------------------
module REV_XOR16(A, B, YXOR);
    input  [15:0] A, B;
    output [15:0] YXOR;
    wire   [15:0] gb_xor_p;
    wire   [15:0] gb_xor_r;
    peres_gate pg(.A(A), .B(B), .C(16'h0000),
                  .P(gb_xor_p), .Q(YXOR), .R(gb_xor_r));
endmodule

//  TOP-Level ALU - BOTH; gating & reuse
// ------------------------------------------------------
module ALU(A, B, sel, Yout);
    input  [15:0] A, B;
    input  [2:0]  sel;
    output reg [16:0] Yout;

    // gating logic
    // --------------------------------------------------------
    wire arith_active;
    wire logic_active;

    assign arith_active = (sel == 3'b000) || (sel == 3'b001);
    assign logic_active = (sel == 3'b010) || (sel == 3'b011) || (sel == 3'b100);

    wire [15:0] A_arith, B_arith;
    wire [15:0] A_logic, B_logic;

    assign A_arith = arith_active ? A : 16'h0000;
    assign B_arith = arith_active ? B : 16'h0000;

    assign A_logic = logic_active ? A : 16'h0000;
    assign B_logic = logic_active ? B : 16'h0000;

    wire [15:0] Yadd, Ydiff, Yand, Yor, Yxor;
    wire        Cadd, Bout;
    wire [15:0] gb_sub_p_reuse;

    REV_ADDER16      u_add (.A(A_arith), .B(B_arith), .SUM(Yadd),  .CARRY(Cadd));

    REV_SUBTRACTOR16 u_sub (.A(A_arith), .B(B_arith), .DIFF(Ydiff), .BOUT(Bout),
                             .gb_sub_p_out(gb_sub_p_reuse));
    REV_AND16        u_and (.A(A_logic), .B(B_logic), .YAND(Yand));

    REV_OR16         u_or  (.A(A_logic), .B(B_logic), .YOR(Yor),
                             .gb_sub_p_in(gb_sub_p_reuse));
    REV_XOR16        u_xor (.A(A_logic), .B(B_logic), .YXOR(Yxor));

    always @(*) begin
        case (sel)
            3'b000:  Yout = {Cadd, Yadd};
            3'b001:  Yout = {Bout, Ydiff};
            3'b010:  Yout = {1'b0, Yand};
            3'b011:  Yout = {1'b0, Yor};
            3'b100:  Yout = {1'b0, Yxor};
            default: Yout = 17'd0;
        endcase
    end
endmodule