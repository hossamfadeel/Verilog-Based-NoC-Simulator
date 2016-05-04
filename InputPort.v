`timescale 1ns / 1ps
/*
#####################################################################################
 Company: 
 Engineer: 
 
 Create Date:    18:52:19 06/22/2013 
 Design Name: 
 Module Name:    InputPort 
 Project Name: 
 Target Devices: 
 Tool versions: 
 Description: This file implements Input Controller by connection inController
                Unit with fifo

 Dependencies: 

 Revision: 
 Revision 0.01 - File Created
 Additional Comments: 

#####################################################################################
*/

module InputPort ( clk, reset, reqUpStr , gntUpStr , full, PacketIn,
									reqOutCntr, gntOutCntr, PacketOut );
// ------------------------ Parameter Declarations --------------------------- //
parameter routerNo 		= 24; // change depends on mesh size 
parameter dataWidth = 32; // number of bits for data bus
parameter addressWidth = 2;//4;// number of bits for address bus
parameter fifoDepth =  ( ( 1 << addressWidth ) - 1 ); // number of entries in fifo buffer
parameter dim = 2;// dimension of x,y fields in source and destination  
// ------------------------ Inputs Declarations ------------------------------ //
input clk;
input reset; 
input reqUpStr;// Up stream router request 
// grant bus from output controller which grant communication with other routers 
input [4:0] gntOutCntr;
input [dataWidth-1:0] PacketIn;// input data Packet to fifo
// ------------------------ Outputs Declarations ----------------------------- //
output full; // full indication from up stream router
output gntUpStr;// Up stream router grant  
output [dataWidth-1:0] PacketOut;// output data Packet form fifo
/* request bus to output controller which establish connection to other routers
 4 ports + Local Network Inerface
 ports in order ( East(0) - North(1) - West(2) - South(3) - Local(4) ) 
            North (1)
               |
               |
 East(0)---- Local(4) ---- West (2)
               |
               |
             South (3)
 */ 
output [4:0] reqOutCntr;
// --------------------------------------------------------------------------- //
// --------------------------- Wire Declarations ----------------------------- //
wire clk;
wire reset;
wire reqUpStr , gntUpStr;// request & grant  fifo buffer   
// full indication from up stream router
wire full; //shalaby
// grant bus from output controller which grant communication with other routers 
wire [4:0] gntOutCntr;
wire [dataWidth-1:0] PacketIn;// input data Packet from fifo
wire [dataWidth-1:0] PacketOut;// output data Packet to output Controller
// connection between fifo and Input Controller
wire emptyFifoInCntr, reqFifoInCntr, gntFifoInCntr;
wire [dataWidth-1:0] PacketFifoInCntr;
// --------------------------------------------------------------------------- //
// ------------------------ Registers Declarations --------------------------- //
// --------------------------------------------------------------------------- //
// ------------------------  instantiation Devices --------------------------- //
/* instantiate FIFO buffer */
FIFO # (.dataWidth(dataWidth),.addressWidth(addressWidth),
        .fifoDepth(fifoDepth)) fifo
(
.clk(clk),
.reset(reset),
.reqUpStr(reqUpStr),
.gntUpStr(gntUpStr),
.full(full), 
.PacketIn(PacketIn),
.reqInCtr(reqFifoInCntr),
.gntInCtr(gntFifoInCntr),
.empty(emptyFifoInCntr),
.PacketOut(PacketFifoInCntr)
);
// --------------------------------------------------------------------------- //

InputPortController # (.dataWidth(dataWidth),.dim(dim)) InputPortController
(
.clk(clk),
.reset(reset),
.req(reqFifoInCntr),
.gnt(gntFifoInCntr),
.empty(emptyFifoInCntr),
.PacketIn(PacketFifoInCntr),
.reqOutCntr(reqOutCntr),
.gntOutCntr(gntOutCntr),
.PacketOut(PacketOut)
);
// --------------------------------------------------------------------------- //
// ----------------------- Sequential  Logic  -------------------------------- //
// --------------------------------------------------------------------------- //
// ----------------------- Combinational Logic  ------------------------------ //
// --------------------------------------------------------------------------- //
endmodule
// ----------------------------- End of File --------------------------------- //

