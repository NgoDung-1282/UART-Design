`timescale 1ns / 1ps

module baud_gen_tb;

    // Inputs
    logic clk;
    logic reset;
    logic [10:0] dvsr;

    // Outputs
    logic tick;

    // Instantiate the Unit Under Test (UUT)
    baud_gen uut (
        .clk(clk), 
        .reset(reset), 
        .dvsr(dvsr), 
        .tick(tick)
    );

    // Clock generation
    always #5 clk = ~clk; // 100 MHz clock (10ns period)

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        dvsr = 11'd100; // Set divisor to 100 for test

        // Wait for global reset to finish
        #15;
        reset = 0;

        // Monitor output
        $monitor("At time %t: tick = %b", $time, tick);

        // Run simulation long enough to observe multiple ticks
        #2000;

        // Stop simulation
        $stop;
    end

endmodule
