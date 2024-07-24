function D;
  input [9:0] x;
  begin
    case (x)
        K28_0_rd_plus:   D = 1;
        K28_0_rd_minus:  D = 1;
        K28_1_rd_plus:   D = 1;
        K28_1_rd_minus:  D = 1;
        K28_2_rd_plus:   D = 1;
        K28_2_rd_minus:  D = 1;
        K28_3_rd_plus:   D = 1;
        K28_3_rd_minus:  D = 1;
        K28_4_rd_plus:   D = 1;
        K28_4_rd_minus:  D = 1;
        K28_5_rd_plus:   D = 1;
        K28_5_rd_minus:  D = 1;
        K28_6_rd_plus:   D = 1;
        K28_6_rd_minus:  D = 1;
        K28_7_rd_plus:   D = 1;
        K28_7_rd_minus:  D = 1;
        K23_7_rd_plus:   D = 1;
        K23_7_rd_minus:  D = 1;
        K27_7_rd_plus:   D = 1;
        K27_7_rd_minus:  D = 1;
        K29_7_rd_plus:   D = 1;
        K29_7_rd_minus:  D = 1;
        K30_7_rd_plus:   D = 1;
        K30_7_rd_minus:  D = 1;
        D0_0_rd_plus:    D = 1;
        D0_0_rd_minus:   D = 1;
        D1_0_rd_plus:    D = 1;
        D1_0_rd_minus:   D = 1;
        D2_0_rd_plus:    D = 1;
        D2_0_rd_minus:   D = 1;
        D3_0_rd_plus:    D = 1;
        D3_0_rd_minus:   D = 1;
        D4_0_rd_plus:    D = 1;
        D4_0_rd_minus:   D = 1;
        D5_0_rd_plus:    D = 1;
        D5_0_rd_minus:   D = 1;
        D6_0_rd_plus:    D = 1;
        D6_0_rd_minus:   D = 1;
        D7_0_rd_plus:    D = 1;
        D7_0_rd_minus:   D = 1;
        D8_0_rd_plus:    D = 1;
        D8_0_rd_minus:   D = 1;
        D5_6_rd_plus:    D = 1;
        D5_6_rd_minus:   D = 1;
        D16_2_rd_plus:   D = 1;
        D16_2_rd_minus:  D = 1;
        default:          D = 0;
    endcase
  end
endfunction