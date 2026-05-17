`timescale 1ns / 1ps

module ALU_both_tb;

    // Inputs
    // --------------------------------------------------------
    reg [15:0] A;
    reg [15:0] B;
    reg [2:0]  sel;

    // Output
    // --------------------------------------------------------
    wire [16:0] Yout;
    
    ALU uut (
        .A(A),
        .B(B),
        .sel(sel),
        .Yout(Yout)
    );

    // Monitor output
    // --------------------------------------------------------
    initial begin
        $monitor("Time=%0t | A=%h | B=%h | sel=%b | Yout=%h",
                 $time, A, B, sel, Yout);
    end

    always @(sel) begin
        case(sel)
            3'b000: $display("Time=%0t | ADD | ARITH ON | LOGIC GATED | No reuse", $time);
            3'b001: $display("Time=%0t | SUB | ARITH ON | LOGIC GATED | REUSE: gb_sub_p[0] as Cin", $time);
            3'b010: $display("Time=%0t | AND | LOGIC ON | ARITH GATED | No reuse", $time);
            3'b011: $display("Time=%0t | OR  | LOGIC ON | ARITH GATED | REUSE: gb_sub_p as I2", $time);
            3'b100: $display("Time=%0t | XOR | LOGIC ON | ARITH GATED | No reuse", $time);
            default:$display("Time=%0t | IDLE | ALL GATED | No reuse", $time);
        endcase
    end
    
    initial begin

        A   = 16'h0000;
        B   = 16'h0000;
        sel = 3'b000;
        #10;

//        // 16-BIT TESTS
//        // ------------------------------------------------------

//        // Addition
//        A = 16'h1234; B = 16'h5678; sel = 3'b000; #10; // 068AC
//        A = 16'hFFFF; B = 16'h0001; sel = 3'b000; #10; // carry=10000
//        A = 16'hA3F1; B = 16'h4C2D; sel = 3'b000; #10; // F01E

//        // SUubtraction
//        A = 16'h5678; B = 16'h1234; sel = 3'b001; #10; // 4444
//        A = 16'h0001; B = 16'h0002; sel = 3'b001; #10; // borrow
//        A = 16'hF0F0; B = 16'h0F0F; sel = 3'b001; #10; // E1E1

//        // AND operation
//        A = 16'hF0F0; B = 16'hFF00; sel = 3'b010; #10; // F000
//        A = 16'hABCD; B = 16'hDCBA; sel = 3'b010; #10; // 8888
//        A = 16'h1234; B = 16'hFEDC; sel = 3'b010; #10; // 1214

//        // OR operation
//        A = 16'hF0F0; B = 16'hFF00; sel = 3'b011; #10; // FFF0
//        A = 16'hABCD; B = 16'hDCBA; sel = 3'b011; #10; // FFFF
//        A = 16'h1234; B = 16'hFEDC; sel = 3'b011; #10; // FEFC

//        // XOR operation
//        A = 16'hF0F0; B = 16'hFF00; sel = 3'b100; #10; // 0FF0
//        A = 16'hABCD; B = 16'hDCBA; sel = 3'b100; #10; // 7777
//        A = 16'h1234; B = 16'hFEDC; sel = 3'b100; #10; // ECE8

        // 8-BIT TESTS
        // ---------------------------------------------------------

        // Addition
        A = 16'h003C; B = 16'h00F0; sel = 3'b000; #10; // 012C
        A = 16'h00FF; B = 16'h0001; sel = 3'b000; #10; // carry=0100
        A = 16'h00A3; B = 16'h004C; sel = 3'b000; #10; // 00EF

        // Subtraction
        A = 16'h00F0; B = 16'h003C; sel = 3'b001; #10; // 00B4
        A = 16'h0001; B = 16'h0002; sel = 3'b001; #10; // borrow
        A = 16'h00F0; B = 16'h000F; sel = 3'b001; #10; // 00E1

        // AND operation
        A = 16'h00F0; B = 16'h00FF; sel = 3'b010; #10; // 00F0
        A = 16'h00AB; B = 16'h00DC; sel = 3'b010; #10; // 0088
        A = 16'h0012; B = 16'h00FE; sel = 3'b010; #10; // 0012

        // OR operation
        A = 16'h00F0; B = 16'h00FF; sel = 3'b011; #10; // 00FF
        A = 16'h00AB; B = 16'h00DC; sel = 3'b011; #10; // 00FF
        A = 16'h0012; B = 16'h00FE; sel = 3'b011; #10; // 00FE

        // XOR operation
        A = 16'h00F0; B = 16'h00FF; sel = 3'b100; #10; // 000F
        A = 16'h00AB; B = 16'h00DC; sel = 3'b100; #10; // 0077
        A = 16'h0012; B = 16'h00FE; sel = 3'b100; #10; // 00EC

        // UNUSED SEL - Yout forced to 0
        // -------------------------------------------
        A = 16'h1234; B = 16'h5678; sel = 3'b101; #10;
        A = 16'h1234; B = 16'h5678; sel = 3'b110; #10;
        A = 16'h1234; B = 16'h5678; sel = 3'b111; #10;

        #10;
        $finish;
    end

endmodule