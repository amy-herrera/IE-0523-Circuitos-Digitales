module tester( 
//inputs
MOSI,
SCK,
CS,
//outputs
MISO,
clk,
reset, 
CKP,
CPH
);


output clk, reset, CKP, CPH; // Las salidas de este módulo son las entradas que le llegarán al generador
output MISO;
input MOSI;
input SCK;
input CS;


reg clk, reset, CKP, CPH; // Las salidas de este módulo son las entradas que le llegarán al generador

wire MISO;
wire MOSI;
wire SCK;
wire CS;

// Secuencia de pruebas 
initial begin
    // Inicialización
   	clk = 0;
   	CKP = 0;
    CPH = 0;
    reset = 0;
	#40 reset = 1;
    // Initialize inputs
        
    // Test mode 0 (CPOL=0, CPHA=0)
    CKP = 0;
    CPH = 0;
    
    #725; // Wait for 8 clock cycles (80 time units at clk period of 10)
    
    // Test mode 0 (CPOL=0, CPHA=0)
    
    CKP = 0;
    CPH = 1;
    
    #640; // Wait for 8 clock cycles (80 time units at clk period of 10)

    // Test mode 0 (CPOL=0, CPHA=0)
    CKP = 1;
    CPH = 0;
    #700; // Wait for 8 clock cycles
    
    // Test mode 0 (CPOL=0, CPHA=0)
    CKP = 1;
    CPH = 1;
    
    #2000; // Wait for 8 clock cycles
    $finish;
end

always begin
 #5 clk = !clk;
end
endmodule

