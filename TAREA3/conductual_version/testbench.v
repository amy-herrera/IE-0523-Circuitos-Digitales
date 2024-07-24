`include "tester.v"
`include "cajero.v"



module controller_tb;
wire CLK;
wire RESET;
wire TARJETA_RECIBIDA;
wire [15:0] PIN;
wire [3:0] DIGITO;
wire DIGITO_STB;
wire PIN_INCORRECTO;
wire TIPO_TRANS;
wire [31:0] MONTO;
wire MONTO_STB;
wire BALANCE_ACTUALIZADO;
wire ENTREGAR_DINERO;
wire FONDOS_INSUFICIENTES;
wire ADVERTENCIA;
wire BLOQUEO;

initial begin
  $dumpfile("testbench.vcd"); //Genera un archivo vcd 
  $dumpvars; //Se utilizan todas las variable
end

// Instanciar el módulo ATMController
    controller U0 (
        .CLK(CLK),
        .RESET(RESET),
        .TARJETA_RECIBIDA(TARJETA_RECIBIDA),
        .PIN(PIN),
        .DIGITO(DIGITO),
        .DIGITO_STB(DIGITO_STB),
        .PIN_INCORRECTO(PIN_INCORRECTO),
        .TIPO_TRANS(TIPO_TRANS),
        .MONTO(MONTO),
        .MONTO_STB(MONTO_STB),
        .BALANCE_ACTUALIZADO(BALANCE_ACTUALIZADO),
        .ENTREGAR_DINERO(ENTREGAR_DINERO),
        .FONDOS_INSUFICIENTES(FONDOS_INSUFICIENTES),
        .ADVERTENCIA(ADVERTENCIA),
        .BLOQUEO(BLOQUEO)
    );


// Instanciar el módulo ATMController
    tester P0 (
        .CLK(CLK),
        .RESET(RESET),
        .TARJETA_RECIBIDA(TARJETA_RECIBIDA),
        .PIN(PIN),
        .DIGITO(DIGITO),
        .DIGITO_STB(DIGITO_STB),
        .PIN_INCORRECTO(PIN_INCORRECTO),
        .TIPO_TRANS(TIPO_TRANS),
        .MONTO(MONTO),
        .MONTO_STB(MONTO_STB),
        .BALANCE_ACTUALIZADO(BALANCE_ACTUALIZADO),
        .ENTREGAR_DINERO(ENTREGAR_DINERO),
        .FONDOS_INSUFICIENTES(FONDOS_INSUFICIENTES),
        .ADVERTENCIA(ADVERTENCIA),
        .BLOQUEO(BLOQUEO)
    );


endmodule
