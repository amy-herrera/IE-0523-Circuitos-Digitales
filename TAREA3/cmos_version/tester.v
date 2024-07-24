module tester ( 
	    CLK,
    	RESET,
    	TARJETA_RECIBIDA,
    	PIN,
    	DIGITO,
    	DIGITO_STB,
    	PIN_INCORRECTO,
        ADVERTENCIA,
        BLOQUEO, 
        TIPO_TRANS,
        MONTO,
        BALANCE_ACTUALIZADO,
        MONTO_STB,
        ENTREGAR_DINERO,
        FONDOS_INSUFICIENTES
);


output CLK, RESET, TARJETA_RECIBIDA, DIGITO_STB, TIPO_TRANS, MONTO_STB;
output [31:0] MONTO; // Las salidas de este módulo son las entradas que le llegarán al controlador
output [3:0] DIGITO;
output [15:0] PIN;

input PIN_INCORRECTO;
input ADVERTENCIA;
input BLOQUEO;
input BALANCE_ACTUALIZADO;
input ENTREGAR_DINERO;
input FONDOS_INSUFICIENTES;


reg CLK, RESET, TARJETA_RECIBIDA, DIGITO_STB, TIPO_TRANS, MONTO_STB; // Las salidas de este módulo son las entradas que le llegarán al controlador
reg [3:0] DIGITO;
reg [15:0] PIN;
reg [31:0] MONTO;
 
wire PIN_INCORRECTO;
wire ADVERTENCIA;
wire BLOQUEO;
wire BALANCE_ACTUALIZADO;
wire FONDOS_INSUFICIENTES;
wire ENTREGAR_DINERO;


// Secuencia de pruebas 
initial begin
    // Inicialización
   	CLK = 0;
        RESET = 0;
        TARJETA_RECIBIDA = 0;
        TIPO_TRANS = 0;
        DIGITO_STB = 0;
        MONTO_STB = 0;
	
	#20 RESET = 1;
        
        // Prueba 1: Introducir 3 pines incorrectos y bloqueo
        #5 TARJETA_RECIBIDA = 1;
        #10 PIN = 16'b0011010001110011; // Del carné B53473 PRUEBA
        #20 DIGITO_STB = 1; DIGITO = 4'b0001;  #10 DIGITO_STB = 0; //Ingreso de un DIGITO cada ciclo de reloj
        #10 DIGITO_STB = 1; DIGITO = 4'b0011;  #10 DIGITO_STB = 0;
        #10 DIGITO_STB = 1; DIGITO = 4'b0111;  #10 DIGITO_STB = 0;
        #10 DIGITO_STB = 1; DIGITO = 4'b1000;  #10 DIGITO_STB = 0;
     
        //#10 TARJETA_RECIBIDA = 0;
        //#10 TARJETA_RECIBIDA = 1;
        #20 DIGITO_STB = 1; DIGITO = 4'b0001;  #10 DIGITO_STB = 0; //Ingreso de un DIGITO cada ciclo de reloj
        #10 DIGITO_STB = 1; DIGITO = 4'b0011;  #10 DIGITO_STB = 0;
        #10 DIGITO_STB = 1; DIGITO = 4'b0111;  #10 DIGITO_STB = 0;
        #10 DIGITO_STB = 1; DIGITO = 4'b1000;  #10 DIGITO_STB = 0;

        //#10 TARJETA_RECIBIDA = 0;
        //#10 TARJETA_RECIBIDA = 1;
        #20 DIGITO_STB = 1; DIGITO = 4'b0001;  #10 DIGITO_STB = 0; //Ingreso de un DIGITO cada ciclo de reloj
        #10 DIGITO_STB = 1; DIGITO = 4'b0011;  #10 DIGITO_STB = 0;
        #10 DIGITO_STB = 1; DIGITO = 4'b0111;  #10 DIGITO_STB = 0;
        #10 DIGITO_STB = 1; DIGITO = 4'b1000;  #10 DIGITO_STB = 0;
        #10 TARJETA_RECIBIDA = 0;
        #10 DIGITO = 0;
        #20 RESET = 0;
        #10 RESET = 1;
        
        // Prueba #2: Pin correcto y deposito
        #10 TARJETA_RECIBIDA = 1;
        #20 DIGITO = 4'b0011; DIGITO_STB = 1; #10 DIGITO_STB = 0; //Ingreso de un DIGITO cada ciclo de reloj
        #10 DIGITO = 4'b0100; DIGITO_STB = 1; #10 DIGITO_STB = 0;
        #10 DIGITO = 4'b0111; DIGITO_STB = 1; #10 DIGITO_STB = 0;
        #10 DIGITO = 4'b0011; DIGITO_STB = 1; #10 DIGITO_STB = 0;
        #20 TIPO_TRANS = 0; MONTO = 32'b00000000000000000000011111010000; MONTO_STB = 1; //Ingreso del tipo de trans, el Monto y la señal de Monto
        #10 MONTO_STB = 0; MONTO = 32'b0; // Señal de Monto en 1 solamente por un ciclo de reloj
        #10 TARJETA_RECIBIDA = 0;
        #10 DIGITO = 0;
        
        // Prueba #3: Dos pines incorrectos, pin correcto y retiro exitoso
        #10 TARJETA_RECIBIDA = 1;
        #20 DIGITO_STB = 1; DIGITO = 4'b0001;  #10 DIGITO_STB = 0; //Ingreso de un DIGITO cada ciclo de reloj
        #10 DIGITO_STB = 1; DIGITO = 4'b0011;  #10 DIGITO_STB = 0;
        #10 DIGITO_STB = 1; DIGITO = 4'b0111;  #10 DIGITO_STB = 0;
        #10 DIGITO_STB = 1; DIGITO = 4'b1000;  #10 DIGITO_STB = 0;
        //#10 TARJETA_RECIBIDA = 0;
        //#10 TARJETA_RECIBIDA = 1;
        
        #20 DIGITO_STB = 1; DIGITO = 4'b0001;  #10 DIGITO_STB = 0; //Ingreso de un DIGITO cada ciclo de reloj
        #10 DIGITO_STB = 1; DIGITO = 4'b0011;  #10 DIGITO_STB = 0;
        #10 DIGITO_STB = 1; DIGITO = 4'b0111;  #10 DIGITO_STB = 0;
        #10 DIGITO_STB = 1; DIGITO = 4'b1000;  #10 DIGITO_STB = 0;
      
        //#10 TARJETA_RECIBIDA = 0;
        //#10 TARJETA_RECIBIDA = 1;
        #20 DIGITO = 4'b0011; DIGITO_STB = 1; #10 DIGITO_STB = 0; //Ingreso de un DIGITO cada ciclo de reloj
        #10 DIGITO = 4'b0100; DIGITO_STB = 1; #10 DIGITO_STB = 0;
        #10 DIGITO = 4'b0111; DIGITO_STB = 1; #10 DIGITO_STB = 0;
        #10 DIGITO = 4'b0011; DIGITO_STB = 1; #10 DIGITO_STB = 0;
        #10 TIPO_TRANS = 1; //Ingreso del tipo de trans, el Monto y la señal de Monto
        #10 MONTO = 32'b00000000000000000000011111010000; MONTO_STB = 1; 
        #10 MONTO_STB = 0; TARJETA_RECIBIDA = 0; // Señal de Monto en 1 solamente por un ciclo de reloj
        #10 DIGITO = 0;
      
        // Prueba #4: Pin correcto y fondos insuficientes
        #10 TARJETA_RECIBIDA = 1;
        #20 DIGITO = 4'b0011; DIGITO_STB = 1; #10 DIGITO_STB = 0; //Ingreso de un DIGITO cada ciclo de reloj
        #10 DIGITO = 4'b0100; DIGITO_STB = 1; #10 DIGITO_STB = 0;
        #10 DIGITO = 4'b0111; DIGITO_STB = 1; #10 DIGITO_STB = 0;
        #10 DIGITO = 4'b0011; DIGITO_STB = 1; #10 DIGITO_STB = 0;
        #10; //Delay de prueba
        #10 TIPO_TRANS = 1; MONTO = 32'b00000000000000000010011100010000; MONTO_STB = 1; //Ingreso del tipo de trans, el Monto y la señal de Monto
        #10 TARJETA_RECIBIDA = 0; MONTO_STB = 0; // Señal de Monto en 1 solamente por un ciclo de reloj
        #10 DIGITO = 0;
        #500 $finish;
end

always begin
 #5 CLK = !CLK;
end
endmodule

