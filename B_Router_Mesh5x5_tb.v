`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:35:59 07/13/2013
// Design Name:   F_Router_Mesh5x5
// Module Name:   D:/Master2012-2013/NoC_Codes/RouterDesign2013/F_Router_Mesh5x5/F_Router_Mesh5x5_tb.v
// Project Name:  F_Router_Mesh5x5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: F_Router_Mesh5x5
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module B_Router_Mesh5x5_tb;

	// Inputs
	reg clk;
	reg reset;

	// Instantiate the Unit Under Test (UUT)
	B_Router_Mesh5x5 uut (
		.clk(clk), 
		.reset(reset)
	);

// Clock generator
always	
#5 clk = ~clk;
		
initial 
	begin
		// Initialize Inputs
		clk 	= 0;
		reset = 0;
		repeat(3) @(posedge clk);
		reset = 1;
		repeat(250000) @(posedge clk); 
		$finish; // to shut down the simulation 
	end

      
endmodule

