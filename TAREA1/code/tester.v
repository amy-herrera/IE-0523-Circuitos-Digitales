module tester(
clk,             // Entrada de reloj
reset_n,         // Entrada de reset
sensor_entrance, // Sensor de entrada
sensor_exit,     // Sensor de salida
input_password,  // Contraseña ingresada de 8 bits
gate_open,      // Salida de compuerta abierta
alarm_wrong_pin,// Salida de alarma de contraseña incorrecta
gate_close,     // Salida de compuerta de compuerta cerrada
alarm_block     
);

output clk, reset_n, sensor_entrance, sensor_exit; // Las salidas de este módulo son las entradas que le llegarán al controlador
output [7:0] input_password;
input gate_open, alarm_wrong_pin, gate_close, alarm_block;


wire gate_open, alarm_wrong_pin, gate_close, alarm_block; // Se establecen los cables
reg clk, reset_n, sensor_entrance, sensor_exit;
reg [7:0] input_password;

initial begin  // Inicializamos las señales de entrada en 0
    clk = 0;
    reset_n = 0;
    sensor_entrance = 0;
    sensor_exit = 0;
    #10 reset_n = 1;

    //Prueba #1: Funcionamiento normal básico
    $display("Prueba #1: Funcionamiento normal básico");
    #5 sensor_entrance = 1; // Llegada de vehículo
    #5 input_password = 8'b01001001; // Ingresa contraseña correcta: 01001001
    //#10; // Retardo de 100 unidades de tiempo
    $display("Esperando que la compuerta se abra...");
    #5 sensor_entrance = 0; // Sensor en bajo ya que está terminando de ingresar un vehículo
    #5 sensor_exit = 1; // Sensor de que ya el vehículo ingresó
    $display("Esperando que la compuerta se cierre...");
    #5 sensor_exit = 0;
    #10; //Delay
    
    // Prueba #2: Ingreso de PIN incorrecto menos de 3 veces
    $display("Prueba #2: Ingreso de PIN incorrecto menos de 3 veces");
    #5 sensor_entrance = 1; // Llegada de vehículo
    $display("Esperando contraseña...");
    #5 input_password = 8'b10101010; // Ingreso de primer pin incorrecto
    #5;
    $display("Esperando contraseña...");
    #5 input_password = 8'b11101100; // Ingreso de segundo pin incorrecto
    $display("Esperando contraseña...");
    #5;
    #5 input_password = 8'b01001001; // Ingreso de pin correcto a la tercera vez
    // Esperar a que la compuerta se abra 01001001
    $display("Esperando que la compuerta se abra...");
    #5 sensor_entrance = 0; // Sensor en bajo ya que está terminando de ingresar un vehículo
    #5 sensor_exit =1;
    // Esperar a que la compuerta se cierre
    $display("Esperando que la compuerta se cierre...");
    #5 sensor_exit = 0;
   
    // Prueba #3: Ingreso de pin incorrecto 3 veces
    $display("Prueba #3: Ingreso de pin incorrecto 3 veces");
    #5 sensor_entrance = 1; // Llegada de vehículo
    #5 input_password = 8'b10101010; // Ingreso de primer pin incorrecto (revisar alarma de pin incorrecto)
    #5;
    #5 input_password = 8'b11001100; // Ingreso de segundo pin incorrecto
    #5;
    #5 input_password = 8'b11110000; // Ingreso de tercer pin incorrecto
    #5;
    #5 input_password = 8'b01001001; // Ingresa contraseña correcta: 01001001
    $display("Esperando que la compuerta se abra...");
    #5 sensor_entrance = 0; // Sensor en bajo ya que está terminando de ingresar un vehículo
    #5 sensor_exit = 1; // Sensor de que ya el vehículo ingresó
    $display("Esperando que la compuerta se cierre...");
    #5 sensor_exit = 0;
    
    //Prueba #4  
    $display("Prueba #4: alarma de bloqueo"); 
    #5 sensor_entrance = 1; // Llegada de vehículo
    #5 sensor_exit = 1; // Sensor que ya el vehículo entró (ambos sensores activados al mismo tiempo)
    #5 input_password = 8'b10101010; // Ingreso de pin incorrecto (alarma de bloqueo debe seguir en alto)
    #5;
    #5 input_password = 8'b11001100; // Ingreso de pin incorrecto (sigue en alto alarma de bloqueo)
    #5;
    #5 input_password = 8'b01001001; // Ingresa contraseña correcta: 10010010
    #5;
    $display("Esperando que la compuerta se abra...");
    #5 sensor_entrance = 0; // Sensor en bajo ya que está terminando de ingresar un vehículo
    #5 sensor_exit = 1; // Sensor de que ya el vehículo ingresó
    $display("Esperando que la compuerta se cierre...");
    #5 sensor_exit = 0;
    #400 $finish; // Termina la simulación
end

always #5 clk = ~clk; // clk cada 5 unidades de tiempo
endmodule
