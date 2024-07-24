`include "generador.v"
`include "tester.v"
`include "objetivo.v"

module generador_tb;
wire clk;
wire reset;
wire MOSI;
wire SCK;
wire CS;
wire MISO;
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
        .MOSI(MOSI),
        .SCK(SCK),
        .CS(CS),
        .MISO(MISO),
        .CKP(CKP),
        .CPH(CPH)
    );

// Instanciar el módulo objetivo 

    receptor_spi U1 (
        .reset(reset),
        .MOSI(MOSI),
        .SCK(SCK),
        .SS(CS),
        .MISO(MISO),
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
