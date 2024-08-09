`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2024 11:10:06 AM
// Design Name: 
// Module Name: uart_rx
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
module uart_rx
    #(parameter DBIT = 8,   // data bits
                SB_TICK = 16    // stop bit ticks
    )
    (
        input logic clk, reset,
        input logic rx, s_tick,
        output logic rx_done_tick,
        output logic [DBIT - 1:0] dout
    );

    // State encoding
    typedef enum {idle, start, data, stop} state_type;
    state_type state_reg, state_next;
    logic [3:0] s_reg, s_next;   // keep tick of the baud time (16 total)
    logic [2:0] n_reg, n_next;   // keep track the number of data bits receiver
    logic [7:0] b_reg, b_next;     // stores the receiver data bits

    // State and other registers
    always_ff @(posedge clk, posedge reset)
        if (reset)
        begin
            state_reg <= idle;
            s_reg <= 0;
            n_reg <= 0;
            b_reg <= 0;
        end
        else
        begin
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
        end

    // Next state logic
    always_comb
    begin
        state_next = state_reg;
        rx_done_tick = 1'b0;
        s_next = s_reg;
        n_next = n_reg;
        b_next = b_reg;
        case (state_reg)
            idle:
                if (~rx)
                begin
                    state_next = start;
                    s_next = 0;
                end
            start:
                if (s_tick)
                    if (s_reg == 7)
                    begin
                        state_next = data;
                        s_next = 0;
                        n_next = 0;
                    end
                    else
                        s_next = s_reg + 1;
            data:
                if (s_tick)
                    if (s_reg == 15)
                    begin
                        s_next = 0;
                        b_next = {rx, b_reg[7:1]};  // Right shift
                        if (n_reg == (DBIT - 1))
                            state_next = stop;
                        else
                            n_next = n_reg + 1;
                    end
                    else
                        s_next = s_reg + 1;
            stop:
                if (s_tick)
                    if (s_reg == (SB_TICK - 1))
                    begin
                        state_next = idle;
                        rx_done_tick = 1'b1;
                    end
                    else
                        s_next = s_reg + 1;
        endcase
    end

    // Output logic
    assign dout = b_reg;

endmodule
