TARGET := test/testbench.v
TARGET_OUTPUT := bin/out
RECIEVER_DIR := hdl/receptor
TRANS_DIR := hdl/Transmisor
SYNC_DIR := hdl/sincronizador
TEST_DIR := test/
SAVE_FILE := waveforms.gtkw
VCD := out.vcd

all: run graph

run: $(TARGET)
	iverilog -o $(TARGET_OUTPUT) $(TARGET) -I$(TRANS_DIR) -I$(RECIEVER_DIR) -I$(SYNC_DIR) -I$(TEST_DIR)
	vvp $(TARGET_OUTPUT)

graph: $(SAVE_FILE)
	gtkwave bin/$(VCD) $(SAVE_FILE)

clean:
	rm -f $(TARGET_OUTPUT)
	rm -f bin/$(VCD)

