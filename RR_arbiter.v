`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:06:04 06/17/2013 
// Design Name: 
// Module Name:    RR_arbiter2 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

/*
	A VERIOG-HDL IMPLEMENTATION OF VIRTUAL CHANNELS IN A NETWORK-ON-CHIP ROUTER
                A Thesis by SUNGHO PARK
   Fig. 52. Verilog code of a round-robin arbiter in a generic and ViChaR router
	Main Ref:  "Arbiters: Design Ideas and Coding Styles"
			Page 19  -- Listing 12 - mask_expand round-robin arbiter
*/

module RR_arbiter(
clock,
rst,
req4,
req3,
req2,
req1,
req0,
gnt4,
gnt3,
gnt2,
gnt1,
gnt0
);
parameter [4:0] N = 5'd5;
input 	clock;
input 	rst;
input 	req4;
input 	req3;
input 	req2;
input 	req1;
input 	req0;
output	gnt4;
output	gnt3;
output 	gnt2;
output 	gnt1;
output 	gnt0;
//Declarations
reg 	[N-1:0] pointer_reg;//priority vector
wire 	[N-1:0] req;//request vector
// ----------------------- Combinational Logic  ------------------------------ //  
assign req = {req4,req3, req2, req1, req0};
//Declarations
wire  [N-1:0] gnt;
// ----------------------- Combinational Logic  ------------------------------ //  
assign gnt4 = gnt[4];
assign gnt3 = gnt[3];
assign gnt2 = gnt[2];
assign gnt1 = gnt[1];
assign gnt0 = gnt[0];

//************ Masked Path -- FPA********
// Simple priority arbitration for masked portion
//Declarations
wire [N-1:0] req_masked;
wire [N-1:0] mask_higher_pri_regs;
wire [N-1:0] gnt_masked;
// ----------------------- Combinational Logic  ------------------------------ //  
assign req_masked = req & pointer_reg; // masking
assign mask_higher_pri_regs[N-1:1] = mask_higher_pri_regs[N-2:0] | req_masked[N-2:0]; //shifting
assign mask_higher_pri_regs[0] = 1'b0;
assign gnt_masked[N-1:0] = req_masked[N-1:0] & ~mask_higher_pri_regs[N-1:0]; //granting

//********* Un Masked Path -- FPA **********
// Simple priority arbitration for unmasked portion
//Declarations
wire [N-1:0] unmask_higher_pri_regs;
wire [N-1:0] gnt_unmasked;
// ----------------------- Combinational Logic  ------------------------------ //  
assign unmask_higher_pri_regs[N-1:1] = unmask_higher_pri_regs[N-2:0] | req[N-2:0];
assign unmask_higher_pri_regs[0] = 1'b0;
assign gnt_unmasked[N-1:0] = req[N-1:0] & ~unmask_higher_pri_regs[N-1:0];

// Use grant_masked if there is any there, otherwise use grant_unmasked.
//Declarations
wire no_req_masked;
// ----------------------- Combinational Logic  ------------------------------ //  
assign no_req_masked = ~(|req_masked); // not OR tree 
assign gnt = ({N{no_req_masked}} & gnt_unmasked) | gnt_masked; //Red MUX

//*********** Sequential Logic ******************
// Pointer update
always @(negedge rst or posedge clock) 
	begin
		if(!rst) 
			begin
				pointer_reg <= {N{1'b1}};
			end 
		else 
			begin
				if(|req_masked) pointer_reg <= mask_higher_pri_regs;// Which arbiter was used?
				else if(|req) pointer_reg <= unmask_higher_pri_regs;// Only update if there's a req
				else pointer_reg <= pointer_reg;
			end
	end

endmodule
