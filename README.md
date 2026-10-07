# Overview
During this lab we will create a First-In First-Out (FIFO) queue that uses Block RAM (BRAM) for its internal memory. We will also verify the FIFO design with a testbench (sc_fifo_TB.v) and a Python script.

# Design Summary
The FIFO is implemented as a single-clock synchronous design (sc_fifo.v) with configurable width, depth, and threshold parameters. 

**Inputs:** `clk`, `SRST`, `data_in`, `write_enable`, `read_enable`  
**Outputs:** `data_count`, `valid`, `data_out`, `almost_full`, `almost_empty`, `full`, `empty`

The internal memory is inferred as BRAM by Vivado through a synchronous 2D register array. Status flags are driven combinationally from a running count register.

# Verification and Testing

# Known Issues and Limitations

# References
Used for always block for the clock in the Testbench.

https://chipverify.com/verilog/verilog-always-block

Used for the finish function in the testbench.

https://chipverify.com/verilog/verilog-stop-finish
