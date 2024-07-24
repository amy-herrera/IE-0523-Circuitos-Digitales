module tester(
output reg GTX_CLK, RESET, TX_EN,
output reg [7:0] tx_octet
);

initial begin

//Valores Iniciales de la Simulacion:
GTX_CLK = 0; 
RESET = 0; 
TX_EN = 0;

//Prueba mínima de envío de formato ethernet
#10 RESET = 1;
#55 TX_EN = 1; tx_octet = 8'hFB; 
#10 tx_octet = 8'h05;
#10 tx_octet = 8'h02;
#10 tx_octet = 8'h08;
#10 tx_octet = 8'h06;
#10 tx_octet = 8'h07;
#10 tx_octet = 8'h02;
#10 tx_octet = 8'h03;
#10 tx_octet = 8'h02;
#10 tx_octet = 8'h06;
#10 TX_EN = 0; tx_octet = 8'hFD;
#10 tx_octet = 8'hF7;

// Prueba de enviar un dato erróneo sin que caiga la sincronización
#70 TX_EN = 1; tx_octet = 8'hFB; 
#10 tx_octet = 8'h05;
#10 tx_octet = 8'h02;
#10 tx_octet = 8'h08;
#10 tx_octet = 8'hFF;
#10 tx_octet = 8'h07;
#10 tx_octet = 8'h02;
#10 tx_octet = 8'h03;
#10 tx_octet = 8'h02;
#10 tx_octet = 8'h06;
#10 TX_EN = 0; tx_octet = 8'hFD;
#10 tx_octet = 8'hF7;

// Prueba de enviar dos datos erróneos y perder sincronización 
#70 TX_EN = 1; tx_octet = 8'hFB; 
#10 tx_octet = 8'h05;
#10 tx_octet = 8'h02;
#10 tx_octet = 8'h08;
#10 tx_octet = 8'hFF;
#10 tx_octet = 8'h07;
#10 tx_octet = 8'h02;
#10 tx_octet = 8'hFF;
#10 tx_octet = 8'h02;
#10 tx_octet = 8'h06;
#10 TX_EN = 0; tx_octet = 8'hFD;
#10 tx_octet = 8'hF7;

#80 $finish;
end 

always begin
    #5 GTX_CLK = !GTX_CLK;
end
endmodule