`include "tester.v"
`include "transmisor.v"
`include "synchronization.v"

module testbench;

wire GTX_CLK, RESET, TX_EN;
wire [7:0] tx_octet, tx_o_set;
wire TX_OSET_indicate, SUDI, PUDI, sync_status, rx_even;
wire [9:0] tx_code_group, x;
   
initial begin
  $dumpfile("testbench.vcd"); //Genera un archivo vcd 
  $dumpvars; //Se utilizan todas las variable
end

transmisor transmisor_inst  (
.GTX_CLK(GTX_CLK), 
.RESET(RESET), 
.TX_EN(TX_EN), 
.tx_octet(tx_octet),
.tx_o_set(tx_o_set),
//.TX_OSET_indicate(TX_OSET_indicate),
.tx_code_group(tx_code_group),
.PUDI(PUDI)
);

tester tester_inst (
.GTX_CLK(GTX_CLK), 
.RESET(RESET), 
.TX_EN(TX_EN), 
.tx_octet(tx_octet)
);

synchronization synchronization_inst (
.clk(GTX_CLK), 
.rst(RESET),
.PUDI(PUDI),
.rx_code_group(tx_code_group),
.x(x),
.rx_even(rx_even),
.sync_status(sync_status),
.SUDI(SUDI)
);

endmodule
