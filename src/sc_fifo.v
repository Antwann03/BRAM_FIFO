`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CSUN
// Engineer: Antonio Anzora Jr
// 
// Create Date: 09/28/2026 07:23:44 PM
// Design Name: 
// Module Name: sc_fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module sc_fifo # 
(
    parameter WIDTH = 16,
    parameter DEPTH = 32,
    // This can be either 1 or 2; Our choice
    parameter ALMOST_EMPTY_THRESHOLD =2,
    // This can be either either 31 or 30; Our choice
    parameter ALMOST_FULL_THRESHOLD =31,
    // This can be either value from 1 to 8; Our choice
    parameter READ_LATENCY = 1
)
    (
    // INPUTS
    input clk,
    input SRST,
    input [WIDTH -1:0] data_in,
    input write_enable,
    input read_enable,
    // OUTPUTS
    output [$clog2(DEPTH+1):0] data_count,
    output valid,
    output [WIDTH -1:0] data_out,
    output almost_full,
    output almost_empty,
    output full,
    output empty
    );
    // this is the BRAM
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    // This is where it holds the data being read out
    reg [WIDTH-1:0] data_out_reg;
    // Tracks where to write next in the memory table
    reg [$clog2(DEPTH)-1:0] pointer_write;
    // Tracks where to read next from the memory table
    reg [$clog2(DEPTH)-1:0] pointer_read;
    // Tracks how many items there are in FIFO
    reg [$clog2(DEPTH):0] count;
    // ASSIGNINMENTS
    assign empty=(count ==0);
    assign full =(count ==DEPTH);
    assign data_count =count;
    assign data_out=data_out_reg;
    assign valid = !empty;
    // The status flags
    assign almost_full =(count >= ALMOST_FULL_THRESHOLD);
    assign almost_empty =(count<=ALMOST_EMPTY_THRESHOLD);
    
    // Runs on every rising clock edege (synchronous)
    always @(posedge clk)
    begin
        if (SRST)
            begin
            // Write and Read Pointers are cleared, which returns FIFO to the empty state.
                pointer_write <=0;
                pointer_read<=0;
                count<=0;
                data_out_reg <=0;
            end
        else
        begin
        // WRITE OPERATION
        if (write_enable && !full)
            begin
                mem[pointer_write] <= data_in;
                pointer_write<=pointer_write +1;
            end
        // READ OPERATION
        if(read_enable && !empty)
            begin
                data_out_reg <= mem[pointer_read];
                pointer_read<=pointer_read+1;
            end
            
        if (write_enable && !full && !(read_enable && !empty))
            count<=count+1;
        else if (read_enable && !empty && !(write_enable && !full))
            count<=count-1;
        end
    end
endmodule
