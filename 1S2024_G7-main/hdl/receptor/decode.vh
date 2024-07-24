function [7:0] DECODE;
    input [9:0] x;
    begin
        case (x)
            K28_0_rd_plus:     DECODE = 8'h1C;
            K28_0_rd_minus:    DECODE = 8'h1C;
            K28_1_rd_plus:     DECODE = 8'h3C;
            K28_1_rd_minus:    DECODE = 8'h3C;
            K28_2_rd_plus:     DECODE = 8'h5C;
            K28_2_rd_minus:    DECODE = 8'h5C;
            K28_3_rd_plus:     DECODE = 8'h7C;
            K28_3_rd_minus:    DECODE = 8'h7C;
            K28_4_rd_plus:     DECODE = 8'h9C;
            K28_4_rd_minus:    DECODE = 8'h9C;
            K28_5_rd_plus:     DECODE = 8'hBC;
            K28_5_rd_minus:    DECODE = 8'hBC;
            K28_6_rd_plus:     DECODE = 8'hDC;
            K28_6_rd_minus:    DECODE = 8'hDC;
            K28_7_rd_plus:     DECODE = 8'hFC;
            K28_7_rd_minus:    DECODE = 8'hFC;
            K23_7_rd_plus:     DECODE = 8'hF7;
            K23_7_rd_minus:    DECODE = 8'hF7;
            K27_7_rd_plus:     DECODE = 8'hFB;
            K27_7_rd_minus:    DECODE = 8'hFB;
            K29_7_rd_plus:     DECODE = 8'hFD;
            K29_7_rd_minus:    DECODE = 8'hFD;
            K30_7_rd_plus:     DECODE = 8'hFE;
            K30_7_rd_minus:    DECODE = 8'hFE;
            D0_0_rd_plus:      DECODE = 8'h00;
            D0_0_rd_minus:     DECODE = 8'h00;
            D1_0_rd_plus:      DECODE = 8'h01;
            D1_0_rd_minus:     DECODE = 8'h01;
            D2_0_rd_plus:      DECODE = 8'h02;
            D2_0_rd_minus:     DECODE = 8'h02;
            D3_0_rd_plus:      DECODE = 8'h03;
            D3_0_rd_minus:     DECODE = 8'h03;
            D4_0_rd_plus:      DECODE = 8'h04;
            D4_0_rd_minus:     DECODE = 8'h04;
            D5_0_rd_plus:      DECODE = 8'h05;
            D5_0_rd_minus:     DECODE = 8'h05;
            D6_0_rd_plus:      DECODE = 8'h06;
            D6_0_rd_minus:     DECODE = 8'h06;
            D7_0_rd_plus:      DECODE = 8'h07;
            D7_0_rd_minus:     DECODE = 8'h07;
            D8_0_rd_plus:      DECODE = 8'h08;
            D8_0_rd_minus:     DECODE = 8'h08;
            D5_6_rd_plus:      DECODE = 8'hC5;
            D5_6_rd_minus:     DECODE = 8'hC5;
            D16_2_rd_plus:     DECODE = 8'h50;
            D16_2_rd_minus:    DECODE = 8'h50;
            default:           DECODE = 8'bxxxx_xxxx;
        endcase
    end
endfunction
