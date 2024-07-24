module controller(
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
// Declaración de los inputs del módulo
input CLK, RESET, TARJETA_RECIBIDA, DIGITO_STB, TIPO_TRANS, MONTO_STB;
input [31:0] MONTO;
input [3:0] DIGITO;
input [15:0] PIN;

// Declaración de los outputs del módulo
output reg PIN_INCORRECTO;
output reg ADVERTENCIA;
output reg BLOQUEO;
output reg BALANCE_ACTUALIZADO;
output reg ENTREGAR_DINERO;
output reg FONDOS_INSUFICIENTES;



// Definición de estados
parameter ESTADO_INICIAL = 4'b0000;
parameter ESTADO_ESPERANDO_DIGITOS = 4'b0001;
parameter ESTADO_VERIFICACION = 4'b0010;
parameter ESTADO_AUTORIZADO = 4'b0011;
parameter ESTADO_DEPOSITO = 4'b0100;
parameter ESTADO_RETIRO = 4'b0101;
parameter ESTADO_BLOQUEO = 4'b0110;


// Declaración de registros internos
reg [63:0] BALANCE;
reg [63:0] MONTO_ext;
reg [63:0] balance_temp;
reg [3:0] estado_actual, proximo_estado;
reg [15:0] pin_interno;
reg [1:0] INTENTOS;
reg [2:0] contador_digitos;
reg [1:0] nxt_INTENTOS;
reg [2:0] nxt_contador_digitos;



// Lógica secuencial para actualizar el estado actual
always @(posedge CLK) begin
    if (!RESET) begin
        // Reiniciar valores del estado y contadores
        estado_actual <= ESTADO_INICIAL;
        pin_interno <= 16'b0000000000000000;
        INTENTOS <= 2'b00;
        contador_digitos <= 3'b000;
    end else begin
        // Actualizar estado y contadores
        estado_actual <= proximo_estado;
        contador_digitos <= nxt_contador_digitos;
        INTENTOS <= nxt_INTENTOS;
        if (DIGITO_STB) begin
            // Concatena los bits de DIGITO en pin_interno
            pin_interno <= {pin_interno[11:0], DIGITO};
            
        end
         
    end
end

// Lógica combinacional para determinar el próximo estado
always @(*) begin

    // Completando el comportamiento de cada FF para que se sostenga el estado o valor anterior
    proximo_estado = estado_actual;
    nxt_contador_digitos = contador_digitos;
    nxt_INTENTOS = INTENTOS;
    // Inicialización de las señales de interés
    PIN_INCORRECTO = 1'b0;
    ADVERTENCIA = 1'b0;
    BLOQUEO = 1'b0;
    BALANCE_ACTUALIZADO = 1'b0;
    FONDOS_INSUFICIENTES = 1'b0;
    ENTREGAR_DINERO = 1'b0;
    
    case(estado_actual)
        ESTADO_INICIAL: begin // Estado inicial que pasa al siguiente estado sólo si ha recibido una tarjeta
        nxt_INTENTOS = 0;
            MONTO_ext = 64'b0;
            if (TARJETA_RECIBIDA) begin
                proximo_estado = ESTADO_ESPERANDO_DIGITOS;
            end else begin
                proximo_estado = ESTADO_INICIAL;
            end
        end
        
        ESTADO_ESPERANDO_DIGITOS: begin
            if (DIGITO_STB) begin //Estado que espera 4 digitos ingresados con cada señal de digito
                nxt_contador_digitos = contador_digitos + 1;
            end else begin
                proximo_estado = ESTADO_ESPERANDO_DIGITOS;
            end
            if (contador_digitos == 4) begin // Se compara el pin solamente si se han ingresado 4 digitos
                nxt_INTENTOS = INTENTOS + 1; // Se incrementan los intentos cada 4 digitos ingresados
                nxt_contador_digitos = 3'b000;
                proximo_estado = ESTADO_VERIFICACION;
            end else begin
                proximo_estado = ESTADO_ESPERANDO_DIGITOS;
            end
        end

        ESTADO_VERIFICACION: begin
            if (PIN != pin_interno) begin // Si el pin no es correcto enciendo la señal de pin incorrecto
                PIN_INCORRECTO = 1'b1;
                if (INTENTOS == 2) begin //Si el pin es incorrecto y llevo dos intentos invalidos enciendo advertencia
                    ADVERTENCIA = 1;
                    proximo_estado = ESTADO_ESPERANDO_DIGITOS; // Volver al estado de espera de dígitos
                end else if (INTENTOS == 3) begin
                    proximo_estado = ESTADO_BLOQUEO; //Si el pin es incorrecto y llevo tres intentos invalidos paso a bloqueo
                end else begin
                    proximo_estado = ESTADO_ESPERANDO_DIGITOS; // Volver al estado de espera de dígitos
                end
            end else begin
                proximo_estado = ESTADO_AUTORIZADO; // Si mi pin es correcto paso a estado autorizado
            end
        end

        ESTADO_AUTORIZADO: begin // En estado autorizado obtengo un balance asociado a la tarjeta ingresada 
            BALANCE = 64'b0000000000000000000000000000000000000000000000000001001110001000;
            if (!TARJETA_RECIBIDA) begin 
            proximo_estado = ESTADO_INICIAL;
            end
            if (!TIPO_TRANS && MONTO_STB) begin // Si el tipo de transaccion está en bajo y tengo señal de Monto, paso al estado deposito
                proximo_estado = ESTADO_DEPOSITO;
            end
            if (TIPO_TRANS && MONTO_STB) begin // Si el tipo de transaccion está en alto y tengo señal de Monto, comparo MONTO con BALANCE
              MONTO_ext = {32'b0, MONTO}; // Convierto mi MONTO a 64 bits para poder comparar
              if (MONTO_ext <= BALANCE) begin // Solo retiro si mi MONTO < BALANCE
                proximo_estado = ESTADO_RETIRO;
            end
              else begin
                FONDOS_INSUFICIENTES = 1'b1; // Enciendo señal de fondos insuficientes si mi MONTO > BALANCE
                proximo_estado = ESTADO_AUTORIZADO;
            end
            end
        end
        
        
         ESTADO_DEPOSITO: begin
        // Se suma el monto al balance
        BALANCE = BALANCE + MONTO;
        // Marcar que el balance ha sido actualizado
        BALANCE_ACTUALIZADO = 1'b1;
        // Se cambia al estado inicial solo cuando MONTO_STB esté en bajo
        // Permanece en el mismo estado si tarjeta recibida está activa
        if (!TARJETA_RECIBIDA) proximo_estado = ESTADO_INICIAL;   
	end

      ESTADO_RETIRO: begin // Le resto a BALANCE el valor de MONTO y enciendo señales 
        BALANCE = BALANCE - MONTO_ext;
        ENTREGAR_DINERO = 1'b1;
        BALANCE_ACTUALIZADO = 1'b1;
        MONTO_ext = 64'b0;
        // Permanece en el mismo estado si TARJETA_RECIBIDA está activa
        if (!TARJETA_RECIBIDA) proximo_estado = ESTADO_INICIAL;
    end
    
        ESTADO_BLOQUEO: begin // Estado de bloqueo que enciende señal de bloqueo si se llega a tres intentos inválidos
            BLOQUEO = 1'b1;
            if (!RESET) begin // Sólo reseteando vuelvo al estado inicial
            proximo_estado = ESTADO_INICIAL;
            end
        end
        
        default:   proximo_estado = 4'b0000; // Si la máquina entrara en un estado inesperado, regrese al inicio.

    endcase
end

endmodule

