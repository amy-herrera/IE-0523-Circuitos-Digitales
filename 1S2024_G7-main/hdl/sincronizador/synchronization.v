// Sincronizador PCS de la clausula 36 del 802.3
module synchronization (
    input clk,
    input rst,
    input wire PUDI,
    input [9:0] rx_code_group,
    output [9:0] x,
    output rx_even,
    output reg sync_status,
    output reg SUDI
);
  `include "codegroups.vh"
  `include "funcs.vh"

  wire cgbad; // grupo invalido y COMMA*rx_even
  wire cggood; // ~(cgbad)
  wire comma; // comma = 1 cuando tx_code_group=/COMMA/
  reg [2:0] good_cgs, next_good_cgs; // contador de intentos de sync

  wire K28_1, K28_5, K28_7;

  // Estados
  localparam   LOSS_OF_SYNC = 10'd1,
               COMMA_DETECT_1 = 10'd2,
               ACQUIRE_SYNC_1 = 10'd4,
               COMMA_DETECT_2 = 10'd8,
               ACQUIRE_SYNC_2 = 10'd16,
               COMMA_DETECT_3 = 10'd32,
               SYNC_ACQUIRED_1 = 10'd64,
               SYNC_ACQUIRED_2 = 10'd128,
               SYNC_ACQUIRED_2A = 10'd256;

  reg [8:0] state, next;
  reg even, next_even;

  // Cambio de proximo estado
  always @(posedge clk) begin
    if (!rst) state <= LOSS_OF_SYNC;
    else state <= next;
  end

  // Cambio de la variable even para la salida rx_even
  always @(posedge clk) begin
    if (!rst) even <= 1;
    else even <= next_even;
  end

  always @(posedge clk) begin
    if (!rst) good_cgs <= 0;
    else good_cgs <= next_good_cgs;
  end

  always @(*) begin
    next = state;
    next_even = even;
    next_good_cgs = good_cgs;
    SUDI = 1;
    sync_status = 0;
    case (state)
      LOSS_OF_SYNC: begin
        next_even = ~even;
        if(PUDI & comma) next = COMMA_DETECT_1;
      end
      COMMA_DETECT_1: begin
        next_even = 1;
        if(PUDI & D(rx_code_group)) next = ACQUIRE_SYNC_1;
        else if(PUDI & ~D(rx_code_group)) next = LOSS_OF_SYNC;
      end
      ACQUIRE_SYNC_1: begin
        next_even = ~even;
        if(cgbad) next = LOSS_OF_SYNC;
        else if(~next_even & PUDI & comma) next = COMMA_DETECT_2;
      end
      COMMA_DETECT_2: begin
        next_even = 1;
        if(PUDI & D(rx_code_group)) next = ACQUIRE_SYNC_2;
        else if(PUDI & ~D(rx_code_group)) next = LOSS_OF_SYNC;
      end
      ACQUIRE_SYNC_2: begin
        next_even = ~even;
        if(cgbad) next = LOSS_OF_SYNC;
        else if(~next_even & PUDI & comma) next = COMMA_DETECT_3;
      end
      COMMA_DETECT_3: begin
        next_even = 1;
        if(PUDI & D(rx_code_group)) next = SYNC_ACQUIRED_1;
        else if(PUDI & ~D(rx_code_group)) next = LOSS_OF_SYNC;
      end
      SYNC_ACQUIRED_1: begin
        next_even = ~even;
        sync_status = 1;
        if(cgbad) next = SYNC_ACQUIRED_2;
      end
      SYNC_ACQUIRED_2: begin
        next_even = ~even;
        next_good_cgs = 0;
        sync_status = 1;
        if(cggood) next = SYNC_ACQUIRED_2A;
        else next = LOSS_OF_SYNC;
      end
      SYNC_ACQUIRED_2A: begin
        next_even = ~even;
        next_good_cgs = good_cgs + 1;
        sync_status = 1;
        if(cggood && (good_cgs == 3)) next = SYNC_ACQUIRED_1;
        else if(cgbad) next = LOSS_OF_SYNC;
      end
      default: next = state;
    endcase
  end


  // Asignación de salidas
  assign rx_even = even;
  assign x = rx_code_group;
  assign cgbad = PUDI & (~D(rx_code_group) | (comma & next_even));
  assign cggood = ~cgbad;

  // Grupos especiales
  assign K28_5 = (rx_code_group == K28_5_rd_plus ) | (rx_code_group == K28_5_rd_minus);
  assign K28_1 = (rx_code_group == K28_1_rd_plus ) | (rx_code_group == K28_1_rd_minus);
  assign K28_7 = (rx_code_group == K28_7_rd_plus ) | (rx_code_group == K28_7_rd_minus);
  assign comma =  K28_1 | K28_5 | K28_7;

endmodule
