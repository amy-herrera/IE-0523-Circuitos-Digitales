# Definir el compilador de Verilog
VERILOG_COMPILER = iverilog

# Definir el nombre del ejecutable
EXECUTABLE = a.out

# Definir el nombre del archivo VCD
VCD_FILE = ondas_rtlil.gtkw

# Definir el nombre del archivo de síntesis
SYNTH_FILE = controller_rtlil.ys

# Objetivo por defecto
all: synthesize compile simulate view

# Sintetizar el diseño RTL con Yosys
synthesize:
	yosys -s $(SYNTH_FILE)

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

