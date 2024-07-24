`include "synchronization.v"
module synchronization_tb;
`include "codegroups.vh"

  // Parameters

  //Ports
  reg  clk;
  reg  rst;
  reg  PUDI;
  reg [9:0] rx_code_group;
  wire [9:0] x;
  wire  rx_even;
  wire  sync_status;
  wire  SUDI;

  synchronization  synchronization_inst (
    .clk(clk),
    .rst(rst),
    .PUDI(PUDI),
    .rx_code_group(rx_code_group),
    .x(x),
    .rx_even(rx_even),
    .sync_status(sync_status),
    .SUDI(SUDI)
  );

always #5  clk = ! clk ;

initial begin
    $dumpfile("out.vcd");
    $dumpvars;
end


initial begin
    clk = 0;
    rst = 0;
    PUDI = 1;
    rx_code_group = 0;

    @(negedge clk) rst = 1;
    @(negedge clk) rst = 0;
    #10 @(posedge clk) rx_code_group = K28_5;
    #10 @(posedge clk) rx_code_group = D5_0;

    #10 @(posedge clk) rx_code_group = K28_5;
    #10 @(posedge clk) rx_code_group = D8_0;

    #10 @(posedge clk) rx_code_group = K28_5;
    #10 @(posedge clk) rx_code_group = D3_0;

    #10 @(posedge clk) rx_code_group = 8'b00010110;
    #10 @(posedge clk) rx_code_group = D4_0;
    
    #10 @(posedge clk) rx_code_group = D5_0;
    #10 @(posedge clk) rx_code_group = D6_0;
    #10 @(posedge clk) rx_code_group = D7_0;


   

    #100 $finish;

end

endmodule