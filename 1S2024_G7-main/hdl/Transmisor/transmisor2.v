module transmisor_2 (
    input wire GTX_CLK,
    input wire RESET,
    input wire TX_EN,
    input wire [7:0] tx_o_set,
    output reg [9:0] tx_code_group,
    output reg TX_OSET_indicate,
    output reg tx_even,
    output PUDI
);

    // Definición de estados
    parameter GENERATE_CODE_GROUPS = 4'b0000; //estado 0
    //parameter IDLE_DISPARITY_WRONG = 4'b0001; // estado 1
    parameter IDLE_I1B = 4'b0001; // estado 1
    //parameter IDLE_DISPARITY_OK = 4'b0011; // estado 3
    parameter IDLE_I2B = 4'b0010; // estado 2

    // Calculate disparity and update next state
    integer ones_six;
    integer zeros_six;
    integer i;
    integer ones_four;
    integer zeros_four;
    integer j;
    reg initial_disparity_six;
    reg final_disparity_six;

    reg initial_disparity_four;
    reg final_disparity_four;
    reg TRUE = 1;
    reg FALSE = 0;

    assign PUDI = 1;


    reg total_disparity;
    reg [5:0] first_six_bits;
    reg [3:0] last_four_bits;
   
    reg [3:0] current_state, next_state;

    // Lookup table
    reg [9:0] lookup_table [0:255][1:0];

    // Initialize the lookup table
    initial begin
        // Fill in the lookup table based on provided data
        // Format: lookup_table[Octet Value][0 for RD-, 1 for RD+]
        // K-Codes
        
        lookup_table[8'h1C][0] = 10'b0011110100; // K28.0 RD-
        lookup_table[8'h1C][1] = 10'b1100001011; // K28.0 RD+
        lookup_table[8'h3C][0] = 10'b0011111001; // K28.1 RD-
        lookup_table[8'h3C][1] = 10'b1100000110; // K28.1 RD+
        lookup_table[8'h5C][0] = 10'b0011110101; // K28.2 RD-
        lookup_table[8'h5C][1] = 10'b1100001010; // K28.2 RD+
        lookup_table[8'h7C][0] = 10'b0011110011; // K28.3 RD-
        lookup_table[8'h7C][1] = 10'b1100001100; // K28.3 RD+
        lookup_table[8'h9C][0] = 10'b0011110010; // K28.4 RD-
        lookup_table[8'h9C][1] = 10'b1100001101; // K28.4 RD+
        lookup_table[8'hBC][0] = 10'b0011111010; // K28.5 RD-
        lookup_table[8'hBC][1] = 10'b1100000101; // K28.5 RD+
        lookup_table[8'hDC][0] = 10'b0011110110; // K28.6 RD-
        lookup_table[8'hDC][1] = 10'b1100001001; // K28.6 RD+
        lookup_table[8'hFC][0] = 10'b0011111000; // K28.7 RD-
        lookup_table[8'hFC][1] = 10'b1100000111; // K28.7 RD+
        lookup_table[8'hF7][0] = 10'b1110101000; // K23.7 RD-
        lookup_table[8'hF7][1] = 10'b0001010111; // K23.7 RD+
        lookup_table[8'hFB][0] = 10'b1101101000; // K27.7 RD-
        lookup_table[8'hFB][1] = 10'b0010010111; // K27.7 RD+
        lookup_table[8'hFD][0] = 10'b1011101000; // K29.7 RD-
        lookup_table[8'hFD][1] = 10'b0100010111; // K29.7 RD+
        lookup_table[8'hFE][0] = 10'b0111101000; // K30.7 RD-
        lookup_table[8'hFE][1] = 10'b1000010111; // K30.7 RD+
        // D-Codes
        lookup_table[8'h00][0] = 10'b1001110100; // D0.0 RD-
        lookup_table[8'h00][1] = 10'b0110001011; // D0.0 RD+
        lookup_table[8'h01][0] = 10'b0111010100; // D1.0 RD-
        lookup_table[8'h01][1] = 10'b1000101011; // D1.0 RD+
        lookup_table[8'h02][0] = 10'b1011010100; // D2.0 RD-
        lookup_table[8'h02][1] = 10'b0100101011; // D2.0 RD+
        lookup_table[8'h03][0] = 10'b1100011011; // D3.0 RD-
        lookup_table[8'h03][1] = 10'b1100010100; // D3.0 RD+
        lookup_table[8'h04][0] = 10'b1101010100; // D4.0 RD-
        lookup_table[8'h04][1] = 10'b0010101011; // D4.0 RD+
        lookup_table[8'h05][0] = 10'b1010011011; // D5.0 RD-
        lookup_table[8'h05][1] = 10'b1010010100; // D5.0 RD+
        lookup_table[8'h06][0] = 10'b0110011011; // D6.0 RD-
        lookup_table[8'h06][1] = 10'b0110010100; // D6.0 RD+
        lookup_table[8'h07][0] = 10'b1110001011; // D7.0 RD-
        lookup_table[8'h07][1] = 10'b0001110100; // D7.0 RD+
        lookup_table[8'h08][0] = 10'b1110010100; // D8.0 RD-
        lookup_table[8'h08][1] = 10'b0001101011; // D8.0 RD+
        lookup_table[8'hC5][0] = 10'b1010010110; // D5.6 RD-
        lookup_table[8'hC5][1] = 10'b1010010110; // D5.6 RD+
        lookup_table[8'h50][0] = 10'b0110110101; // D16.2 RD-
        lookup_table[8'h50][1] = 10'b1001000101; // D16.2 RD+
    end

    // Task para calcular la disparidad
    task automatic calculate_disparity(
        input [9:0] tx_code_group
    );
        begin
           first_six_bits = tx_code_group[9:4];
                last_four_bits = tx_code_group[3:0];
                
                for (i = 0; i < 6; i = i + 1) begin
                    if (first_six_bits[i] == 1) begin
                        ones_six = ones_six + 1;
                    end if (first_six_bits[i] == 0)  begin
                        zeros_six = zeros_six + 1;
                    end
                end
                
                for (j = 0; j < 4; j = j + 1) begin
                    if (last_four_bits[j] == 1) begin
                        ones_four = ones_four + 1;
                    end if (last_four_bits[j] == 0) begin
                        zeros_four = zeros_four + 1;
                    end
                end
                
                // Determinar la disparidad inicial del primer sub-bloque
                initial_disparity_six = final_disparity_four;
                
                // Determinar la disparidad final del primer sub-bloque si es regla especial
                if ((first_six_bits == 6'b000111) || (ones_six > zeros_six)) begin
                    final_disparity_six = 1; // Positiva
                end else if ((first_six_bits == 6'b111000) || (ones_six < zeros_six)) begin
                    final_disparity_six = 0; // Negativa
                end else begin
                    final_disparity_six = initial_disparity_six; // Mantener la misma disparidad
                end
                
                // Determinar la disparidad inicial del segundo sub-bloque
                initial_disparity_four = final_disparity_six;
                
        
                // Determinar la disparidad final del segundo sub-bloque si es regla especial
                if ((last_four_bits == 4'b0011) || (ones_four > zeros_four)) begin
                    final_disparity_four = 1; // Positiva
                end else if ((last_four_bits == 4'b1100) || (ones_four < zeros_four)) begin
                    final_disparity_four = 0; // Negativa
                end else begin
                    final_disparity_four = initial_disparity_four; // Mantener la misma disparidad
                end
                
                // Disparidad total del code_group
                if (final_disparity_four) begin
                    total_disparity = 1; // Positiva
                end if (!final_disparity_four) begin
                    total_disparity = 0; // Negativa
                end

        end
    endtask

    // State transition logic
    always @(posedge GTX_CLK) begin
        if (!RESET) begin
            current_state <= GENERATE_CODE_GROUPS;
            total_disparity <= 0; 
            tx_even <= 0;
            //PUDI <= 1;
            TX_OSET_indicate <= 0;// Initial assumption: negative disparity
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic and output generation
    always @(*) begin
        next_state = current_state;
        case (current_state)
            GENERATE_CODE_GROUPS: begin //0
                //TX_OSET_indicate = 1'b0;
                ones_six = 0;
    		    zeros_six = 0;
    		    ones_four = 0;
    		    zeros_four = 0;

                if (TX_EN==0 && tx_o_set== 8'hFD || TX_EN==0 && tx_o_set== 8'hF7) begin // Checking if it is a special K code
                         // Use the lookup table to get the appropriate 10-bit code
                        tx_code_group = lookup_table[tx_o_set][total_disparity];
                        // Llamar al task para calcular la disparidad
                        calculate_disparity(tx_code_group);
                        tx_even = !tx_even;
                        TX_OSET_indicate = 1;
                        next_state = GENERATE_CODE_GROUPS; // Mover de vuelta a generar grupos de códigos
                    end

                if(TX_EN == 0) begin
                    if(total_disparity) begin
                        if (tx_o_set == 8'hBC) begin 
                        tx_code_group = lookup_table[tx_o_set][total_disparity];
                        // Llamar al task para calcular la disparidad
                        calculate_disparity(tx_code_group);
                        tx_even = TRUE;
                        next_state = IDLE_I1B;
                        end
                    end

                    if(!total_disparity) begin
                        if(tx_o_set == 8'hBC) begin
                        tx_code_group = lookup_table[tx_o_set][total_disparity];
                        // Llamar al task para calcular la disparidad
                        calculate_disparity(tx_code_group);
                        tx_even = TRUE;
                        next_state = IDLE_I2B;
                        end 
                    end
                end 
                if (TX_EN == 1) begin
                    if (tx_o_set == 8'hFB) begin // Checking if it is a special K code
                        tx_even = TRUE;
                         // Use the lookup table to get the appropriate 10-bit code
                        tx_code_group = lookup_table[tx_o_set][total_disparity];
                        // Llamar al task para calcular la disparidad
                        calculate_disparity(tx_code_group);
                        
                        TX_OSET_indicate = 1;
                        next_state = GENERATE_CODE_GROUPS; // Mover de vuelta a generar grupos de códigos
                    end else begin
                         // Use the lookup table to get the appropriate 10-bit code
                        tx_code_group = lookup_table[tx_o_set][total_disparity];
                        // Llamar al task para calcular la disparidad
                        calculate_disparity(tx_code_group);
                        tx_even = !tx_even;
                        TX_OSET_indicate = 1;
                        next_state = GENERATE_CODE_GROUPS; // Mover de vuelta a generar grupos de códigos
                    end
                end
            end

            IDLE_I1B: begin //1
                tx_code_group = lookup_table[8'hC5][total_disparity];
                // Llamar al task para calcular la disparidad
                calculate_disparity(tx_code_group);
                tx_even = FALSE;
                TX_OSET_indicate = 1;
                next_state = GENERATE_CODE_GROUPS;
            end

            IDLE_I2B: begin //2
              tx_code_group = lookup_table[8'h50][total_disparity];
              // Llamar al task para calcular la disparidad
              calculate_disparity(tx_code_group);
              tx_even = FALSE;
              TX_OSET_indicate = 1;
              next_state = GENERATE_CODE_GROUPS;
            end
            
            //default: GENERATE_CODE_GROUPS;

        endcase
    end

endmodule
