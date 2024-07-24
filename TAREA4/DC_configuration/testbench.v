`include "generador.v"
`include "tester.v"
`include "objetivo.v"

module generador_tb;
wire clk;
wire reset;
wire MISO;
wire MOSI;
wire MOSI_MOSI;
wire MISO_MOSI;
wire MISO_MISO;
wire SCK;
wire CS;
wire CKP;
wire CPH;

initial begin
  $dumpfile("testbench.vcd"); //Genera un archivo vcd 
  $dumpvars; //Se utilizan todas las variable
end


// Instanciar el módulo master
    generador_spi U0 (
        .clk(clk),
        .reset(reset),
        .MOSI(MOSI_MOSI),
        .SCK(SCK),
        .CS(CS),
        .MISO(MISO_MISO),
        .CKP(CKP),
        .CPH(CPH)
    );

// Instanciar el módulo objetivo 1

    receptor_spi U1 (
        .reset(reset),
        .MOSI(MOSI_MOSI),
        .SCK(SCK),
        .SS(CS),
        .MISO(MISO_MOSI),
        .CKP(CKP),
        .CPH(CPH)
        
    );
    
    // Instanciar el módulo objetivo 2

    	receptor_spi U2 (
        .reset(reset),
        .MOSI(MISO_MOSI),
        .SCK(SCK),
        .SS(CS),
        .MISO(MISO_MISO),
        .CKP(CKP),
        .CPH(CPH)
        
    );

// Instanciar el módulo ATMController
    tester P0 (
       .clk(clk),
        .reset(reset),
        .MOSI(MOSI),
        .SCK(SCK),
        .CS(CS),
        .MISO(MISO),
        .CKP(CKP),
        .CPH(CPH)
    );


endmodule
