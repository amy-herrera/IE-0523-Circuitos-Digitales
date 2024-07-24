`include "transmisor1.v"
`include "transmisor2.v"

module transmisor (
    input wire GTX_CLK,
    input wire RESET,
    input wire TX_EN,
    input wire [7:0] tx_octet,         // tx_octet es de 8 bits
    output wire [7:0] tx_o_set,        // tx_o_set es de 8 bits
    output wire [9:0] tx_code_group,   // tx_code_group es de 10 bits
    output wire TX_OSET_indicate,
    output wire tx_even,
    output wire PUDI
);

    // Instancia de la máquina de estado transmisor_1
    transmisor_1 U1 (
        .GTX_CLK(GTX_CLK), 
        .RESET(RESET), 
        .TX_EN(TX_EN), 
        .tx_octet(tx_octet),
        .tx_o_set(tx_o_set),
        .TX_OSET_indicate(TX_OSET_indicate),
        .tx_even(tx_even)
    );

    // Instancia de la máquina de estado transmisor_2
    transmisor_2 U2 (
        .GTX_CLK(GTX_CLK), 
        .RESET(RESET), 
        .TX_EN(TX_EN),
        .tx_o_set(tx_o_set),
        .TX_OSET_indicate(TX_OSET_indicate),
        .tx_even(tx_even),
        .tx_code_group(tx_code_group), // Conexión de tx_code_group
        .PUDI(PUDI)
    );

endmodule


