`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2026 12:35:51 AM
// Design Name: 
// Module Name: sc_fifo_TB
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

module sc_fifo_TB;
    parameter WIDTH_TB = 16;
    parameter DEPTH_TB = 32;
    // This is for the memory location 
    integer i;
// Inputs use reg: TB assigns values to them procedurally inside initial block
    reg clk_TB;
    reg SRST_TB;
    reg [WIDTH_TB-1:0] data_in_TB;
    reg write_enable_TB;
    reg read_enable_TB;
// Outputs use wire: Driven continiously and TB observes them
    wire [$clog2(DEPTH_TB+1):0] data_count_TB;
    wire valid_TB;
    wire [WIDTH_TB-1:0] data_out_TB;
    wire almost_full_TB;
    wire almost_empty_TB;
    wire full_TB;
    wire empty_TB;
    
    sc_fifo 
    #(
    .WIDTH(WIDTH_TB),
    .DEPTH(DEPTH_TB),
    .ALMOST_EMPTY_THRESHOLD(2),
    .ALMOST_FULL_THRESHOLD(31),
    .READ_LATENCY(1)
    )
    UUT
    (
    .clk(clk_TB),
    .SRST(SRST_TB),
    .data_in(data_in_TB),
    .write_enable(write_enable_TB),
    .read_enable(read_enable_TB),
    .data_count(data_count_TB),
    .valid(valid_TB),
    .data_out(data_out_TB),
    .almost_full(almost_full_TB),
    .almost_empty(almost_empty_TB),
    .full(full_TB),
    .empty(empty_TB)
    );
    /* Example:
    0to5ns is low then 5-10ns is high, 10-15ns is low and so on.
    */
    // This will set the value of clk_TB at zero. 
    initial clk_TB = 0;
    // Every 5 ns for clk_TB it will flip again.
    // Given: Frequency is 50MHz clock
    // Period: 1/f => 1/50_000_000 = 20ns
    // Clock Period has 2 halves so 10ns each half
    always #10 clk_TB = ~clk_TB;
    // THIS IS TEST CASE 1: Reset is asserted so return 0
    initial begin
    SRST_TB =0;
    data_in_TB=0;
    write_enable_TB=0;
    read_enable_TB=0;
    
    @(posedge clk_TB);
    SRST_TB=1;
    
    @(posedge clk_TB);
    @(posedge clk_TB);
    SRST_TB=0;
    @(posedge clk_TB);
    if (data_count_TB ==0 && empty_TB ==1)
        $display("PASSED.");
    else
        $display("FAILED: empty=%b count = %0d", empty_TB,data_count_TB);        
        
    // Writting all 1's THIS IS TEST CASE 2
    // Enable write; so set it high
    write_enable_TB = 1;
    // this will feed all 1s into data_in_TB as 1111_1111_1111_1111; Sets data to 0xFFFF
    data_in_TB = 16'hFFFF;
    @(posedge clk_TB);
    // FIFO stored it
    write_enable_TB =0;
    // check count
    @(posedge clk_TB);
    if (data_count_TB ==1&& empty_TB ==0)
        $display("Write all Ones: PASSED.");
    else
        $display("Write all Ones: FAILED");       
        // Enable Read
        read_enable_TB = 1;
        @(posedge clk_TB);
        // FIFO outputs it
        read_enable_TB =0;
        @(posedge clk_TB);
        // Checking data  == 0xFFFF
    if (data_out_TB ==16'hFFFF)
        $display("Read all Ones: PASSED.");
    else
        $display("Read all Ones: FAILED");       
    // Then writting all 0s and reading out all 0s.
        write_enable_TB =1;
        data_in_TB = 16'h0000;
        @(posedge clk_TB);
        write_enable_TB = 0;
        @(posedge clk_TB);
        
    if (data_count_TB ==1 && empty_TB==0)
        $display("Write all Zeros: PASSED");
    else
        $display("Write all Zeros: FAILED");
    // Reading all zeros
        read_enable_TB = 1;
        @(posedge clk_TB);
        read_enable_TB = 0;
        @(posedge clk_TB);
    if (data_out_TB == 16'h0000)
        $display("Read all Zeros: PASSED");
    else
        $display("Read all Zeros: FAILED"); 
       
       // Alternating bit patterns such as 0xAAAA
       write_enable_TB = 1;
       data_in_TB = 16'hAAAA;
       @(posedge clk_TB);
       write_enable_TB = 0;
       @(posedge clk_TB);
       
       read_enable_TB = 1;
       @(posedge clk_TB);
       read_enable_TB = 0;
       @(posedge clk_TB);
       
    if (data_out_TB == 16'hAAAA) 
       $display("Alternating for 0xAAAA has: PASSED");
    else
       $display("Alternating for 0xAAAA has: FAILED");
       
    // Alternating bit patterns for 0x5555 
        write_enable_TB =1;
        data_in_TB = 16'h5555;
        @(posedge clk_TB);
        write_enable_TB = 0;
        @(posedge clk_TB);
        
        read_enable_TB = 1;
        @(posedge clk_TB);
        read_enable_TB = 0;
        @(posedge clk_TB);
        
    if (data_out_TB == 16'h5555) 
       $display("Alternating for 0x5555 has: PASSED");
    else
       $display("Alternating for 0x5555 has: FAILED");
    
    // Writting to every memory location and read in every memory lcoaiton back    
    for (i=0; i < DEPTH_TB; i=i+1)// Writing starts HERE
        begin
            write_enable_TB = 1;
            data_in_TB = i;
            @(posedge clk_TB);
    end
    // Where the loop ends
        write_enable_TB = 0;
        @(posedge clk_TB);
    //checks for all 32 locations if they are filled then pass if not fail
    if (full_TB == 1) 
       $display("Writing to every memory location: PASSED");
    else
       $display("Writing to every memory location: FAILED");
    for (i = 0;i<DEPTH_TB; i= i+1) // Reading starts HERE
        begin
            read_enable_TB = 1;
            @(posedge clk_TB);
    end
        read_enable_TB = 0;
        @(posedge clk_TB);
    
    if (empty_TB ==1)
        $display("Reading every location: PASSED");
    else
        $display("Reading every location: FAILED"); 
    
    // STATUS FLAGS
    // EMPTY FLAG 
    if (empty_TB == 1)
        $display("Empty Flag: PASSED");
    else
        $display("Empty Flag: FAILED");
    // ALMOST FULL FLAG
    for (i = 0; i <31; i=i+1)
        begin
            write_enable_TB = 1;
            data_in_TB =i;
            @(posedge clk_TB);
    end
        write_enable_TB = 0;
        @(posedge clk_TB);
        
    if (almost_full_TB ==1)
        $display("Almost full: PASSED");
    else
        $display("Almost full: FAILED");
     
     // FULL FLAG
     write_enable_TB = 1;
     data_in_TB = 16'hFFFF;
     @(posedge clk_TB);
     write_enable_TB = 0;
     @(posedge clk_TB);
     
     if(full_TB ==1)
        $display("Full: PASSED");
     else
        $display("Full: FAILED");
      
     // ALMOST EMPTY FLAG
     for (i =0;i<30; i= i+1)
        begin
            read_enable_TB =1;
            @(posedge clk_TB);
      end
        read_enable_TB = 0;
        @(posedge clk_TB);
        
        if (almost_empty_TB ==1)
            $display("Almost empty: PASSED");
        else
            $display("Almost empty: FAILED");
      
     // WRITE ENABLE TEST
     write_enable_TB = 0;
     data_in_TB=16'hCAFE;
     @(posedge clk_TB);
     @(posedge clk_TB);
     
     if (data_count_TB == 2)
        $display("Write Enable Stayed: PASSED");
     else
        $display("Write Enable Stayed: FAILED");
        
     //READ ENABLE TEST
     read_enable_TB =0;
     @(posedge clk_TB);
     @(posedge clk_TB);
     
     if (data_count_TB ==2)
         $display("Read Enable Stayed: PASSED");
     else
        $display("Read Enable Stayed: FAILED");
     $finish(1);
  end
endmodule
