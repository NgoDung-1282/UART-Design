`timescale 1ns / 1ps

module uart_tx_tb;

    // Inputs
    logic clk;
    logic reset;
    logic tx_start;
    logic [7:0] din;
    logic s_tick;

    // Outputs
    logic tx;
    logic tx_done_tick;

    // Instantiate the Unit Under Test (UUT)
    uart_tx #(
        .DBIT(8),
        .SB_TICK(16)
    ) uut (
        .clk(clk), 
        .reset(reset), 
        .tx_start(tx_start), 
        .din(din), 
        .s_tick(s_tick), 
        .tx_done_tick(tx_done_tick),
        .tx(tx)
    );

    // Clock generation
    always #1 clk = ~clk; // 100MHz clock (10ns period)

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        tx_start = 0;
        din = 8'b00000000;
        s_tick = 0;

        // Wait for global reset to finish
        #2;
        reset = 0;
        #2;
        
        // Test case 1: Transmit 0x4D
        din = 8'b01001101; // 0x4D
        tx_start = 1;
        #2;
        tx_start = 0;

        // Generate sampling ticks (simulate baud rate clock)
        repeat (160) begin
            #2 s_tick = 1;
            #2 s_tick = 0;
        end

        // Test case 2: Transmit 0xA5
        din = 8'b10100101; // 0xA5
        tx_start = 1;
        #2;
        tx_start = 0;

        // Generate sampling ticks (simulate baud rate clock)
        repeat (160) begin
            #2 s_tick = 1;
            #2 s_tick = 0;
        end

        // Wait for the second transmission to complete
        wait(tx_done_tick);

        // Stop simulation
        #2;
        $stop;
    end
      
endmodule
