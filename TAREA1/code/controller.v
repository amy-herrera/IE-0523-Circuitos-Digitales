module controller( 
 clk,                    // Se establecen las señales del módulo
 reset_n,
 sensor_entrance, 
 sensor_exit, 
 input_password,
 gate_open,
 gate_close,
 alarm_wrong_pin,
 alarm_block
    );
 
 parameter IDLE = 3'b000, WAIT_PASSWORD = 3'b001, RIGHT_PASS = 3'b010,LOCKED = 3'b011; // Se establecen como parametros los estados de la máquina de estados
 // Máquina de estados Moore : la salida depende del estado actual
 
 input clk, reset_n, sensor_entrance, sensor_exit; // Se indican las entradas del módulo
 input [7:0] input_password;
 output gate_open, alarm_wrong_pin, gate_close, alarm_block; // Se indican las salidas del módulo

 wire gate_open, alarm_wrong_pin, gate_close, alarm_block; // Se establecen los cables para las señales
 wire clk, reset_n, sensor_entrance, sensor_exit, input_password;
 
 reg[2:0] current_state, next_state; // Las variables internas del módulo son manejadas como reg
 reg [2:0] counter;

 parameter CORRECT_PASSWORD = 8'b01001001; // Parámetro de la contraseña correcta para ser comparada internamente
 parameter MAX_ATTEMPTS = 3; // Valor máximo de intentos de ingreso de pin

 // Bloque de always para los flipflops que manejan las transiciones de los estados
 always @(posedge clk or negedge reset_n)
 begin
 if(!reset_n) 
 current_state = IDLE;
 else
 current_state = next_state;
 end
 // Bloque de always que maneja el contador según los pines ingresdos para reiniciarlo o acumular el número de intentos
always @(posedge clk or negedge !reset_n) begin
    if (!reset_n) begin
        counter <= 0;  // Reset del contador con la señal de reset
    end
    else begin
        if (input_password != CORRECT_PASSWORD) begin   // Se incrementa el contador si la contraseña no es correcta
            counter <= counter + 1;
            $display("counter = %d", counter);
        end
        else if (counter == MAX_ATTEMPTS || current_state == RIGHT_PASS) begin // Reset del contador si llego al máximo de intentos o si ya logré abrir la puerta
            counter <= 0;
            $display("counter = %d", counter); // Se hace un display en consola del valor del contador
        end
    end
end

 // Bloque de always para la lógica combinacional
 always @(*)
begin
    case(current_state)  // Abrimos un case para transicionar los estados según condiciones respectivas
        IDLE: begin    // Se implementa el estado IDLE
            if (sensor_entrance && !sensor_exit)
                next_state = WAIT_PASSWORD;
            else if (sensor_entrance && sensor_exit)
                next_state = LOCKED;
            else
                next_state = IDLE;
        end
        
        WAIT_PASSWORD: begin // Se implementa el estado WAIT_PASSWORD
            if (input_password == CORRECT_PASSWORD)
                next_state = RIGHT_PASS;
            else if (sensor_entrance && sensor_exit)
                next_state = LOCKED;
            else
                next_state = WAIT_PASSWORD;
        end
        
        //WRONG_PASS: begin 
            //if (counter < MAX_ATTEMPTS) begin
                //counter = counter + 1;
                //$display("counter = %d", counter);
                //next_state = WAIT_PASSWORD;  
            //end
            //else if (counter >= MAX_ATTEMPTS) begin
                //next_state = ALARM_PIN;
            //end
        //end
        
        RIGHT_PASS: begin    // Se implementa el estado RIGHT_PASS
            if(sensor_entrance && sensor_exit)
                next_state = LOCKED;
            else if(sensor_entrance && !sensor_exit)
                next_state = RIGHT_PASS;
            else if(!sensor_entrance && sensor_exit)
                next_state = IDLE;
        end
        
        LOCKED: begin   // Se implementa el estado LOCKED
            if(input_password == CORRECT_PASSWORD)
                next_state = RIGHT_PASS;
            else if(sensor_entrance && sensor_exit)
            	next_state = LOCKED;
            else
                next_state = WAIT_PASSWORD;
        end
        
        //ALARM_PIN: begin
            //if(sensor_entrance)
                //next_state = WAIT_PASSWORD;
        //end
        
        default: next_state = IDLE;
    endcase
end

 // Se realiza la asignación de activación de las salidas, ya que al ser wires no pueden tener asignaciones bloqueantes 
 assign gate_open = (current_state == RIGHT_PASS && input_password == CORRECT_PASSWORD); // Condiciones para abrir puerta
 assign gate_close = (current_state == LOCKED || current_state == IDLE || current_state == WAIT_PASSWORD); // Condiciones para cerra puerta
 assign alarm_wrong_pin = (counter >= MAX_ATTEMPTS); // Condiciones para activar alarma de pines incorrectos
 assign alarm_block = (current_state == LOCKED || current_state == WAIT_PASSWORD && sensor_entrance && sensor_exit); // Condiciones para activar la alarma de bloqueo
 
endmodule
