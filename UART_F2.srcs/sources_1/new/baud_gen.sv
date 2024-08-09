`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/04/2024 11:10:06 AM
// Design Name: 
// Module Name: baud_gen
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
module baud_gen
    (
    input logic clk, 
    input logic reset,
    input logic [10:0] dvsr,
    output logic tick
    );
    
    logic [10:0] r_reg;
    logic [10:0] r_next;
    
    always_ff @(posedge clk, posedge reset)
        if (reset)
            r_reg <= 0;
        else
            r_reg <= r_next;
    assign r_next = (r_reg == dvsr) ? 0 : r_reg + 1;
    assign tick = (r_reg == 1);


endmodule
