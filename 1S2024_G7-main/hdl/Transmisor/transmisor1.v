module transmisor_1 (
    input wire GTX_CLK,
    input wire RESET,
    input wire TX_EN,
    input wire [7:0] tx_octet,
    input wire TX_OSET_indicate,
    input wire tx_even,
    output reg [7:0] tx_o_set
);

    // Definición de estados
    parameter IDLE = 4'b0000; // estado 0
    parameter XMIT_DATA = 4'b0001; //estado 1
    parameter START_OF_PACKET = 4'b0010; // estado 2
    parameter TX_PACKET = 4'b0011; // estado 3
    parameter TX_DATA = 4'b0100; // estado 4
    parameter END_OF_PACKET_NOEXT = 4'b0101; // estado 5
    parameter EPD2_NOEXT = 4'b0110; // estado 6
    

    // Regs internos
    reg [7:0] tx_comma;
    reg total_disparity;
    reg [5:0] first_six_bits;
    reg [3:0] last_four_bits;
    reg [2:0] comma_counter, next_comma_counter;
    reg transmitting;
    reg TRUE = 1;
    reg FALSE = 0;
   
    reg [3:0] current_state, next_state;

  

    // State transition logic
    always @(posedge GTX_CLK) begin
        if (!RESET) begin
            current_state <= IDLE;
            comma_counter <= 0;
            transmitting <= 0;
            
        end else begin
            current_state <= next_state;
            comma_counter <= next_comma_counter;
        end
    end

    // Next state logic and output generation
    always @(*) begin
        
        next_state = current_state;
        next_comma_counter = comma_counter;
        
        case (current_state)
        
            IDLE: begin //0
                tx_comma = 8'hBC;
            	next_comma_counter = comma_counter + 1; 
            	tx_o_set = tx_comma;
                next_state = XMIT_DATA;
                
            end
        
            XMIT_DATA: begin //1
            	next_comma_counter = comma_counter + 1;
                 if (comma_counter == 5 && TX_EN && TX_OSET_indicate) begin
                   next_comma_counter = 0;  
            	   next_state = START_OF_PACKET;
            	end else begin
            	next_state = IDLE;
            	end  
            	
            end

            START_OF_PACKET: begin //2
         	    tx_o_set = tx_octet;
                transmitting = TRUE;
                if(TX_OSET_indicate) next_state = TX_PACKET;
            end

            TX_PACKET: begin //3
               if (TX_EN) begin
                    tx_o_set = tx_octet;
                    if (TX_OSET_indicate) next_state = TX_DATA;
                end
                else begin
                    next_state = END_OF_PACKET_NOEXT;
                end
           
            end
            TX_DATA: begin //4
                if (TX_OSET_indicate) next_state = TX_PACKET;
                
            end

            END_OF_PACKET_NOEXT: begin //5
            if(!tx_even) transmitting = FALSE;
            
            if (tx_octet == 8'hFD) begin
                tx_o_set = tx_octet;
            end
            if (TX_OSET_indicate) next_state = EPD2_NOEXT;
         
            end
            EPD2_NOEXT: begin //6
            transmitting = FALSE;
             if (tx_octet == 8'hF7) begin
                tx_o_set = tx_octet;
            end
            if (TX_OSET_indicate) next_state = IDLE;
          
            end

        endcase
    end

endmodule
