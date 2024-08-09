`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/06/2024 04:41:52 PM
// Design Name: 
// Module Name: uart
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


module uart
    #(
    parameter DBIT = 8,
    SB_TICK = 16,
    FIFO_W = 2
    )
    (
    input logic clk, reset,
    input logic rd_uart, wr_uart, rx,
    input logic [7:0] w_data,
    input logic [10:0] dvsr,
    output logic tx_full, rx_empty, tx,
    output logic [7:0] r_data
    );
    
    // Signal declarations
    logic tick, rx_done_tick, tx_done_tick;
    logic tx_empty, tx_fifo_not_empty;
    logic [7:0] tx_fifo_out, rx_data_out;
    
    // Baud generator
    baud_gen baud_gen_uart (.*);
    
    // UART Receiver
    uart_rx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_rx_unit 
    (.*, .s_tick(tick), .dout(rx_data_out));
    
    // UART Transmitter
    uart_tx #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_tx_unit 
    (.*, .s_tick(tick), .tx_start(tx_fifo_not_empty), .din(tx_fifo_out));
    
    // RX FIFO
    fifo fifo_rx_unit 
    (.clk(clk),.srst(reset),.rd_en(rd_uart),.wr_en(rx_done_tick),.din(rx_data_out),
    .empty(rx_empty),.full(),.dout(r_data));
    
    // TX FIFO
    fifo fifo_tx_unit 
    (.clk(clk),.srst(reset),.rd_en(tx_done_tick),.wr_en(wr_uart),.din(w_data),
    .empty(tx_empty),.full(tx_full),.dout(tx_fifo_out));
        
    assign tx_fifo_not_empty = ~tx_empty;

endmodule

