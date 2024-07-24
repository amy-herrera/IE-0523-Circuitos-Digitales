// Receptor PCS de la clausula 36 del 802.3
module reciever(
    input clk,
    input rst,
    input sync_status,
    input rx_even,
    input SUDI,
    input [9:0] x,
    output reg [7:0] RXD,
    output reg RX_DV,
    output RX_CLK
);

`include "codegroups.vh"
`include "funcs.vh"
`include "decode.vh"

reg check_end = 0;
wire K28_5, K27_7, K29_7, K23_7;

localparam WAIT_FOR_K = 6'd1,
           RX_K = 6'd2,
           IDLE_D = 6'd4,
           START_OF_PACKET = 6'd8,
           RX_DATA = 6'd16,
           TRI_RRI = 6'd32;

reg [5:0] state, next;
reg [9:0] x_reg;  // Registro para almacenar temporalmente x

// Cambio de proximo estado
always @(posedge clk) begin
    if (!rst) state <= WAIT_FOR_K;
    else state <= next;
end

always @(posedge clk) begin
    if (!rst) x_reg <= 10'd0;
    else x_reg <= x;  // Almacena temporalmente x cuando está en los estados relevantes
end

always @(*) begin
    next = state;
    RXD = 8'd0;
    RX_DV = 0;

    case (state)
        WAIT_FOR_K: begin 
            if(SUDI & K28_5 & rx_even) begin
                next = RX_K;
            end
        end
        RX_K: begin
            if(SUDI & D(x_reg)) next = IDLE_D;

        end
        IDLE_D: begin
            if(SUDI & K28_5) next = RX_K;
            else if(SUDI & K27_7) begin
                next = START_OF_PACKET;
            end
        end
        START_OF_PACKET: begin
            RX_DV = 1;
            RXD = 8'b0101_0101;
            if(SUDI & D(x_reg)) next = RX_DATA;
        end
        RX_DATA: begin
            RXD = DECODE(x_reg);
            RX_DV = 1;
            if(check_end) next = TRI_RRI;
            else if(SUDI & D(x_reg)) next = RX_DATA;
        end
        TRI_RRI: begin
            if(SUDI & K28_5) next = RX_K;
        end
    endcase
end

/*Revisar si termino transmisión*/
localparam IDLE = 4'd1,
           END_OF_PACKET = 4'd2,
           WAIT_FOR_R = 4'd4,
           TERMINATE = 4'd8;

reg [3:0] tstate, tnext;
always @(posedge clk) begin
    if (!rst) tstate <= IDLE;
    else tstate <= tnext;
end

always @(*) begin
    tnext = tstate;
    check_end = 0;
    case (tstate)
        IDLE:  begin
            if(SUDI & K29_7) begin
                check_end = 1;
                tnext = END_OF_PACKET;
            end
        end
        END_OF_PACKET: begin
            if(SUDI & K23_7) tnext = WAIT_FOR_R;
            else tnext = IDLE;
        end
        WAIT_FOR_R: begin
            if(SUDI & K28_5) tnext = TERMINATE;
            else tnext = IDLE;
        end
        TERMINATE: begin
            tnext = IDLE;
        end
        default: tstate = tnext;
    endcase
end

/* Grupos especiales */
assign K28_5 = (x == K28_5_rd_plus ) | (x == K28_5_rd_minus);
assign K27_7 = (x == K27_7_rd_plus) | (x == K27_7_rd_minus);
assign K29_7 = (x == K29_7_rd_plus) | (x == K29_7_rd_minus);
assign K23_7 = (x == K23_7_rd_plus) | (x == K23_7_rd_minus);

assign RX_CLK = clk;

endmodule