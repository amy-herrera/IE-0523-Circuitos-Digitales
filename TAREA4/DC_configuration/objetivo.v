module receptor_spi(
    // Inputs
    input wire SS,       // Chip Select
    input wire SCK,      // Serial Clock
    input wire MOSI,     // Master Output Slave Input
    input wire reset,    // Reset signal
    input wire CKP,      // Clock Polarity
    input wire CPH,      // Clock Phase
    // Outputs
    output reg MISO      // Master Input Slave Output
);
   
 // Declaración de registros internos y parámetros
    reg [2:0] estado_actual, proximo_estado;
    reg [4:0] contador_bits_obj, prox_contador_bits_obj;
    reg [15:0] current_data_obj = 16'b0000011100000011; // Inicializar con la data a enviar desde el periferico
    reg [4:0] bit_index;
    reg last_data_sent; // Registro para rastrear la data enviada
    reg [3:0] trans_done; // Registro para indicar que se han enviado 
    reg [15:0] sampled_data_MOSI;
    
    
     // Definición de estados
    parameter IDLE = 3'b000;
    parameter VERIFICACION = 3'b001;
    parameter ENVIO_DATOS = 3'b010;
    parameter FINALIZACION_ENVIO = 3'b011;
    parameter INICIALIZACION = 3'b100;
    // Parámetro para el número de bits en la transacción SPI
    parameter NUM_BITS = 15;

    // Lógica secuencial para el envío de datos utilizando SCK (flanco positivo)
    always @(posedge SCK or negedge reset) begin
        if (!reset) begin
            estado_actual <= 0;
            MISO <= 1'b0;
            sampled_data_MOSI <= 0;
            bit_index <= 0;
            trans_done <= 0;
            last_data_sent <= 0;
        end else begin
            estado_actual <= proximo_estado;
            contador_bits_obj <= prox_contador_bits_obj;
            sampled_data_MOSI <= (sampled_data_MOSI << 1) | MOSI;
            if (!SS && estado_actual == 2 && contador_bits_obj < NUM_BITS) begin 
                // Envío de datos en el flanco positivo de SCK
                //sampled_data_MISO <= {sampled_data_MISO[6:0], MISO};
                if ((!CPH && !CKP) || (CPH && CKP)) begin
                    // MOSI toma el bit correspondiente de izquierda a derecha (MSB a LSB)
                    MISO <= current_data_obj[NUM_BITS - bit_index - 1];
                    bit_index <= bit_index + 1;
                    contador_bits_obj <= contador_bits_obj + 1;
                    //last_data_sent = 1;
                end

            end else begin
                // Finalizar la transacción cuando se hayan enviado todos los bits
                bit_index <= 0;
                //contador_bits_master <= 0;
                last_data_sent = 0;
            
            end
        end
    end

    // Lógica secuencial para el envío de datos utilizando SCK (flanco negativo)
    always @(negedge SCK or negedge reset) begin
        if (!reset) begin
            estado_actual <= 0;
            contador_bits_obj <= 0;
            bit_index <= 0;
        end else begin
            contador_bits_obj <= prox_contador_bits_obj;
            //CS <= 0;

            if (estado_actual == 2 && contador_bits_obj < NUM_BITS) begin
                // Envío de datos en el flanco positivo de SCK
                if ((CPH && !CKP) || (!CPH && CKP)) begin
                    // MOSI toma el bit correspondiente de izquierda a derecha (MSB a LSB)
                    MISO <= current_data_obj[NUM_BITS - bit_index - 1];
                    bit_index <= bit_index + 1;
                    contador_bits_obj <= contador_bits_obj + 1;
                    //last_data_sent = 1;
                    if (estado_actual == 3) MISO <= 0;
                end
            end else begin
                // Finalizar la transacción cuando se hayan enviado todos los bits
                //MOSI <= 1'b0;
                bit_index <= 0;
                //contador_bits_master <= 0;
                //CS <= 1;
            end
        end
    end

   // Lógica combinacional
    always @(*) begin
        // Mantener el valor actual por defecto
        proximo_estado = estado_actual;
        prox_contador_bits_obj = contador_bits_obj;

        // Definir el comportamiento basado en el estado actual
        case (estado_actual)
            IDLE: begin
               
                if (trans_done < 4) begin // Numero de trans se puede ir variando para la simulacion
                   proximo_estado = VERIFICACION;
                end
            end
             VERIFICACION: begin
                if (!SS) proximo_estado = ENVIO_DATOS; // Utiliza la señal de entrada desde el master como condición para poder enviar datos

            end

            ENVIO_DATOS: begin
            // Estado de envío de data
            
            if (contador_bits_obj <= 14) begin
                proximo_estado = ENVIO_DATOS; // Continuar enviando bits
            end 
        
            else begin
                proximo_estado = FINALIZACION_ENVIO; // Se deja de enviar data cuando se manden los bits respectivos
            end
            end

           FINALIZACION_ENVIO: begin
            // Estado de finalización de envío
            if ((!CPH && !CKP) || (CPH && CKP)) MISO <= 0;
            //if ((CPH && !CKP) || (!CPH && CKP)) MISO <= 0;

            proximo_estado = INICIALIZACION; // Ir al estado de inicialización
            
            end
            INICIALIZACION: begin   // Estado de inicialización para corrobar el valor de la señal y reestablecer las variables auxiliares
                MISO <= 0;
                //CS <= 1;
                sampled_data_MOSI <= 0;
                proximo_estado = IDLE;
                contador_bits_obj <= 0;
            end 
            default: begin
                // Estado por defecto
                proximo_estado = IDLE;
            end
        endcase
    end

endmodule
