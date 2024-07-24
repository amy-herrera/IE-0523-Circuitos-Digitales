// Tester oficial para la sintetización tanto rtlil como la mapeada a la biblioteca

module tester(
clk,             // Entrada de reloj
reset,         // Entrada de reset
sensor_entrance, // Sensor de entrada
sensor_exit,     // Sensor de salida
input_password,  // Contraseña ingresada de 8 bits
gate_open,      // Salida de compuerta abierta
alarm_wrong_pin,// Salida de alarma de contraseña incorrecta
gate_close,     // Salida de compuerta de compuerta cerrada
alarm_block     
);

output clk, reset, sensor_entrance, sensor_exit; // Las salidas de este módulo son las entradas que le llegarán al controlador
output [7:0] input_password;
input gate_open, alarm_wrong_pin, gate_close, alarm_block;


wire gate_open, alarm_wrong_pin, gate_close, alarm_block; // Se establecen los cables
reg clk, reset, sensor_entrance, sensor_exit;
reg [7:0] input_password;

initial begin  // Inicializamos las señales de entrada en 0
    clk = 0;
    reset = 0;
    sensor_entrance = 0;
    sensor_exit = 0;
    #10 reset = 1;
    #20 reset = 0;

    //Prueba #1: Funcionamiento normal básico
    $display("Prueba #1: Funcionamiento normal básico");
    #20 sensor_entrance = 1; // Llegada de vehículo 
    #20 input_password = 8'b01001001; // Ingresa contraseña correcta
    $display("Esperando que la compuerta se abra...");
    #20 sensor_entrance = 0; // Sensor en bajo ya que está terminando de ingresar un vehículo
    #20 sensor_exit = 1; // Sensor de que ya el vehículo ingresó
    $display("Esperando que la compuerta se cierre...");
    #20 sensor_exit = 0;
   
    
    // Prueba #2: Ingreso de PIN incorrecto menos de 3 veces
    $display("Prueba #2: Ingreso de PIN incorrecto menos de 3 veces");
    #40 sensor_entrance = 1; // Llegada de vehículo
    $display("Esperando contraseña...");
    #20 input_password = 8'b10101010; // Ingreso de primer pin incorrecto
    $display("Esperando contraseña...");
    #20 input_password = 8'b11101100; // Ingreso de segundo pin incorrecto
    $display("Esperando contraseña...");
    #20 input_password = 8'b01001001; // Ingreso de pin correcto
    // Esperar a que la compuerta se abra 01001001
    $display("Esperando que la compuerta se abra...");
    #20 sensor_entrance = 0; // Sensor en bajo
    #20 sensor_exit =1;
    // Esperar a que la compuerta se cierre
    $display("Esperando que la compuerta se cierre...");
    #20 sensor_exit = 0;
   
    // Prueba #3: Ingreso de pin incorrecto 3 veces
    $display("Prueba #3: Ingreso de pin incorrecto 3 veces");
    #20 sensor_entrance = 1; // Llegada de vehículo
    #20 input_password = 8'b10101010; // Ingreso de primer pin incorrecto
    #20 input_password = 8'b11001100; // Ingreso de segundo pin incorrecto
    #20 input_password = 8'b11110000; // Ingreso de tercer pin incorrecto
    #30 input_password = 8'b01001001; // Ingresa contraseña correcta
    $display("Esperando que la compuerta se abra...");
    #20 sensor_entrance = 0; // Sensor en bajo ya que está terminando de ingresar un vehículo
    #20 sensor_exit = 1; // Sensor de que ya el vehículo ingresó
    $display("Esperando que la compuerta se cierre...");
    #20 sensor_exit = 0;
  
    //Prueba #4  
    $display("Prueba #4: alarma de bloqueo"); 
    #20 sensor_exit = 1;
    #20 sensor_entrance = 1; // Llegada de vehículo
    #20 input_password = 8'b10101010; // Ingreso de pin incorrecto PRUEBA PUEDE CAMBIARSE
    #20 input_password = 8'b11001100; // Ingreso de pin incorrecto
    #20 input_password = 8'b01001001; // Ingresa contraseña correcta
    $display("Esperando que la compuerta se abra...");
    #20 sensor_entrance = 0; // Sensor en bajo
    #20 sensor_exit = 1; // Sensor de que ya el vehículo ingresó
    $display("Esperando que la compuerta se cierre...");
    #20 sensor_exit = 0;
    #400 $finish; // Termina la simulación
end

always #10 clk = ~clk; // clk cada 5 unidades de tiempo
endmodule
