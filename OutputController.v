`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
/*
 Company: 
 Engineer: 
 
 Create Date:    18:45:32 06/17/2013 
 Design Name: 
 Module Name:    OutputController 
 Project Name: 
 Target Devices: 
 Tool versions: 
 Description: 
  input data Packets from differents ports 
	ports in order ( East(0) - North(1) - West(2) - South(3) - Local(4) ) 
            North (1)
               |
               |
 East(0)---- Local(4) ---- West (2)
               |
               |
             South (3)


 Dependencies: 

 Revision: 
 Revision 0.01 - File Created
 Additional Comments: 
*/
//////////////////////////////////////////////////////////////////////////////////
module OutputController( clk, reset, reqDnStr, gntDnStr, full, 
								PacketInPort_0, PacketInPort_1, PacketInPort_2 , PacketInPort_3,PacketInPort_4,
                          reqInCntr, gntInCntr, PacketOut );
// ------------------------ Parameter Declarations --------------------------- //
parameter routerNo 		= 24; // change depends on mesh size 
parameter dataWidth = 32;// number of bits for data bus
parameter 	SEND_REQ=1'b0, 
				WAIT_GRANT=1'b1;
// ------------------------ Inputs Declarations ------------------------------ //
input clk;
input reset;
input gntDnStr;// grant from down Stram router   
input full;// indicator from FIFO buffer of down stream router .. if full = 1 else = 0
input [dataWidth-1:0] PacketInPort_0, PacketInPort_1, PacketInPort_2, PacketInPort_3,PacketInPort_4;
input [4:0] reqInCntr;// request bus from input controller to handle communication with other ports
// ------------------------ Outputs Declarations ----------------------------- //
output reqDnStr;// request to down Stram router   
output [dataWidth-1:0] PacketOut;// output data Packet form fifo
output [4:0] gntInCntr;// grants to other ports 
// --------------------------- Wire Declarations ----------------------------- //
wire clk;
wire reset;
wire gntDnStr;// grant from down Stram router   
wire full;// indicator from FIFO buffer of down stream router .. if full = 1 else = 0
// input data Packet from fifo
wire [dataWidth-1:0] PacketInPort_0, PacketInPort_1, PacketInPort_2, PacketInPort_3,PacketInPort_4;
reg  [dataWidth-1:0] PacketOut;// output data Packet to output Controller
wire [4:0] reqInCntr;// request bus from input controller to handle communication with other ports
wire [4:0] reqInCntr_wEn;// to handle enable signal to Arbiter
wire [4:0] gntInCntr;// grants to other ports 
wire [2:0] select;// select wires between Mux and Arbiter
// ------------------------ Registers Declarations --------------------------- //
reg reqDnStr;// request to down Stram router   
//register to hold Packet out until makeing arbitration and grant
wire [dataWidth-1:0] DataBuff;
reg STATE;
reg Enable_RRA;// Anding reqInCntr with Enable_RRA
///*********
//assign anygrant = |gntInCntr;//(gnt[0] | gnt[1] | gnt[2] | gnt[3]) ;//--and anyrequest;
//assign select =  {anygrant, (gntInCntr[3] | gntInCntr[2]) , (gntInCntr[3] | gntInCntr[1])}; //& {,}
assign select =  { gntInCntr[4] ,(gntInCntr[3] | gntInCntr[2]) , (gntInCntr[3] | gntInCntr[1])}; //& {,}
/*		g4 g3 g2 g1 g0   s2 s1 s0
		0  0  0  0  1    0  0  0      -->
		0  0  0  1  0    0  0  1		-1-> |   
		0  0  1  0  0    0  1  0			  |  g1 or g3
		0  1  0  0  0    0  1  1      -1-> |
		1  0  0  0  0    1  0  0  
		z  z  z  z  z    1  0  1 Don't Care
		z  z  z  z  z    1  1  0 Don't Care 
		z  z  z  z  z    1  1  1 Don't Care
*/
assign reqInCntr_wEn = reqInCntr & {5{! full & Enable_RRA }};///{5{Enable_RRA}}; // 
//Initializations
initial 
   begin 
		Enable_RRA 		<= 1; 
		reqDnStr  		<= 0;
		PacketOut  		<= 0;
		STATE				<= SEND_REQ;
   end
// ----------------------- Sequential  Logic  -------------------------------- //
always @(posedge clk or negedge reset)
  begin
    if( !reset)//reset all registers
      begin 
        reqDnStr  <= 0;
		  PacketOut  <= 0;
		  STATE		<= SEND_REQ;
      end
    else
	 begin
	 // handle request to down stream router 
      case(STATE)
			SEND_REQ:
				begin
//				if ( ! full )//& (gntInCntr[0] | gntInCntr[1] | gntInCntr[2] | gntInCntr[3]) )
//					begin
//					if (gntInCntr[0] | gntInCntr[1] | gntInCntr[2] | gntInCntr[3]) 
//						begin
//							STATE 		<= WAIT_GRANT;
//							reqDnStr 	<= 1;
//							PacketOut   <= DataBuff;
//							Enable_RRA 	<= 0;					
//						end
//					end
//				else //if(full)
//					begin
//						STATE 		<= SEND_REQ;
//						Enable_RRA 	<= 1;
//					end 
//				end
					if ( ! full & (gntInCntr[0] | gntInCntr[1] | gntInCntr[2] | gntInCntr[3] | gntInCntr[4]) )
						begin
						STATE 		<= WAIT_GRANT;
						reqDnStr 	<= 1;
						PacketOut   <= DataBuff;
						Enable_RRA 	<= 0;
						end
					else if(full)
						begin
						STATE 		<= SEND_REQ;
						Enable_RRA 	<= 0;
						end 
					else
						Enable_RRA 	<= 1;
					end
		    WAIT_GRANT:
				begin
				if ( gntDnStr )
					begin
					STATE 		<= SEND_REQ;
					reqDnStr 	<= 0;
					Enable_RRA 	<= 1;
					end
				else
					begin
					STATE 		<= WAIT_GRANT;
					end
				end
			endcase
		end//else
  end // always 
//assign PacketOut = DataBuff;
// ----------------------- Combinational Logic  ------------------------------ //
// --------------------------------------------------------------------------- //
// ------------------------  instantiation Devices --------------------------- //
/* instantiate round robin arbiter */
RR_arbiter roundRobinArbiter
(
.clock(clk),
.rst(reset),
.req4(reqInCntr_wEn[4]),
.req3(reqInCntr_wEn[3]),
.req2(reqInCntr_wEn[2]),
.req1(reqInCntr_wEn[1]),
.req0(reqInCntr_wEn[0]),
.gnt4(gntInCntr[4]),
.gnt3(gntInCntr[3]),
.gnt2(gntInCntr[2]),
.gnt1(gntInCntr[1]),
.gnt0(gntInCntr[0])
);

// --------------------------------------------------------------------------- //
/* instantiate mux  */
mux # (.dataWidth(dataWidth)) selectPort
( 
.PacketInPort_0(PacketInPort_0),
.PacketInPort_1(PacketInPort_1),
.PacketInPort_2(PacketInPort_2),
.PacketInPort_3(PacketInPort_3),
.PacketInPort_4(PacketInPort_4),
.sel(select),
.PacketOut(DataBuff)
);
endmodule
// ----------------------------- End of File --------------------------------- //