`timescale 1ns / 1ps

module uart_rx_tb;

    // Inputs
    logic clk;
    logic reset;
    logic s_tick;
    logic rx;

    // Outputs
    logic rx_done_tick;
    logic [7:0] dout;

    // Instantiate the Unit Under Test (UUT)
    uart_rx #(
        .DBIT(8),
        .SB_TICK(16)
    ) uut (
        .clk(clk), 
        .reset(reset), 
        .rx(rx), 
        .s_tick(s_tick), 
        .rx_done_tick(rx_done_tick), 
        .dout(dout)
    );

    // Clock generation
    always #1 clk = ~clk; // 100MHz clock (10ns period)

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        s_tick = 0;
        rx = 1'b1; // Idle state for RX

        // Wait for global reset to finish
        #2;
        reset = 0;
        #2;

        // Test case: Simulate reception of 0x4D
        send_byte(8'b01001101); // Send 0x4D

        wait(rx_done_tick);
        assert(dout == 8'h4D) else $fatal("Test case failed: Expected 0x4D, got 0x%h", dout);

        // Stop simulation
        #2;
        $stop;
    end

    // Task to simulate sending a byte to the UART receiver
    task send_byte(input logic [7:0] data);
        integer i;
        // Send start bit (0)
        rx = 1'b0;
        repeat (16) begin
            #2 s_tick = 1;
            #2 s_tick = 0;
        end
        // Send data bits (LSB first)
        for (i = 0; i < 8; i = i + 1) begin
            rx = data[i];
            repeat (16) begin
                #2 s_tick = 1;
                #2 s_tick = 0;
            end
        end
        // Send stop bit (1)
        rx = 1'b1;
        repeat (16) begin
            #2 s_tick = 1;
            #2 s_tick = 0;
        end
    endtask

endmodule
