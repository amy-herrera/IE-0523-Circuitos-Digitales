`include "reciever.v"
module reciever_tb;
`include "codegroups.vh"
  // Parameters

  //Ports
  reg  clk;
  reg  rst;
  reg  sync_status;
  reg  rx_even;
  reg  SUDI;
  reg [9:0] x;
  wire [7:0] RXD;
  wire  RX_DV;
  wire  RX_CLK;

  reciever  reciever_inst (
    .clk(clk),
    .rst(rst),
    .sync_status(sync_status),
    .rx_even(rx_even),
    .SUDI(SUDI),
    .x(x),
    .RXD(RXD),
    .RX_DV(RX_DV),
    .RX_CLK(RX_CLK)
  );

  always #5  clk = ! clk ;

  initial begin
      $dumpfile("out.vcd");
      $dumpvars;
  end

  initial begin
    clk = 0;
    rst = 0;
    SUDI = 1;
    x = 0;
    rx_even = 1;

    @(negedge clk) rst = 1;
    @(negedge clk) rst = 0;
    #10 @(posedge clk) x = K28_5_rd_plus;
    #10 @(posedge clk) x = D5_0_rd_plus;

    #10 @(posedge clk) x = K27_7_rd_plus;

    #10 @(posedge clk) x = D8_0_rd_plus;
    #10 @(posedge clk) x = D3_0_rd_plus;
    #10 @(posedge clk) x = D4_0_rd_plus;
    #10 @(posedge clk) x = D5_0_rd_plus;
    #10 @(posedge clk) x = D6_0_rd_plus;
    #10 @(posedge clk) x = D7_0_rd_plus;

    #10 @(posedge clk) x = K29_7_rd_plus;
    #10 @(posedge clk) x = K23_7_rd_plus;
    #10 @(posedge clk) x = K28_5_rd_plus;

    #100 $finish;

end

endmodule
