module generador_spi(
   // Outputs
    output reg MOSI,
    output reg CS,
    output SCK,
    // Inputs
    input wire MISO,
    input wire clk,
    input wire reset, 
    input wire CKP,
    input wire CPH
);
  
    // Declaración de registros internos y parámetros
    localparam DIV_FREQ = 2; // Para hacerlo al 25% de CLK
    reg [2:0] estado_actual, proximo_estado;
    reg [4:0] contador_bits_master, prox_contador_bits_master;
    reg [DIV_FREQ-1:0] div_freq;
    reg sck_reg;
    reg [15:0] current_data; // Registro de datos actuales a enviar
    reg [4:0] bit_index;
    reg last_data_sent; // Registro para rastrear el último dato enviado
    reg [3:0] trans_done; // Registro para indicar que se han enviado la data
    reg [15:0] sampled_data_MISO;
    
    // Definición de estados
    parameter IDLE = 3'b000;
    parameter VERIFICACION = 3'b001;
    parameter ENVIO_DATOS = 3'b010;
    parameter FINALIZACION_ENVIO = 3'b011;
    parameter INICIALIZACION = 3'b100;
    
    // Asignación para crear el reloj a una frecuencia menor
    assign SCK = sck_reg;

    // Lógica secuencial para generar SCK
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            // Reiniciar valores del estado y contadores
            current_data <= 16'b0000001100000100; // Inicializar con esta data
            div_freq <= 0;
            sck_reg <= CKP; // Configurar la polaridad del reloj
            last_data_sent <= 0;
            sampled_data_MISO <= 0;
            contador_bits_master <= 0;
        end else begin
            div_freq <= div_freq + 1;
            if (div_freq == (DIV_FREQ - 1)) begin
                sck_reg <= ~sck_reg; // Generar SCK al 25% de la frecuencia del clk
                div_freq <= 0;
            end
             // Mantener la polaridad del reloj cuando no hay transacción
            if (CS) begin
                sck_reg <= CKP; // Mantener el estado de reposo especificado por CKP
            end
        end
    end
    // Parámetro para el número de bits en la transacción SPI
    parameter NUM_BITS = 15;

    // Lógica secuencial para el envío de datos utilizando SCK (flanco positivo)
    always @(posedge SCK or negedge reset) begin
        if (!reset) begin
            estado_actual <= 0;
            MOSI <= 1'b0;
            //current_data <= 0; // Inicializar con data1
            CS <= 0;
            bit_index <= 0;
            trans_done <= 0;
            last_data_sent <= 0;
        end else begin
            estado_actual <= proximo_estado;
            contador_bits_master <= prox_contador_bits_master;
           
            if (estado_actual == 4) begin
                trans_done <= trans_done + 1;
            end
           
            sampled_data_MISO <= (sampled_data_MISO << 1) | MISO;
            if (estado_actual == 2 && contador_bits_master < NUM_BITS) begin
                // Envío de datos en el flanco positivo de SCK
                //sampled_data_MISO <= {sampled_data_MISO[6:0], MISO};
                if ((!CPH && !CKP) || (CPH && CKP)) begin
                    // MOSI toma el bit correspondiente de izquierda a derecha (MSB a LSB)
                    MOSI <= current_data[NUM_BITS - bit_index - 1];
                    bit_index <= bit_index + 1;
                    contador_bits_master <= contador_bits_master + 1;
                end

            end else begin
                // Finalizar la transacción cuando se hayan enviado todos los bits
                //MOSI <= 1'b0;
                bit_index <= 0;
                //CS <= 1;
                //contador_bits_master <= 0;
                last_data_sent = 0;
            
            end
        end
    end


    // Lógica secuencial para el envío de datos utilizando SCK (flanco negativo)
    always @(negedge SCK or negedge reset) begin
        if (!reset) begin
            estado_actual <= 0;
            contador_bits_master <= 0;
            MOSI <= 1'b0;
            //current_data <= 0; // Inicializar con data1
            bit_index <= 0;
        end else begin
            contador_bits_master <= prox_contador_bits_master;
        
            if (estado_actual == 2 && contador_bits_master < NUM_BITS) begin
                // Envío de datos en el flanco negativo de SCK
                if ((CPH && !CKP) || (!CPH && CKP)) begin
                    // MOSI toma el bit correspondiente de izquierda a derecha (MSB a LSB)
                    MOSI <= current_data[NUM_BITS - bit_index - 1];
                    bit_index <= bit_index + 1;
                    contador_bits_master <= contador_bits_master + 1;
                    //last_data_sent = 1;
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
        prox_contador_bits_master = contador_bits_master;

        // Definir el comportamiento basado en el estado actual
        case (estado_actual)
            IDLE: begin
                // Estado de reposo
                CS = 1;
                if (trans_done < 4) begin // Numero de trans se puede ir variando para la simulacion
                   proximo_estado = VERIFICACION;
                end    
            end

            VERIFICACION: begin // Verificamos si se activa el chip select para enviar data
            	CS = 0;
                if (!CS) proximo_estado = ENVIO_DATOS;

            end

            ENVIO_DATOS: begin
            // Estado de envío de data1 o data2
            if(trans_done == 4) CS <= 1;
            
            if (contador_bits_master <= 14) begin // Se envia bit a bit utilizando cada flanco respectivo
                proximo_estado = ENVIO_DATOS; // Continuar enviando bits
            end 
        
            else begin
                proximo_estado = FINALIZACION_ENVIO; // Finalizar la transacción
            end
            end

           FINALIZACION_ENVIO: begin
            // Estado de finalización de envío para corroborar que MOSI no siga enviando datos
            if ((!CPH && !CKP) || (CPH && CKP)) MOSI <= 0;
            
            //CS = 1;
            proximo_estado = INICIALIZACION; // Ir al estado de inicialización
       
            end
            INICIALIZACION: begin   // En este estado inicializamos y manejamos la señal de chip select para que no siga enviando datos
               	CS = 1;
                sampled_data_MISO <= 0;
                proximo_estado = IDLE;
                contador_bits_master <= 0;

            end 
            default: begin
                // Estado por defecto
                proximo_estado = IDLE;
            end
        endcase
    end


endmodule
