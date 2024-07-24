`include "tester.v"
`include "transmisor.v"

module transmit_Tb;

  wire GTX_CLK, RESET, TX_EN;
  wire [7:0] tx_octet;
  wire [7:0] tx_o_set;
  wire TX_OSET_indicate;
  wire [9:0] tx_code_group;

  initial begin
    $dumpfile("testbench.vcd");  //Genera un archivo vcd 
    $dumpvars;  //Se utilizan todas las variable
  end

  transmisor U0 (
      .GTX_CLK(GTX_CLK),
      .RESET(RESET),
      .TX_EN(TX_EN),
      .tx_octet(tx_octet),
      .tx_o_set(tx_o_set),
      .TX_OSET_indicate(TX_OSET_indicate),
      .tx_code_group(tx_code_group)
  );

  tester P0 (
      .GTX_CLK(GTX_CLK),
      .RESET(RESET),
      .TX_EN(TX_EN),
      .tx_octet(tx_octet)
  );

endmodule
