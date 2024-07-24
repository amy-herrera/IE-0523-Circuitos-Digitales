# Definir el compilador de Verilog
VERILOG_COMPILER = iverilog

# Definir el nombre del ejecutable
EXECUTABLE = a.out

# Definir el nombre del archivo VCD
VCD_FILE = testbench.vcd

# Objetivo por defecto
all: compile simulate view

# Compilar el testbench.v y cualquier otro archivo necesario
compile:
	$(VERILOG_COMPILER) testbench.v

# Ejecutar el ejecutable generado
simulate:
	vvp $(EXECUTABLE)

# Visualizar los resultados usando GTKWave
view:
	gtkwave $(VCD_FILE)

# Limpiar archivos generados
clean:
	rm -f $(EXECUTABLE) $(VCD_FILE) $(SYNTH_FILE)

