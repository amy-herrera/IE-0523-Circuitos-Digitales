`include "tester.v"
`include "controller_rtlil.v"

module controller_tb;
wire clk;                  //Aquí se establecen los cables de las entradas y las salidas del sistema
wire reset;
wire sensor_entrance;
wire sensor_exit;
wire [7:0] input_password;
wire gate_open;
wire alarm_wrong_pin;
wire gate_close;
wire alarm_block;

initial begin
	$dumpfile("resultados.vcd"); // Se generan los resultados para poder verlos con gtkwave
	$dumpvars(-1, U0);
	$monitor ("sensor_entrance=%b,sensor_exit=%b,gate_open=%b,gate_close=%b,alarm_pin=%b, alarm_block=%b", sensor_entrance, sensor_exit, gate_open, gate_close, alarm_wrong_pin, alarm_block); // Se despliega en consola el funcionamiento del sistema
  end
// Instanciar el controlador
controller U0 (
    .clk(clk),
    .reset(reset),
    .sensor_entrance(sensor_entrance),
    .sensor_exit(sensor_exit),
    .input_password(input_password),
    .gate_open(gate_open),
    .alarm_wrong_pin(alarm_wrong_pin),
    .gate_close(gate_close),
    .alarm_block(alarm_block)
);

// Instanciar el probador
tester P0 (
    .clk(clk),
    .reset(reset),
    .sensor_entrance(sensor_entrance),
    .sensor_exit(sensor_exit),
    .input_password(input_password),
    .gate_open(gate_open),
    .alarm_wrong_pin(alarm_wrong_pin),
    .gate_close(gate_close),
    .alarm_block(alarm_block)
);

endmodule

