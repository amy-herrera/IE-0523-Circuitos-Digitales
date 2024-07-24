module controller( 
 clk,                    // Se establecen las señales del módulo
 reset,
 sensor_entrance, 
 sensor_exit, 
 input_password,
 gate_open,
 gate_close,
 alarm_wrong_pin,
 alarm_block
    );


input clk, reset, sensor_entrance, sensor_exit; // Se indican las entradas del módulo
input [7:0] input_password;
output reg gate_open, alarm_wrong_pin, gate_close, alarm_block; // Se indican las salidas del módulo

reg [2:0] current_state;
reg [2:0] count0;

reg [2:0] nxt_state;
reg [2:0] nxt_count0;           

parameter CORRECT_PASSWORD = 8'b01001001; // Parámetro de la contraseña correcta para ser comparada internamente
parameter MAX_ATTEMPTS = 3; // Valor máximo de intentos de ingreso de pin
//Ambas variables almacenadas en registros hechos con FF de flanco positivo.
// Un FF por bit de cada variable.
           
always @(posedge clk) begin
  if (reset) begin
    current_state  <= 3'b000;
    count0 <= 3'b000; 
  end else begin
    current_state  <= nxt_state;
    count0 <= nxt_count0;
  end
end  //Fin de los flip flops

always @(*) begin

// Valores por defecto

  nxt_state = current_state;   //Para completar el comportamiento del FF se necesita
                       //que por defecto el nxt_state sostenga el valor del estado
                       //anterior
  nxt_count0 = count0; // Igual al caso de state y nxt_state, para garantizar el 
                       // comportamiento del FF. 
   
  gate_open = 1'b0; 
  gate_close = 1'b0; 
  alarm_block = 1'b0; 
  alarm_wrong_pin = 1'b0; 
  
// Comportamiento de la máquina de estados
// Define las transiciones de próximo estado según el diagrama ASM
// visto en clase y el comportamiento de "valid" y "count0" en el 
// último estado, según la especificación.

  case(current_state)
    3'b000: begin
    		gate_close = 1'b1;
    		if (sensor_entrance) nxt_state = 3'b001;
		if (sensor_exit && sensor_entrance) nxt_state = 3'b011;
		//nxt_state = 3'b000;
	    end
   
    3'b001: begin
        	gate_close = 1'b1;
        	//if (sensor_exit && sensor_entrance) nxt_state = 3'b011; 
        	if (input_password == CORRECT_PASSWORD) begin
            		nxt_state = 3'b010;
        	end
        	else if (input_password != CORRECT_PASSWORD && nxt_count0 < MAX_ATTEMPTS) begin
            		nxt_count0 = count0 + 1;
            		nxt_state = 3'b001;
        	end
        	else if (input_password != CORRECT_PASSWORD && nxt_count0 >= MAX_ATTEMPTS) begin
            		alarm_wrong_pin = 1'b1;
            		nxt_count0 = 3'b000;
            		nxt_state = 3'b001;
            		end
            	//nxt_state = 3'b001;
            		
    end                                       
    3'b010: begin 
    		gate_open = 1'b1;
    		nxt_count0 = 3'b000;
    		// nxt_state = 3'b000;
    	      	if (sensor_exit) nxt_state = 3'b000; //HACER PRUEBA AHORITA
    	    end
    
    3'b011: begin
    gate_close = 1'b1;
    alarm_block = 1'b1;
    
    if (input_password != CORRECT_PASSWORD && nxt_count0 < MAX_ATTEMPTS) begin
        nxt_count0 = count0 + 1;
        nxt_state = 3'b011;
    end
    else if (input_password == CORRECT_PASSWORD) begin
        nxt_state = 3'b010;
    end
end

               
    
    default:   nxt_state = 3'b000; // Si la máquina entrara en un estado inesperado, regrese al inicio.
  endcase

end // Este end corresponde al always @(*) de la lógica combinacional

endmodule
