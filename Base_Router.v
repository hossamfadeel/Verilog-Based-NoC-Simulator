`timescale 1ns / 1ps
//#################################################################################
/*
 Company: 
 AUTHOR(S):  Hossam Fadeel, 	DATE CREATED:	 1/ 7/2013
				 Ahmed Shalaby,	DATE CREATED:	12/11/2011
 
 Create Date:    21:19:26 06/13/2013 
 Design Name: 
 Module Name:     
 Project Name: 
 Target Devices: 
 Tool versions: 
 Description:   This file implements connections between
                different ports and implmement the base router 
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
//#################################################################################
module Base_Router(  clk, reset,
							eastReqUpStr,  eastGntUpStr,  eastUpStrFull,  eastPacketIn,
							eastReqDnStr,  eastGntDnStr,  eastDnStrFull,  eastPacketOut,
							northReqUpStr, northGntUpStr, northUpStrFull, northPacketIn,
							northReqDnStr, northGntDnStr, northDnStrFull, northPacketOut,
							westReqUpStr,  westGntUpStr , westUpStrFull,  westPacketIn,
							westReqDnStr,  westGntDnStr,  westDnStrFull,  westPacketOut,
							southReqUpStr, southGntUpStr, southUpStrFull, southPacketIn,
							southReqDnStr, southGntDnStr, southDnStrFull, southPacketOut,
							localReqUpStr, localGntUpStr, localUpStrFull, localPacketIn,
							localReqDnStr, localGntDnStr, localDnStrFull, localPacketOut      
);
//##################### Parameter Declarations ####################################
parameter routerID     	= 6'b000_000; // Hossam - for 5x5 mesh -- //parameter routerID=4'b0000;  // for 4x4 mesh
parameter routerNo 		= 'd0;
parameter dataWidth 	 	= 32; // number of bits for data bus
parameter addressWidth 	= 1;//4;// number of bits for address bus
parameter fifoDepth 		= ((1 << addressWidth) - 1); // number of entries in fifo buffer
parameter dim 				= 4;// dimension of x,y fields in source and destination  
//######################## Inputs Declarations ###################################
input clk;
input reset;
// Up stream routers requests  
input eastReqUpStr, northReqUpStr, westReqUpStr, southReqUpStr, localReqUpStr;
// indicator for Down stream routers FIFO buffer .. if full = 1 else = 0
input eastDnStrFull,  northDnStrFull, westDnStrFull, southDnStrFull, localDnStrFull ;
// Down stream routers grant 
input eastGntDnStr, northGntDnStr, westGntDnStr, southGntDnStr, localGntDnStr;
// input data Packet to fifo
input [dataWidth-1:0] eastPacketIn, northPacketIn, westPacketIn, southPacketIn, localPacketIn;
//########################## Outputs Declarations #################################
// Down stream routers requests 
output eastReqDnStr, northReqDnStr, westReqDnStr, southReqDnStr, localReqDnStr;  
// indicator for Up stream routers FIFO buffer .. if full = 1 else = 0
output eastUpStrFull, northUpStrFull, westUpStrFull, southUpStrFull, localUpStrFull;
// Up stream routers grant  
output eastGntUpStr, northGntUpStr, westGntUpStr, southGntUpStr, localGntUpStr;
// output data Packet form fifo
output [dataWidth-1:0] eastPacketOut, northPacketOut, westPacketOut, southPacketOut, localPacketOut ;
// --------------------------- Wire Declarations ----------------------------- //
wire clk;
wire reset;
//#######################        Up Stream Part     ############################
// Request from Up stream routers to Down Stream routers
wire eastReqUpStr, northReqUpStr, westReqUpStr, southReqUpStr, localReqUpStr;
// indicator to Up stream routers from Down stream routers FIFO buffer .. if full = 1 else = 0
wire eastDnStrFull,  northDnStrFull, westDnStrFull, southDnStrFull, localDnStrFull ;
// Down stream routers grant 
wire eastGntDnStr, northGntDnStr, westGntDnStr, southGntDnStr, localGntDnStr; 
// output data Packet
wire [dataWidth-1:0] eastPacketOut, northPacketOut, westPacketOut, southPacketOut, localPacketOut ;
//#######################       Down Stream Part     ############################
// Down stream routers requests 
wire eastReqDnStr, northReqDnStr, westReqDnStr, southReqDnStr, localReqDnStr; 
// indicator for Up stream routers FIFO buffer .. if full = 1 else = 0
wire eastUpStrFull, northUpStrFull, westUpStrFull, southUpStrFull, localUpStrFull;
// Up stream routers grant  
wire  eastGntUpStr,  northGntUpStr, westGntUpStr, southGntUpStr, localGntUpStr;
// input data Packet to fifo
wire [dataWidth-1:0] eastPacketIn, northPacketIn, westPacketIn, southPacketIn, localPacketIn;
//#################################################################################################
// communication between input and output controllers for all ports
wire [dataWidth-1:0] eastPacket, northPacket, westPacket, southPacket, localPacket ;
// controll requests and grants between different ports
//Requests
wire  eastReqCntr_l, eastReqCntr_s, eastReqCntr_w, eastReqCntr_n, eastReqCntr_e;
wire  northReqCntr_l, northReqCntr_s, northReqCntr_w, northReqCntr_n, northReqCntr_e;
wire  westReqCntr_l, westReqCntr_s, westReqCntr_w, westReqCntr_n, westReqCntr_e;
wire  southReqCntr_l, southReqCntr_s, southReqCntr_w, southReqCntr_n, southReqCntr_e;
wire  localReqCntr_l, localReqCntr_s, localReqCntr_w, localReqCntr_n, localReqCntr_e;
//Grants
wire eastGntCntr_l, eastGntCntr_s, eastGntCntr_w,eastGntCntr_n, eastGntCntr_e;
wire northGntCntr_l, northGntCntr_s, northGntCntr_w, northGntCntr_n, northGntCntr_e;
wire westGntCntr_l, westGntCntr_s, westGntCntr_w, westGntCntr_n, westGntCntr_e;
wire southGntCntr_l, southGntCntr_s, southGntCntr_w, southGntCntr_n, southGntCntr_e;
wire localGntCntr_l, localGntCntr_s, localGntCntr_w, localGntCntr_n, localGntCntr_e;
//############################  instantiation Devices  ######################################
//#################################    East Port  ###########################################
/* instantiate East Input Controller . */
InputPort  # (.routerNo(routerNo),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim) ) eastInputController
(
.clk(clk),
.reset(reset),
.reqUpStr(eastReqUpStr),  
.gntUpStr(eastGntUpStr), 
//Buffering Status
.full(eastUpStrFull), //Own Buffer
//Packet Depending on Requests
.PacketIn(eastPacketIn),
.reqOutCntr({ eastReqCntr_l, eastReqCntr_s, eastReqCntr_w, eastReqCntr_n, eastReqCntr_e }),//added eastReqCntr_e
.gntOutCntr({ eastGntCntr_l, eastGntCntr_s, eastGntCntr_w, eastGntCntr_n, eastGntCntr_e }), //added eastGntCntr_e
.PacketOut(eastPacket)
);

/* instantiate East Output Controller . */
OutputController # (.routerNo(routerNo),.dataWidth(dataWidth)) eastOutputController
( 
.clk(clk), 
.reset(reset), 
.reqDnStr(eastReqDnStr),
.gntDnStr(eastGntDnStr),   
.full(eastDnStrFull), 
.PacketInPort_4(localPacket), 
.PacketInPort_3(southPacket), 
.PacketInPort_2(westPacket), 
.PacketInPort_1(northPacket),
.PacketInPort_0(eastPacket), 
.reqInCntr({ localReqCntr_e, southReqCntr_e, westReqCntr_e, northReqCntr_e, eastReqCntr_e }), 
.gntInCntr({ localGntCntr_e, southGntCntr_e, westGntCntr_e, northGntCntr_e, eastGntCntr_e }), 
.PacketOut(eastPacketOut) 
);     	

//#################################    North Port  ##########################################
/* instantiate North Input Controller . */
InputPort  # (.routerNo(routerNo),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim) ) northInputController
(
.clk(clk),
.reset(reset),
.reqUpStr(northReqUpStr), 
.gntUpStr(northGntUpStr),
//Buffering Status 
.full(northUpStrFull),  
.PacketIn(northPacketIn), 
.reqOutCntr( {northReqCntr_l, northReqCntr_s, northReqCntr_w, northReqCntr_n, northReqCntr_e}),
.gntOutCntr( {northGntCntr_l, northGntCntr_s, northGntCntr_w, northGntCntr_n, northGntCntr_e}), 
.PacketOut(northPacket)
);

/* instantiate North Output Controller . */
OutputController # (.routerNo(routerNo),.dataWidth(dataWidth)) northOutputController
( 
.clk(clk), 
.reset(reset), 
.reqDnStr(northReqDnStr), 
.gntDnStr(northGntDnStr), 
.full(northDnStrFull), 
.PacketInPort_4(localPacket), 
.PacketInPort_3(southPacket), 
.PacketInPort_2(westPacket), 
.PacketInPort_1(northPacket),
.PacketInPort_0(eastPacket), 
.reqInCntr({ localReqCntr_n, southReqCntr_n, westReqCntr_n, northReqCntr_n, eastReqCntr_n}), 
.gntInCntr({ localGntCntr_n, southGntCntr_n, westGntCntr_n, northGntCntr_n, eastGntCntr_n }),  
.PacketOut(northPacketOut) 
);

//#################################    West Port  ##########################################
/* instantiate West Input Controller . */
InputPort  # (.routerNo(routerNo),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim) ) westInputController
(
.clk(clk),
.reset(reset),
.reqUpStr(westReqUpStr), 
.gntUpStr(westGntUpStr),
//Buffering Status  
.full(westUpStrFull), 
//Packet Depending on Requests
.PacketIn(westPacketIn), 
.reqOutCntr({westReqCntr_l, westReqCntr_s, westReqCntr_w, westReqCntr_n, westReqCntr_e}),
.gntOutCntr({westGntCntr_l, westGntCntr_s, westGntCntr_w, westGntCntr_n, westGntCntr_e}), 
.PacketOut(westPacket)
);

/* instantiate West Output Controller . */                       
OutputController # (.routerNo(routerNo),.dataWidth(dataWidth)) westOutputController
( 
.clk(clk), 
.reset(reset), 
.reqDnStr(westReqDnStr), 
.gntDnStr(westGntDnStr), 
.full(westDnStrFull), 
.PacketInPort_4(localPacket), 
.PacketInPort_3(southPacket), 
.PacketInPort_2(westPacket), 
.PacketInPort_1(northPacket),
.PacketInPort_0(eastPacket), 
.reqInCntr({ localReqCntr_w, southReqCntr_w, westReqCntr_w, northReqCntr_w, eastReqCntr_w }), 
.gntInCntr({ localGntCntr_w, southGntCntr_w, westGntCntr_w, northGntCntr_w, eastGntCntr_w }), 
.PacketOut(westPacketOut) 
);


//#################################    South Port  ##########################################
/* instantiate South Input Controller . */
InputPort  # (.routerNo(routerNo),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim) ) southInputController
(
.clk(clk),
.reset(reset),
.reqUpStr(southReqUpStr),
.gntUpStr(southGntUpStr), 
//Buffering Status  
.full(southUpStrFull), 
.PacketIn(southPacketIn),
.reqOutCntr({southReqCntr_l, southReqCntr_s, southReqCntr_w, southReqCntr_n, southReqCntr_e}),
.gntOutCntr({southGntCntr_l, southGntCntr_s, southGntCntr_w, southGntCntr_n, southGntCntr_e}), 
.PacketOut(southPacket)
);

/* instantiate South Output Controller . */
OutputController # (.routerNo(routerNo),.dataWidth(dataWidth)) southOutputController
( 
.clk(clk), 
.reset(reset), 
.reqDnStr(southReqDnStr),  
.gntDnStr(southGntDnStr), 
.full(southDnStrFull), 
.PacketInPort_4(localPacket), 
.PacketInPort_3(southPacket), 
.PacketInPort_2(westPacket), 
.PacketInPort_1(northPacket),
.PacketInPort_0(eastPacket), 
.reqInCntr({ localReqCntr_s, southReqCntr_s, westReqCntr_s, northReqCntr_s, eastReqCntr_s }), 
.gntInCntr({ localGntCntr_s, southGntCntr_s, westGntCntr_s, northGntCntr_s, eastGntCntr_s }), 
.PacketOut(southPacketOut) 
);

//#################################    Local Port  ##########################################
/* instantiate Local Input Controller . */
InputPort  # (.routerNo(routerNo),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim) ) localInputController
(
.clk(clk),
.reset(reset),
.reqUpStr(localReqUpStr), 
.gntUpStr(localGntUpStr),
.full(localUpStrFull), 
.PacketIn(localPacketIn),
.reqOutCntr({localReqCntr_l, localReqCntr_s, localReqCntr_w, localReqCntr_n, localReqCntr_e}), 
.gntOutCntr({localGntCntr_l, localGntCntr_s, localGntCntr_w, localGntCntr_n, localGntCntr_e}), 
.PacketOut(localPacket) 
);

/* instantiate Local Output Controller . */
OutputController # (.routerNo(routerNo),.dataWidth(dataWidth)) localOutputController
( 
.clk(clk), 
.reset(reset), 
.reqDnStr(localReqDnStr),
.gntDnStr(localGntDnStr),  
.full(localDnStrFull), 
.PacketInPort_4(localPacket), 
.PacketInPort_3(southPacket), 
.PacketInPort_2(westPacket), 
.PacketInPort_1(northPacket),
.PacketInPort_0(eastPacket), 
.reqInCntr({ localReqCntr_l, southReqCntr_l, westReqCntr_l, northReqCntr_l, eastReqCntr_l }), 
.gntInCntr({ localGntCntr_l, southGntCntr_l, westGntCntr_l, northGntCntr_l, eastGntCntr_l }),  
.PacketOut(localPacketOut) 
);

endmodule
//############################## End of File ##########################################