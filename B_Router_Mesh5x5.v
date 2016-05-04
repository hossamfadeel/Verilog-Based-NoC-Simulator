`timescale 1ns / 1ps
/*
#####################################################################################
 Company: 
 Engineer: 
 
 Create Date:    23:32:24 07/13/2013 
 Design Name: 
 Module Name:    F_Router_Mesh5x5 
 Project Name: 
 Target Devices: 
 Tool versions: 
 Description: 

 Dependencies: 

 Revision: 
 Revision 0.01 - File Created
 Additional Comments: 

#####################################################################################
*/
module B_Router_Mesh5x5(clk, reset );  
// ------------------------ Parameter Declarations --------------------------- //
parameter routerID 		= 6'b0000; // change depends on mesh size 
parameter routerNo 		= 24; // change depends on mesh size 
parameter ModuleID 	  	= 6'b0000;
parameter dataWidth   	= 32; //// number of bits for data bus
parameter addressWidth	= 3;//4;// number of bits for address bus
parameter fifoDepth 		=  ( ( 1 << addressWidth ) - 1 ); // number of entries in fifo buffer
parameter dim 				= 4;// dimension of x,y fields in source and destination  
// ------------------------ Inputs Declarations ------------------------------ //
input clk;
input reset;
// --------------------------- Wire Declarations ----------------------------- //
wire clk;
wire reset;
//**********************************requests between routers ports *************
// requests from Up Stream routers to Down stream routers  --requests from All routers
//I took it by direction //3 bit for position and 1 bit for direction for each axes
/*  	  x   y		  x   y		  x   y		  x   y	     x   y		  
		-000,000-	-001,000-	-010,000-	-011,000-	-100,000-
			 |				 |				 |				 |				 |				
			 |				 |				 |				 |				 |				 
		-000,001-	-001,001-	-010,001-	-011,001-	-100,001-	
			 |				 |				 |				 |				 |			
			 |				 |				 |				 |				 |			
		-000,010-	-001,010-	-010,010-	-011,010-	-100,010-	
			 |				 |				 |				 |				 |			
			 |				 |				 |				 |				 |			
		-000,011-	-001,011-	-010,011-	-011,011-	-100,011-	
			 |				 |				 |				 |				 |			
			 |				 |				 |				 |				 |			
		-000,100-	-001,100-	-010,100-	-011,100-	-100,100-	
						
*/			
//#######################        Request Signals     ############################			
//east to west																	|| Not Connected ||
wire eastReq_000_000_w, eastReq_001_000_w, eastReq_010_000_w, eastReq_011_000_w, eastReq_100_000_w;
wire eastReq_000_001_w, eastReq_001_001_w, eastReq_010_001_w, eastReq_011_001_w, eastReq_100_001_w;
wire eastReq_000_010_w, eastReq_001_010_w, eastReq_010_010_w, eastReq_011_010_w, eastReq_100_010_w;
wire eastReq_000_011_w, eastReq_001_011_w, eastReq_010_011_w, eastReq_011_011_w, eastReq_100_011_w;
wire eastReq_000_100_w, eastReq_001_100_w, eastReq_010_100_w, eastReq_011_100_w, eastReq_100_100_w;
//north to south
wire northReq_000_000_s, northReq_001_000_s, northReq_010_000_s, northReq_011_000_s, northReq_100_000_s;//Not connected
wire northReq_000_001_s, northReq_001_001_s, northReq_010_001_s, northReq_011_001_s, northReq_100_001_s;
wire northReq_000_010_s, northReq_001_010_s, northReq_010_010_s, northReq_011_010_s, northReq_100_010_s;
wire northReq_000_011_s, northReq_001_011_s, northReq_010_011_s, northReq_011_011_s, northReq_100_011_s;
wire northReq_000_100_s, northReq_001_100_s, northReq_010_100_s, northReq_011_100_s, northReq_100_100_s;
//west to east
wire westReq_000_000_e, westReq_001_000_e, westReq_010_000_e, westReq_011_000_e, westReq_100_000_e;
wire westReq_000_001_e, westReq_001_001_e, westReq_010_001_e, westReq_011_001_e, westReq_100_001_e;
wire westReq_000_010_e, westReq_001_010_e, westReq_010_010_e, westReq_011_010_e, westReq_100_010_e;
wire westReq_000_011_e, westReq_001_011_e, westReq_010_011_e, westReq_011_011_e, westReq_100_011_e;
wire westReq_000_100_e, westReq_001_100_e, westReq_010_100_e, westReq_011_100_e, westReq_100_100_e;
//south to north
wire southReq_000_000_n, southReq_001_000_n, southReq_010_000_n, southReq_011_000_n, southReq_100_000_n;
wire southReq_000_001_n, southReq_001_001_n, southReq_010_001_n, southReq_011_001_n, southReq_100_001_n;
wire southReq_000_010_n, southReq_001_010_n, southReq_010_010_n, southReq_011_010_n, southReq_100_010_n;
wire southReq_000_011_n, southReq_001_011_n, southReq_010_011_n, southReq_011_011_n, southReq_100_011_n;
wire southReq_000_100_n, southReq_001_100_n, southReq_010_100_n, southReq_011_100_n, southReq_100_100_n;
//Local UpStr
wire  localReqUpStr_000_000, localReqUpStr_001_000,localReqUpStr_010_000,localReqUpStr_011_000,
		localReqUpStr_100_000;
wire  localReqUpStr_000_001, localReqUpStr_001_001,localReqUpStr_010_001,localReqUpStr_011_001,
		localReqUpStr_100_001;
wire  localReqUpStr_000_010, localReqUpStr_001_010,localReqUpStr_010_010,localReqUpStr_011_010,
		localReqUpStr_100_010;		
wire  localReqUpStr_000_011, localReqUpStr_001_011,localReqUpStr_010_011,localReqUpStr_011_011,
		localReqUpStr_100_011;
wire  localReqUpStr_000_100, localReqUpStr_001_100,localReqUpStr_010_100,localReqUpStr_011_100,
		localReqUpStr_100_100;
//Local DnStr
wire  localReqDnStr_000_000, localReqDnStr_001_000,localReqDnStr_010_000,localReqDnStr_011_000,
		localReqDnStr_100_000;
wire  localReqDnStr_000_001, localReqDnStr_001_001,localReqDnStr_010_001,localReqDnStr_011_001,
		localReqDnStr_100_001;
wire  localReqDnStr_000_010, localReqDnStr_001_010,localReqDnStr_010_010,localReqDnStr_011_010,
		localReqDnStr_100_010;		
wire  localReqDnStr_000_011, localReqDnStr_001_011,localReqDnStr_010_011,localReqDnStr_011_011,
		localReqDnStr_100_011;
wire  localReqDnStr_000_100, localReqDnStr_001_100,localReqDnStr_010_100,localReqDnStr_011_100,
		localReqDnStr_100_100;
//#######################        Grant Signals     ############################
//east to west
wire eastGnt_000_000_w, eastGnt_001_000_w, eastGnt_010_000_w, eastGnt_011_000_w, eastGnt_100_000_w;
wire eastGnt_000_001_w, eastGnt_001_001_w, eastGnt_010_001_w, eastGnt_011_001_w, eastGnt_100_001_w;
wire eastGnt_000_010_w, eastGnt_001_010_w, eastGnt_010_010_w, eastGnt_011_010_w, eastGnt_100_010_w;
wire eastGnt_000_011_w, eastGnt_001_011_w, eastGnt_010_011_w, eastGnt_011_011_w, eastGnt_100_011_w;
wire eastGnt_000_100_w, eastGnt_001_100_w, eastGnt_010_100_w, eastGnt_011_100_w, eastGnt_100_100_w;
//north to south
wire northGnt_000_000_s, northGnt_001_000_s, northGnt_010_000_s, northGnt_011_000_s, northGnt_100_000_s;
wire northGnt_000_001_s, northGnt_001_001_s, northGnt_010_001_s, northGnt_011_001_s, northGnt_100_001_s;
wire northGnt_000_010_s, northGnt_001_010_s, northGnt_010_010_s, northGnt_011_010_s, northGnt_100_010_s;
wire northGnt_000_011_s, northGnt_001_011_s, northGnt_010_011_s, northGnt_011_011_s, northGnt_100_011_s;
wire northGnt_000_100_s, northGnt_001_100_s, northGnt_010_100_s, northGnt_011_100_s, northGnt_100_100_s;
//west to east
wire westGnt_000_000_e, westGnt_001_000_e, westGnt_010_000_e, westGnt_011_000_e, westGnt_100_000_e;
wire westGnt_000_001_e, westGnt_001_001_e, westGnt_010_001_e, westGnt_011_001_e, westGnt_100_001_e;
wire westGnt_000_010_e, westGnt_001_010_e, westGnt_010_010_e, westGnt_011_010_e, westGnt_100_010_e;
wire westGnt_000_011_e, westGnt_001_011_e, westGnt_010_011_e, westGnt_011_011_e, westGnt_100_011_e;
wire westGnt_000_100_e, westGnt_001_100_e, westGnt_010_100_e, westGnt_011_100_e, westGnt_100_100_e;
//south to north
wire southGnt_000_000_n, southGnt_001_000_n, southGnt_010_000_n, southGnt_011_000_n, southGnt_100_000_n;
wire southGnt_000_001_n, southGnt_001_001_n, southGnt_010_001_n, southGnt_011_001_n, southGnt_100_001_n;
wire southGnt_000_010_n, southGnt_001_010_n, southGnt_010_010_n, southGnt_011_010_n, southGnt_100_010_n;
wire southGnt_000_011_n, southGnt_001_011_n, southGnt_010_011_n, southGnt_011_011_n, southGnt_100_011_n;
wire southGnt_000_100_n, southGnt_001_100_n, southGnt_010_100_n, southGnt_011_100_n, southGnt_100_100_n;
//Local UpStr
wire  localGntUpStr_000_000, localGntUpStr_001_000,localGntUpStr_010_000,localGntUpStr_011_000,
		localGntUpStr_100_000;
wire  localGntUpStr_000_001, localGntUpStr_001_001,localGntUpStr_010_001,localGntUpStr_011_001,
		localGntUpStr_100_001;
wire  localGntUpStr_000_010, localGntUpStr_001_010,localGntUpStr_010_010,localGntUpStr_011_010,
		localGntUpStr_100_010;		
wire  localGntUpStr_000_011, localGntUpStr_001_011,localGntUpStr_010_011,localGntUpStr_011_011,
		localGntUpStr_100_011;
wire  localGntUpStr_000_100, localGntUpStr_001_100,localGntUpStr_010_100,localGntUpStr_011_100,
		localGntUpStr_100_100;
//Local  DnStr
wire  localGntDnStr_000_000, localGntDnStr_001_000,localGntDnStr_010_000,localGntDnStr_011_000,
		localGntDnStr_100_000;
wire  localGntDnStr_000_001, localGntDnStr_001_001,localGntDnStr_010_001,localGntDnStr_011_001,
		localGntDnStr_100_001;
wire  localGntDnStr_000_010, localGntDnStr_001_010,localGntDnStr_010_010,localGntDnStr_011_010,
		localGntDnStr_100_010;		
wire  localGntDnStr_000_011, localGntDnStr_001_011,localGntDnStr_010_011,localGntDnStr_011_011,
		localGntDnStr_100_011;
wire  localGntDnStr_000_100, localGntDnStr_001_100,localGntDnStr_010_100,localGntDnStr_011_100,
		localGntDnStr_100_100;
//#######################        Full Signals     ###############################
//east to west
wire eastFull_000_000_w, eastFull_001_000_w, eastFull_010_000_w, eastFull_011_000_w, eastFull_100_000_w;
wire eastFull_000_001_w, eastFull_001_001_w, eastFull_010_001_w, eastFull_011_001_w, eastFull_100_001_w;
wire eastFull_000_010_w, eastFull_001_010_w, eastFull_010_010_w, eastFull_011_010_w, eastFull_100_010_w;
wire eastFull_000_011_w, eastFull_001_011_w, eastFull_010_011_w, eastFull_011_011_w, eastFull_100_011_w;
wire eastFull_000_100_w, eastFull_001_100_w, eastFull_010_100_w, eastFull_011_100_w, eastFull_100_100_w;
//north to south
wire northFull_000_000_s, northFull_001_000_s, northFull_010_000_s, northFull_011_000_s, northFull_100_000_s;
wire northFull_000_001_s, northFull_001_001_s, northFull_010_001_s, northFull_011_001_s, northFull_100_001_s;
wire northFull_000_010_s, northFull_001_010_s, northFull_010_010_s, northFull_011_010_s, northFull_100_010_s;
wire northFull_000_011_s, northFull_001_011_s, northFull_010_011_s, northFull_011_011_s, northFull_100_011_s;
wire northFull_000_100_s, northFull_001_100_s, northFull_010_100_s, northFull_011_100_s, northFull_100_100_s;
//west to east
wire westFull_000_000_e, westFull_001_000_e, westFull_010_000_e, westFull_011_000_e, westFull_100_000_e;
wire westFull_000_001_e, westFull_001_001_e, westFull_010_001_e, westFull_011_001_e, westFull_100_001_e;
wire westFull_000_010_e, westFull_001_010_e, westFull_010_010_e, westFull_011_010_e, westFull_100_010_e;
wire westFull_000_011_e, westFull_001_011_e, westFull_010_011_e, westFull_011_011_e, westFull_100_011_e;
wire westFull_000_100_e, westFull_001_100_e, westFull_010_100_e, westFull_011_100_e, westFull_100_100_e;
//south to north
wire southFull_000_000_n, southFull_001_000_n, southFull_010_000_n, southFull_011_000_n, southFull_100_000_n;
wire southFull_000_001_n, southFull_001_001_n, southFull_010_001_n, southFull_011_001_n, southFull_100_001_n;
wire southFull_000_010_n, southFull_001_010_n, southFull_010_010_n, southFull_011_010_n, southFull_100_010_n;
wire southFull_000_011_n, southFull_001_011_n, southFull_010_011_n, southFull_011_011_n, southFull_100_011_n;
wire southFull_000_100_n, southFull_001_100_n, southFull_010_100_n, southFull_011_100_n, southFull_100_100_n;

//Local UpStr
wire  localUpStrFull_000_000, localUpStrFull_001_000,localUpStrFull_010_000,localUpStrFull_011_000,
		localUpStrFull_100_000;
wire  localUpStrFull_000_001, localUpStrFull_001_001,localUpStrFull_010_001,localUpStrFull_011_001,
		localUpStrFull_100_001;
wire  localUpStrFull_000_010, localUpStrFull_001_010,localUpStrFull_010_010,localUpStrFull_011_010,
		localUpStrFull_100_010;		
wire  localUpStrFull_000_011, localUpStrFull_001_011,localUpStrFull_010_011,localUpStrFull_011_011,
		localUpStrFull_100_011;
wire  localUpStrFull_000_100, localUpStrFull_001_100,localUpStrFull_010_100,localUpStrFull_011_100,
		localUpStrFull_100_100;
//Local  DnStr
wire  localDnStrFull_000_000, localDnStrFull_001_000,localDnStrFull_010_000,localDnStrFull_011_000,
		localDnStrFull_100_000;
wire  localDnStrFull_000_001, localDnStrFull_001_001,localDnStrFull_010_001,localDnStrFull_011_001,
		localDnStrFull_100_001;
wire  localDnStrFull_000_010, localDnStrFull_001_010,localDnStrFull_010_010,localDnStrFull_011_010,
		localDnStrFull_100_010;		
wire  localDnStrFull_000_011, localDnStrFull_001_011,localDnStrFull_010_011,localDnStrFull_011_011,
		localDnStrFull_100_011;
wire  localDnStrFull_000_100, localDnStrFull_001_100,localDnStrFull_010_100,localDnStrFull_011_100,
		localDnStrFull_100_100;
//####################### Packets between ports   ###############################
//east to west
wire [dataWidth-1:0] eastPacket_000_000_w, eastPacket_001_000_w, eastPacket_010_000_w, 
							eastPacket_011_000_w, eastPacket_100_000_w;
wire [dataWidth-1:0] eastPacket_000_001_w, eastPacket_001_001_w, eastPacket_010_001_w, 
							eastPacket_011_001_w, eastPacket_100_001_w;
wire [dataWidth-1:0] eastPacket_000_010_w, eastPacket_001_010_w, eastPacket_010_010_w, 
							eastPacket_011_010_w, eastPacket_100_010_w;
wire [dataWidth-1:0] eastPacket_000_011_w, eastPacket_001_011_w, eastPacket_010_011_w, 
							eastPacket_011_011_w, eastPacket_100_011_w;
wire [dataWidth-1:0] eastPacket_000_100_w, eastPacket_001_100_w, eastPacket_010_100_w, 
							eastPacket_011_100_w, eastPacket_100_100_w;
//north to south
wire [dataWidth-1:0] northPacket_000_000_s, northPacket_001_000_s, northPacket_010_000_s, 
							northPacket_011_000_s, northPacket_100_000_s;
wire [dataWidth-1:0] northPacket_000_001_s, northPacket_001_001_s, northPacket_010_001_s, 
							northPacket_011_001_s, northPacket_100_001_s;
wire [dataWidth-1:0] northPacket_000_010_s, northPacket_001_010_s, northPacket_010_010_s, 
							northPacket_011_010_s, northPacket_100_010_s;
wire [dataWidth-1:0] northPacket_000_011_s, northPacket_001_011_s, northPacket_010_011_s, 
							northPacket_011_011_s, northPacket_100_011_s;
wire [dataWidth-1:0] northPacket_000_100_s, northPacket_001_100_s, northPacket_010_100_s, 
							northPacket_011_100_s, northPacket_100_100_s;
//west to east
wire [dataWidth-1:0] westPacket_000_000_e, westPacket_001_000_e, westPacket_010_000_e, 
							westPacket_011_000_e, westPacket_100_000_e;
wire [dataWidth-1:0] westPacket_000_001_e, westPacket_001_001_e, westPacket_010_001_e, 
							westPacket_011_001_e, westPacket_100_001_e;
wire [dataWidth-1:0] westPacket_000_010_e, westPacket_001_010_e, westPacket_010_010_e, 
							westPacket_011_010_e, westPacket_100_010_e;
wire [dataWidth-1:0] westPacket_000_011_e, westPacket_001_011_e, westPacket_010_011_e, 
							westPacket_011_011_e, westPacket_100_011_e;
wire [dataWidth-1:0] westPacket_000_100_e, westPacket_001_100_e, westPacket_010_100_e, 
							westPacket_011_100_e, westPacket_100_100_e;
//south to north
wire [dataWidth-1:0] southPacket_000_000_n, southPacket_001_000_n, southPacket_010_000_n, 
							southPacket_011_000_n, southPacket_100_000_n;
wire [dataWidth-1:0] southPacket_000_001_n, southPacket_001_001_n, southPacket_010_001_n, 
							southPacket_011_001_n, southPacket_100_001_n;
wire [dataWidth-1:0] southPacket_000_010_n, southPacket_001_010_n, southPacket_010_010_n, 
							southPacket_011_010_n, southPacket_100_010_n;
wire [dataWidth-1:0] southPacket_000_011_n, southPacket_001_011_n, southPacket_010_011_n, 
							southPacket_011_011_n, southPacket_100_011_n;
wire [dataWidth-1:0] southPacket_000_100_n, southPacket_001_100_n, southPacket_010_100_n, 
							southPacket_011_100_n, southPacket_100_100_n;
//Local localPacketIn
wire [dataWidth-1:0] localPacketIn_000_000, localPacketIn_001_000,localPacketIn_010_000,
							localPacketIn_011_000, localPacketIn_100_000;
wire [dataWidth-1:0] localPacketIn_000_001, localPacketIn_001_001,localPacketIn_010_001,
							localPacketIn_011_001, localPacketIn_100_001;
wire [dataWidth-1:0] localPacketIn_000_010, localPacketIn_001_010,localPacketIn_010_010,
							localPacketIn_011_010, localPacketIn_100_010;		
wire [dataWidth-1:0] localPacketIn_000_011, localPacketIn_001_011,localPacketIn_010_011,
							localPacketIn_011_011, localPacketIn_100_011;
wire [dataWidth-1:0] localPacketIn_000_100, localPacketIn_001_100,localPacketIn_010_100,
							localPacketIn_011_100, localPacketIn_100_100;
//Local  localPacketOut
wire [dataWidth-1:0] localPacketOut_000_000, localPacketOut_001_000,localPacketOut_010_000,
							localPacketOut_011_000, localPacketOut_100_000;
wire [dataWidth-1:0] localPacketOut_000_001, localPacketOut_001_001,localPacketOut_010_001,
							localPacketOut_011_001, localPacketOut_100_001;
wire [dataWidth-1:0] localPacketOut_000_010, localPacketOut_001_010,localPacketOut_010_010,
							localPacketOut_011_010, localPacketOut_100_010;		
wire [dataWidth-1:0] localPacketOut_000_011, localPacketOut_001_011,localPacketOut_010_011,
							localPacketOut_011_011, localPacketOut_100_011;
wire [dataWidth-1:0] localPacketOut_000_100, localPacketOut_001_100,localPacketOut_010_100,
							localPacketOut_011_100, localPacketOut_100_100;

/*
#########################################################################################
#########################################################################################
connect packets and signals of each router for communication between input and output   #
Ports in Network 																								 #
#########################################################################################
#########################################################################################
###########################                             #################################
###########################     Routers Intantiation    #################################
###########################                             #################################
#########################################################################################
#########################################################################################
###########################        First row       ######################################
#########################################################################################
####################### Instantiate of Router 000_000 ###################################
#########################################################################################
*/
 Base_Router # (.routerNo(0),.routerID(6'b000_000),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_000_000
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_001_000_e), 
 .eastGntUpStr(eastGnt_000_000_w), 
 .eastUpStrFull(eastFull_000_000_w), 
 .eastPacketIn(westPacket_001_000_e),
 .eastReqDnStr(eastReq_000_000_w), 
 .eastGntDnStr(westGnt_001_000_e),
 .eastDnStrFull(westFull_001_000_e),  
 .eastPacketOut(eastPacket_000_000_w),
 //******************************
 .northReqUpStr(1'b0), 
 .northUpStrFull(),
 .northGntUpStr(),
 .northPacketIn(0),
 .northReqDnStr(), 
 .northDnStrFull(1'b0),
 .northGntDnStr(1'b0), 
 .northPacketOut(),
 //******************************
 .westReqUpStr(1'b0),  
 .westUpStrFull(),
 .westGntUpStr(), 
 .westPacketIn(0),
 .westReqDnStr(),  
 .westDnStrFull(1'b0),
 .westGntDnStr(1'b0), 
 .westPacketOut(),
 //******************************
 .southReqUpStr(northReq_000_001_s), 
 .southGntUpStr(southGnt_000_000_n), 
 .southUpStrFull(southFull_000_000_n),
 .southPacketIn(northPacket_000_001_s),
 .southReqDnStr(southReq_000_000_n),
 .southGntDnStr(northGnt_000_001_s), 
 .southDnStrFull(northFull_000_001_s), 
 .southPacketOut(southPacket_000_000_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_000_000), 
 .localGntUpStr(localGntUpStr_000_000), 
 .localUpStrFull(localUpStrFull_000_000),
 .localPacketIn(localPacketIn_000_000),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_000_000), 
 .localDnStrFull(localDnStrFull_000_000), 
 .localGntDnStr(localGntDnStr_000_000), 
 .localPacketOut(localPacketOut_000_000)
); 
//######################################################################################
//####################### Instantiate of Router 001_000 ################################
//######################################################################################
 Base_Router # (.routerNo(1),.routerID(6'b001_000),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_001_000
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_010_000_e), 
 .eastGntUpStr(eastGnt_001_000_w), 
 .eastUpStrFull(eastFull_001_000_w), 
 .eastPacketIn(westPacket_010_000_e),
 .eastReqDnStr(eastReq_001_000_w), 
 .eastGntDnStr(westGnt_010_000_e),
 .eastDnStrFull(westFull_010_000_e),  
 .eastPacketOut(eastPacket_001_000_w),
 //******************************
 .northReqUpStr(1'b0), 
 .northUpStrFull(),
 .northGntUpStr(),
 .northPacketIn(0),
 .northReqDnStr(), 
 .northDnStrFull(1'b0),
 .northGntDnStr(1'b0), 
 .northPacketOut(),
 //******************************
 .westReqUpStr(eastReq_000_000_w),  
 .westGntUpStr(westGnt_001_000_e),
 .westUpStrFull(westFull_001_000_e),  
 .westPacketIn(eastPacket_000_000_w),
 .westReqDnStr(westReq_001_000_e),  
 .westGntDnStr(eastGnt_000_000_w), 
 .westDnStrFull(eastFull_000_000_w),
 .westPacketOut(westPacket_001_000_e),
 //******************************
 .southReqUpStr(northReq_001_001_s), 
 .southGntUpStr(southGnt_001_000_n), 
 .southUpStrFull(southFull_001_000_n),
 .southPacketIn(northPacket_001_001_s),
 .southReqDnStr(southReq_001_000_n),
 .southGntDnStr(northGnt_001_001_s), 
 .southDnStrFull(northFull_001_001_s), 
 .southPacketOut(southPacket_001_000_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_001_000), 
 .localGntUpStr(localGntUpStr_001_000), 
 .localUpStrFull(localUpStrFull_001_000),
 .localPacketIn(localPacketIn_001_000),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_001_000), 
 .localDnStrFull(localDnStrFull_001_000), 
 .localGntDnStr(localGntDnStr_001_000), 
 .localPacketOut(localPacketOut_001_000)
); 
//######################################################################################
//####################### Instantiate of Router 010_000 ################################
//######################################################################################
 Base_Router # (.routerNo(2),.routerID(6'b010_000),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_010_000
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_011_000_e), 
 .eastGntUpStr(eastGnt_010_000_w), 
 .eastUpStrFull(eastFull_010_000_w), 
 .eastPacketIn(westPacket_011_000_e),
 .eastReqDnStr(eastReq_010_000_w), 
 .eastGntDnStr(westGnt_011_000_e),
 .eastDnStrFull(westFull_011_000_e),  
 .eastPacketOut(eastPacket_010_000_w),
 //******************************
 .northReqUpStr(1'b0), 
 .northUpStrFull(),
 .northGntUpStr(),
 .northPacketIn(0),
 .northReqDnStr(), 
 .northDnStrFull(1'b0),
 .northGntDnStr(1'b0), 
 .northPacketOut(),
 //******************************
 .westReqUpStr(eastReq_001_000_w),  
 .westGntUpStr(westGnt_010_000_e),
 .westUpStrFull(westFull_010_000_e),  
 .westPacketIn(eastPacket_001_000_w),
 .westReqDnStr(westReq_010_000_e),  
 .westGntDnStr(eastGnt_001_000_w), 
 .westDnStrFull(eastFull_001_000_w),
 .westPacketOut(westPacket_010_000_e),
 //******************************
 .southReqUpStr(northReq_010_001_s), 
 .southGntUpStr(southGnt_010_000_n), 
 .southUpStrFull(southFull_010_000_n),
 .southPacketIn(northPacket_010_001_s),
 .southReqDnStr(southReq_010_000_n),
 .southGntDnStr(northGnt_010_001_s), 
 .southDnStrFull(northFull_010_001_s), 
 .southPacketOut(southPacket_010_000_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_010_000), 
 .localGntUpStr(localGntUpStr_010_000), 
 .localUpStrFull(localUpStrFull_010_000),
 .localPacketIn(localPacketIn_010_000),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_010_000), 
 .localDnStrFull(localDnStrFull_010_000), 
 .localGntDnStr(localGntDnStr_010_000), 
 .localPacketOut(localPacketOut_010_000)
); 
//######################################################################################
//####################### Instantiate of Router 011_000 ################################
//######################################################################################
 Base_Router # (.routerNo(3),.routerID(6'b011_000),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_011_000
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_100_000_e), 
 .eastGntUpStr(eastGnt_011_000_w), 
 .eastUpStrFull(eastFull_011_000_w), 
 .eastPacketIn(westPacket_100_000_e),
 .eastReqDnStr(eastReq_011_000_w), 
 .eastGntDnStr(westGnt_100_000_e),
 .eastDnStrFull(westFull_100_000_e),  
 .eastPacketOut(eastPacket_011_000_w),
 //******************************
 .northReqUpStr(1'b0), 
 .northUpStrFull(),
 .northGntUpStr(),
 .northPacketIn(0),
 .northReqDnStr(), 
 .northDnStrFull(1'b0),
 .northGntDnStr(1'b0), 
 .northPacketOut(),
 //******************************
 .westReqUpStr(eastReq_010_000_w),  
 .westGntUpStr(westGnt_011_000_e),
 .westUpStrFull(westFull_011_000_e),  
 .westPacketIn(eastPacket_010_000_w),
 .westReqDnStr(westReq_011_000_e),  
 .westGntDnStr(eastGnt_010_000_w), 
 .westDnStrFull(eastFull_010_000_w),
 .westPacketOut(westPacket_011_000_e),
 //******************************
 .southReqUpStr(northReq_011_001_s), 
 .southGntUpStr(southGnt_011_000_n), 
 .southUpStrFull(southFull_011_000_n),
 .southPacketIn(northPacket_011_001_s),
 .southReqDnStr(southReq_011_000_n),
 .southGntDnStr(northGnt_011_001_s), 
 .southDnStrFull(northFull_011_001_s), 
 .southPacketOut(southPacket_011_000_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_011_000), 
 .localGntUpStr(localGntUpStr_011_000), 
 .localUpStrFull(localUpStrFull_011_000),
 .localPacketIn(localPacketIn_011_000),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_011_000), 
 .localDnStrFull(localDnStrFull_011_000), 
 .localGntDnStr(localGntDnStr_011_000), 
 .localPacketOut(localPacketOut_011_000)
); 
//######################################################################################
//####################### Instantiate of Router 100_000 ################################
//######################################################################################
 Base_Router # (.routerNo(4),.routerID(6'b100_000),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_100_000
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(1'b0), 
 .eastGntUpStr(), 
 .eastUpStrFull(), 
 .eastPacketIn(0),
 .eastReqDnStr(), 
 .eastGntDnStr(1'b0),
 .eastDnStrFull(1'b0),  
 .eastPacketOut(),
 //******************************
 .northReqUpStr(1'b0), 
 .northUpStrFull(),
 .northGntUpStr(),
 .northPacketIn(0),
 .northReqDnStr(), 
 .northDnStrFull(1'b0),
 .northGntDnStr(1'b0), 
 .northPacketOut(),
 //******************************
 .westReqUpStr(eastReq_011_000_w),  
 .westGntUpStr(westGnt_100_000_e),
 .westUpStrFull(westFull_100_000_e),  
 .westPacketIn(eastPacket_011_000_w),
 .westReqDnStr(westReq_100_000_e),  
 .westGntDnStr(eastGnt_011_000_w), 
 .westDnStrFull(eastFull_011_000_w),
 .westPacketOut(westPacket_100_000_e),
 //******************************
 .southReqUpStr(northReq_100_001_s), 
 .southGntUpStr(southGnt_100_000_n), 
 .southUpStrFull(southFull_100_000_n),
 .southPacketIn(northPacket_100_001_s),
 .southReqDnStr(southReq_100_000_n),
 .southGntDnStr(northGnt_100_001_s), 
 .southDnStrFull(northFull_100_001_s), 
 .southPacketOut(southPacket_100_000_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_100_000), 
 .localGntUpStr(localGntUpStr_100_000), 
 .localUpStrFull(localUpStrFull_100_000),
 .localPacketIn(localPacketIn_100_000),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_100_000), 
 .localDnStrFull(localDnStrFull_100_000), 
 .localGntDnStr(localGntDnStr_100_000), 
 .localPacketOut(localPacketOut_100_000)
); 
//######################################################################################
//######################################################################################
//##########################        Second row        ##################################
//######################################################################################
//######################################################################################
//####################### Instantiate of Router 000_001 ################################
//######################################################################################
 Base_Router # (.routerNo(5),.routerID(6'b000_001),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_000_001
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_001_001_e), 
 .eastGntUpStr(eastGnt_000_001_w), 
 .eastUpStrFull(eastFull_000_001_w), 
 .eastPacketIn(westPacket_001_001_e),
 .eastReqDnStr(eastReq_000_001_w), 
 .eastGntDnStr(westGnt_001_001_e),
 .eastDnStrFull(westFull_001_001_e),  
 .eastPacketOut(eastPacket_000_001_w),
 //******************************
 .northReqUpStr(southReq_000_000_n), 
 .northUpStrFull(northFull_000_001_s),
 .northGntUpStr(northGnt_000_001_s),
 .northPacketIn(southPacket_000_000_n),
 .northReqDnStr(northReq_000_001_s), 
 .northDnStrFull(southFull_000_000_n),
 .northGntDnStr(southGnt_000_000_n), 
 .northPacketOut(northPacket_000_001_s),
 //******************************
 .westReqUpStr(1'b0),  
 .westUpStrFull(),
 .westGntUpStr(), 
 .westPacketIn(0),
 .westReqDnStr(),  
 .westDnStrFull(1'b0),
 .westGntDnStr(1'b0), 
 .westPacketOut(),
 //******************************
 .southReqUpStr(northReq_000_010_s), 
 .southGntUpStr(southGnt_000_001_n), 
 .southUpStrFull(southFull_000_001_n),
 .southPacketIn(northPacket_000_010_s),
 .southReqDnStr(southReq_000_001_n),
 .southGntDnStr(northGnt_000_010_s), 
 .southDnStrFull(northFull_000_010_s), 
 .southPacketOut(southPacket_000_001_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_000_001), 
 .localGntUpStr(localGntUpStr_000_001), 
 .localUpStrFull(localUpStrFull_000_001),
 .localPacketIn(localPacketIn_000_001),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_000_001), 
 .localDnStrFull(localDnStrFull_000_001), 
 .localGntDnStr(localGntDnStr_000_001), 
 .localPacketOut(localPacketOut_000_001)
); 
//######################################################################################
//####################### Instantiate of Router 001_001 ################################
//######################################################################################
 Base_Router # (.routerNo(6),.routerID(6'b001_001),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_001_001
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_010_001_e), 
 .eastGntUpStr(eastGnt_001_001_w), 
 .eastUpStrFull(eastFull_001_001_w), 
 .eastPacketIn(westPacket_010_001_e),
 .eastReqDnStr(eastReq_001_001_w), 
 .eastGntDnStr(westGnt_010_001_e),
 .eastDnStrFull(westFull_010_001_e),  
 .eastPacketOut(eastPacket_001_001_w),
 //******************************
 .northReqUpStr(southReq_001_000_n), 
 .northUpStrFull(northFull_001_001_s),
 .northGntUpStr(northGnt_001_001_s),
 .northPacketIn(southPacket_001_000_n),
 .northReqDnStr(northReq_001_001_s), 
 .northDnStrFull(southFull_001_000_n),
 .northGntDnStr(southGnt_001_000_n), 
 .northPacketOut(northPacket_001_001_s),
 //******************************
 
 .westReqUpStr(eastReq_000_001_w),  
 .westGntUpStr(westGnt_001_001_e),
 .westUpStrFull(westFull_001_001_e),  
 .westPacketIn(eastPacket_000_001_w),
 .westReqDnStr(westReq_001_001_e),  
 .westGntDnStr(eastGnt_000_001_w), 
 .westDnStrFull(eastFull_000_001_w),
 .westPacketOut(westPacket_001_001_e),
 //******************************
 .southReqUpStr(northReq_001_010_s), 
 .southGntUpStr(southGnt_001_001_n), 
 .southUpStrFull(southFull_001_001_n),
 .southPacketIn(northPacket_001_010_s),
 .southReqDnStr(southReq_001_001_n),
 .southGntDnStr(northGnt_001_010_s), 
 .southDnStrFull(northFull_001_010_s), 
 .southPacketOut(southPacket_001_001_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_001_001), 
 .localGntUpStr(localGntUpStr_001_001), 
 .localUpStrFull(localUpStrFull_001_001),
 .localPacketIn(localPacketIn_001_001),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_001_001), 
 .localDnStrFull(localDnStrFull_001_001), 
 .localGntDnStr(localGntDnStr_001_001), 
 .localPacketOut(localPacketOut_001_001)
); 
//######################################################################################
//####################### Instantiate of Router 010_001 ################################
//######################################################################################
 Base_Router # (.routerNo(7),.routerID(6'b010_001),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_010_001
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_011_001_e), 
 .eastGntUpStr(eastGnt_010_001_w), 
 .eastUpStrFull(eastFull_010_001_w), 
 .eastPacketIn(westPacket_011_001_e),
 .eastReqDnStr(eastReq_010_001_w), 
 .eastGntDnStr(westGnt_011_001_e),
 .eastDnStrFull(westFull_011_001_e),  
 .eastPacketOut(eastPacket_010_001_w),
 //******************************
 .northReqUpStr(southReq_010_000_n), 
 .northUpStrFull(northFull_010_001_s),
 .northGntUpStr(northGnt_010_001_s),
 .northPacketIn(southPacket_010_000_n),
 .northReqDnStr(northReq_010_001_s), 
 .northDnStrFull(southFull_010_000_n),
 .northGntDnStr(southGnt_010_000_n), 
 .northPacketOut(northPacket_010_001_s),
 //******************************
 .westReqUpStr(eastReq_001_001_w),  
 .westGntUpStr(westGnt_010_001_e),
 .westUpStrFull(westFull_010_001_e),  
 .westPacketIn(eastPacket_001_001_w),
 .westReqDnStr(westReq_010_001_e),  
 .westGntDnStr(eastGnt_001_001_w), 
 .westDnStrFull(eastFull_001_001_w),
 .westPacketOut(westPacket_010_001_e),
 //******************************
 .southReqUpStr(northReq_010_010_s), 
 .southGntUpStr(southGnt_010_001_n), 
 .southUpStrFull(southFull_010_001_n),
 .southPacketIn(northPacket_010_010_s),
 .southReqDnStr(southReq_010_001_n),
 .southGntDnStr(northGnt_010_010_s), 
 .southDnStrFull(northFull_010_010_s), 
 .southPacketOut(southPacket_010_001_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_010_001), 
 .localGntUpStr(localGntUpStr_010_001), 
 .localUpStrFull(localUpStrFull_010_001),
 .localPacketIn(localPacketIn_010_001),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_010_001), 
 .localDnStrFull(localDnStrFull_010_001), 
 .localGntDnStr(localGntDnStr_010_001), 
 .localPacketOut(localPacketOut_010_001)
); 
//######################################################################################
//####################### Instantiate of Router 011_001 ################################
//######################################################################################
 Base_Router # (.routerNo(8),.routerID(6'b011_001),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_011_001
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_100_001_e), 
 .eastGntUpStr(eastGnt_011_001_w), 
 .eastUpStrFull(eastFull_011_001_w), 
 .eastPacketIn(westPacket_100_001_e),
 .eastReqDnStr(eastReq_011_001_w), 
 .eastGntDnStr(westGnt_100_001_e),
 .eastDnStrFull(westFull_100_001_e),  
 .eastPacketOut(eastPacket_011_001_w),
 //******************************
 .northReqUpStr(southReq_011_000_n), 
 .northUpStrFull(northFull_011_001_s),
 .northGntUpStr(northGnt_011_001_s),
 .northPacketIn(southPacket_011_000_n),
 .northReqDnStr(northReq_011_001_s), 
 .northDnStrFull(southFull_011_000_n),
 .northGntDnStr(southGnt_011_000_n), 
 .northPacketOut(northPacket_011_001_s),
 //******************************
 
 .westReqUpStr(eastReq_010_001_w),  
 .westGntUpStr(westGnt_011_001_e),
 .westUpStrFull(westFull_011_001_e),  
 .westPacketIn(eastPacket_010_001_w),
 .westReqDnStr(westReq_011_001_e),  
 .westGntDnStr(eastGnt_010_001_w), 
 .westDnStrFull(eastFull_010_001_w),
 .westPacketOut(westPacket_011_001_e),
 //******************************
 .southReqUpStr(northReq_011_010_s), 
 .southGntUpStr(southGnt_011_001_n), 
 .southUpStrFull(southFull_011_001_n),
 .southPacketIn(northPacket_011_010_s),
 .southReqDnStr(southReq_011_001_n),
 .southGntDnStr(northGnt_011_010_s), 
 .southDnStrFull(northFull_011_010_s), 
 .southPacketOut(southPacket_011_001_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_011_001), 
 .localGntUpStr(localGntUpStr_011_001), 
 .localUpStrFull(localUpStrFull_011_001),
 .localPacketIn(localPacketIn_011_001),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_011_001), 
 .localDnStrFull(localDnStrFull_011_001), 
 .localGntDnStr(localGntDnStr_011_001), 
 .localPacketOut(localPacketOut_011_001)
); 
//######################################################################################
//####################### Instantiate of Router 100_001 ################################
//######################################################################################
 Base_Router # (.routerNo(9),.routerID(6'b100_001),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_100_001
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(1'b0), 
 .eastGntUpStr(), 
 .eastUpStrFull(), 
 .eastPacketIn(0),
 .eastReqDnStr(), 
 .eastGntDnStr(1'b0),
 .eastDnStrFull(1'b0),  
 .eastPacketOut(),
 //******************************
 .northReqUpStr(southReq_100_000_n), 
 .northUpStrFull(northFull_100_001_s),
 .northGntUpStr(northGnt_100_001_s),
 .northPacketIn(southPacket_100_000_n),
 .northReqDnStr(northReq_100_001_s), 
 .northDnStrFull(southFull_100_000_n),
 .northGntDnStr(southGnt_100_000_n), 
 .northPacketOut(northPacket_100_001_s),
 //******************************
 .westReqUpStr(eastReq_011_001_w),  
 .westGntUpStr(westGnt_100_001_e),
 .westUpStrFull(westFull_100_001_e),  
 .westPacketIn(eastPacket_011_001_w),
 .westReqDnStr(westReq_100_001_e),  
 .westGntDnStr(eastGnt_011_001_w), 
 .westDnStrFull(eastFull_011_001_w),
 .westPacketOut(westPacket_100_001_e),
 //******************************
 .southReqUpStr(northReq_100_010_s), 
 .southGntUpStr(southGnt_100_001_n), 
 .southUpStrFull(southFull_100_001_n),
 .southPacketIn(northPacket_100_010_s),
 .southReqDnStr(southReq_100_001_n),
 .southGntDnStr(northGnt_100_010_s), 
 .southDnStrFull(northFull_100_010_s), 
 .southPacketOut(southPacket_100_001_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_100_001), 
 .localGntUpStr(localGntUpStr_100_001), 
 .localUpStrFull(localUpStrFull_100_001),
 .localPacketIn(localPacketIn_100_001),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_100_001), 
 .localDnStrFull(localDnStrFull_100_001), 
 .localGntDnStr(localGntDnStr_100_001), 
 .localPacketOut(localPacketOut_100_001)
); 
//######################################################################################
//######################################################################################
//##########################         Third row        ##################################
//######################################################################################
//######################################################################################
//####################### Instantiate of Router 000_010 ################################
//######################################################################################
 Base_Router # (.routerNo(10),.routerID(6'b000_010),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_000_010
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_001_010_e), 
 .eastGntUpStr(eastGnt_000_010_w), 
 .eastUpStrFull(eastFull_000_010_w), 
 .eastPacketIn(westPacket_001_010_e),
 .eastReqDnStr(eastReq_000_010_w), 
 .eastGntDnStr(westGnt_001_010_e),
 .eastDnStrFull(westFull_001_010_e),  
 .eastPacketOut(eastPacket_000_010_w),
 //******************************
 .northReqUpStr(southReq_000_001_n), 
 .northUpStrFull(northFull_000_010_s),
 .northGntUpStr(northGnt_000_010_s),
 .northPacketIn(southPacket_000_001_n),
 .northReqDnStr(northReq_000_010_s), 
 .northDnStrFull(southFull_000_001_n),
 .northGntDnStr(southGnt_000_001_n), 
 .northPacketOut(northPacket_000_010_s),
 //******************************
 .westReqUpStr(1'b0),  
 .westUpStrFull(),
 .westGntUpStr(), 
 .westPacketIn(0),
 .westReqDnStr(),  
 .westDnStrFull(1'b0),
 .westGntDnStr(1'b0), 
 .westPacketOut(),
 //******************************
 .southReqUpStr(northReq_000_011_s), 
 .southGntUpStr(southGnt_000_010_n), 
 .southUpStrFull(southFull_000_010_n),
 .southPacketIn(northPacket_000_011_s),
 .southReqDnStr(southReq_000_010_n),
 .southGntDnStr(northGnt_000_011_s), 
 .southDnStrFull(northFull_000_011_s), 
 .southPacketOut(southPacket_000_010_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_000_010), 
 .localGntUpStr(localGntUpStr_000_010), 
 .localUpStrFull(localUpStrFull_000_010),
 .localPacketIn(localPacketIn_000_010),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_000_010), 
 .localDnStrFull(localDnStrFull_000_010), 
 .localGntDnStr(localGntDnStr_000_010), 
 .localPacketOut(localPacketOut_000_010)
); 
//######################################################################################
//####################### Instantiate of Router 001_010 ################################
//######################################################################################
 Base_Router # (.routerNo(11),.routerID(6'b001_010),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_001_010
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_010_010_e), 
 .eastGntUpStr(eastGnt_001_010_w), 
 .eastUpStrFull(eastFull_001_010_w), 
 .eastPacketIn(westPacket_010_010_e),
 .eastReqDnStr(eastReq_001_010_w), 
 .eastGntDnStr(westGnt_010_010_e),
 .eastDnStrFull(westFull_010_010_e),  
 .eastPacketOut(eastPacket_001_010_w),
 //******************************
 .northReqUpStr(southReq_001_001_n), 
 .northUpStrFull(northFull_001_010_s),
 .northGntUpStr(northGnt_001_010_s),
 .northPacketIn(southPacket_001_001_n),
 .northReqDnStr(northReq_001_010_s), 
 .northDnStrFull(southFull_001_001_n),
 .northGntDnStr(southGnt_001_001_n), 
 .northPacketOut(northPacket_001_010_s),
 //******************************
 .westReqUpStr(eastReq_000_010_w),  
 .westGntUpStr(westGnt_001_010_e),
 .westUpStrFull(westFull_001_010_e),  
 .westPacketIn(eastPacket_000_010_w),
 .westReqDnStr(westReq_001_010_e),  
 .westGntDnStr(eastGnt_000_010_w), 
 .westDnStrFull(eastFull_000_010_w),
 .westPacketOut(westPacket_001_010_e),
 //******************************
 .southReqUpStr(northReq_001_011_s), 
 .southGntUpStr(southGnt_001_010_n), 
 .southUpStrFull(southFull_001_010_n),
 .southPacketIn(northPacket_001_011_s),
 .southReqDnStr(southReq_001_010_n),
 .southGntDnStr(northGnt_001_011_s), 
 .southDnStrFull(northFull_001_011_s), 
 .southPacketOut(southPacket_001_010_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_001_010), 
 .localGntUpStr(localGntUpStr_001_010), 
 .localUpStrFull(localUpStrFull_001_010),
 .localPacketIn(localPacketIn_001_010),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_001_010), 
 .localDnStrFull(localDnStrFull_001_010), 
 .localGntDnStr(localGntDnStr_001_010), 
 .localPacketOut(localPacketOut_001_010)
); 
//######################################################################################
//####################### Instantiate of Router 010_010 ################################
//######################################################################################
 Base_Router # (.routerNo(12),.routerID(6'b010_010),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_010_010
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_011_010_e), 
 .eastGntUpStr(eastGnt_010_010_w), 
 .eastUpStrFull(eastFull_010_010_w), 
 .eastPacketIn(westPacket_011_010_e),
 .eastReqDnStr(eastReq_010_010_w), 
 .eastGntDnStr(westGnt_011_010_e),
 .eastDnStrFull(westFull_011_010_e),  
 .eastPacketOut(eastPacket_010_010_w),
 //******************************
 .northReqUpStr(southReq_010_001_n), 
 .northUpStrFull(northFull_010_010_s),
 .northGntUpStr(northGnt_010_010_s),
 .northPacketIn(southPacket_010_001_n),
 .northReqDnStr(northReq_010_010_s), 
 .northDnStrFull(southFull_010_001_n),
 .northGntDnStr(southGnt_010_001_n), 
 .northPacketOut(northPacket_010_010_s),
 //******************************
 .westReqUpStr(eastReq_001_010_w),  
 .westGntUpStr(westGnt_010_010_e),
 .westUpStrFull(westFull_010_010_e),  
 .westPacketIn(eastPacket_001_010_w),
 .westReqDnStr(westReq_010_010_e),  
 .westGntDnStr(eastGnt_001_010_w), 
 .westDnStrFull(eastFull_001_010_w),
 .westPacketOut(westPacket_010_010_e),
 //******************************
 .southReqUpStr(northReq_010_011_s), 
 .southGntUpStr(southGnt_010_010_n), 
 .southUpStrFull(southFull_010_010_n),
 .southPacketIn(northPacket_010_011_s),
 .southReqDnStr(southReq_010_010_n),
 .southGntDnStr(northGnt_010_011_s), 
 .southDnStrFull(northFull_010_011_s), 
 .southPacketOut(southPacket_010_010_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_010_010), 
 .localGntUpStr(localGntUpStr_010_010), 
 .localUpStrFull(localUpStrFull_010_010),
 .localPacketIn(localPacketIn_010_010),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_010_010), 
 .localDnStrFull(localDnStrFull_010_010), 
 .localGntDnStr(localGntDnStr_010_010), 
 .localPacketOut(localPacketOut_010_010)
); 
//######################################################################################
//####################### Instantiate of Router 011_010 ################################
//######################################################################################
 Base_Router # (.routerNo(13),.routerID(6'b011_010),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_011_010
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_100_010_e), 
 .eastGntUpStr(eastGnt_011_010_w), 
 .eastUpStrFull(eastFull_011_010_w), 
 .eastPacketIn(westPacket_100_010_e),
 .eastReqDnStr(eastReq_011_010_w), 
 .eastGntDnStr(westGnt_100_010_e),
 .eastDnStrFull(westFull_100_010_e),  
 .eastPacketOut(eastPacket_011_010_w),
 //******************************
 .northReqUpStr(southReq_011_001_n), 
 .northUpStrFull(northFull_011_010_s),
 .northGntUpStr(northGnt_011_010_s),
 .northPacketIn(southPacket_011_001_n),
 .northReqDnStr(northReq_011_010_s), 
 .northDnStrFull(southFull_011_001_n),
 .northGntDnStr(southGnt_011_001_n), 
 .northPacketOut(northPacket_011_010_s),
 //******************************
 .westReqUpStr(eastReq_010_010_w),  
 .westGntUpStr(westGnt_011_010_e),
 .westUpStrFull(westFull_011_010_e),  
 .westPacketIn(eastPacket_010_010_w),
 .westReqDnStr(westReq_011_010_e),  
 .westGntDnStr(eastGnt_010_010_w), 
 .westDnStrFull(eastFull_010_010_w),
 .westPacketOut(westPacket_011_010_e),
 //******************************
 .southReqUpStr(northReq_011_011_s), 
 .southGntUpStr(southGnt_011_010_n), 
 .southUpStrFull(southFull_011_010_n),
 .southPacketIn(northPacket_011_011_s),
 .southReqDnStr(southReq_011_010_n),
 .southGntDnStr(northGnt_011_011_s), 
 .southDnStrFull(northFull_011_011_s), 
 .southPacketOut(southPacket_011_010_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_011_010), 
 .localGntUpStr(localGntUpStr_011_010), 
 .localUpStrFull(localUpStrFull_011_010),
 .localPacketIn(localPacketIn_011_010),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_011_010), 
 .localDnStrFull(localDnStrFull_011_010), 
 .localGntDnStr(localGntDnStr_011_010), 
 .localPacketOut(localPacketOut_011_010)
); 
//######################################################################################
//####################### Instantiate of Router 100_010 ################################
//######################################################################################
 Base_Router # (.routerNo(14),.routerID(6'b100_010),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_100_010
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(1'b0), 
 .eastGntUpStr(), 
 .eastUpStrFull(), 
 .eastPacketIn(0),
 .eastReqDnStr(), 
 .eastGntDnStr(1'b0),
 .eastDnStrFull(1'b0),  
 .eastPacketOut(),
 //******************************
 .northReqUpStr(southReq_100_001_n), 
 .northUpStrFull(northFull_100_010_s),
 .northGntUpStr(northGnt_100_010_s),
 .northPacketIn(southPacket_100_001_n),
 .northReqDnStr(northReq_100_010_s), 
 .northDnStrFull(southFull_100_001_n),
 .northGntDnStr(southGnt_100_001_n), 
 .northPacketOut(northPacket_100_010_s),
 //******************************
 .westReqUpStr(eastReq_011_010_w),  
 .westGntUpStr(westGnt_100_010_e),
 .westUpStrFull(westFull_100_010_e),  
 .westPacketIn(eastPacket_011_010_w),
 .westReqDnStr(westReq_100_010_e),  
 .westGntDnStr(eastGnt_011_010_w), 
 .westDnStrFull(eastFull_011_010_w),
 .westPacketOut(westPacket_100_010_e),
 //******************************
 .southReqUpStr(northReq_100_011_s), 
 .southGntUpStr(southGnt_100_010_n), 
 .southUpStrFull(southFull_100_010_n),
 .southPacketIn(northPacket_100_011_s),
 .southReqDnStr(southReq_100_010_n),
 .southGntDnStr(northGnt_100_011_s), 
 .southDnStrFull(northFull_100_011_s), 
 .southPacketOut(southPacket_100_010_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_100_010), 
 .localGntUpStr(localGntUpStr_100_010), 
 .localUpStrFull(localUpStrFull_100_010),
 .localPacketIn(localPacketIn_100_010),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_100_010), 
 .localDnStrFull(localDnStrFull_100_010), 
 .localGntDnStr(localGntDnStr_100_010), 
 .localPacketOut(localPacketOut_100_010)
); 
//######################################################################################
//######################################################################################
//##########################         Fourth row        #################################
//######################################################################################
//######################################################################################
//####################### Instantiate of Router 000_011 ################################
//######################################################################################
 Base_Router # (.routerNo(15),.routerID(6'b000_011),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_000_011
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_001_011_e), 
 .eastGntUpStr(eastGnt_000_011_w), 
 .eastUpStrFull(eastFull_000_011_w), 
 .eastPacketIn(westPacket_001_011_e),
 .eastReqDnStr(eastReq_000_011_w), 
 .eastGntDnStr(westGnt_001_011_e),
 .eastDnStrFull(westFull_001_011_e),  
 .eastPacketOut(eastPacket_000_011_w),
 //******************************
 .northReqUpStr(southReq_000_010_n), 
 .northUpStrFull(northFull_000_011_s),
 .northGntUpStr(northGnt_000_011_s),
 .northPacketIn(southPacket_000_010_n),
 .northReqDnStr(northReq_000_011_s), 
 .northDnStrFull(southFull_000_010_n),
 .northGntDnStr(southGnt_000_010_n), 
 .northPacketOut(northPacket_000_011_s),
 //******************************
 .westReqUpStr(1'b0),  
 .westUpStrFull(),
 .westGntUpStr(), 
 .westPacketIn(0),
 .westReqDnStr(),  
 .westDnStrFull(1'b0),
 .westGntDnStr(1'b0), 
 .westPacketOut(),
 //******************************
 .southReqUpStr(northReq_000_100_s), 
 .southGntUpStr(southGnt_000_011_n), 
 .southUpStrFull(southFull_000_011_n),
 .southPacketIn(northPacket_000_100_s),
 .southReqDnStr(southReq_000_011_n),
 .southGntDnStr(northGnt_000_100_s), 
 .southDnStrFull(northFull_000_100_s), 
 .southPacketOut(southPacket_000_011_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_000_011), 
 .localGntUpStr(localGntUpStr_000_011), 
 .localUpStrFull(localUpStrFull_000_011),
 .localPacketIn(localPacketIn_000_011),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_000_011), 
 .localDnStrFull(localDnStrFull_000_011), 
 .localGntDnStr(localGntDnStr_000_011), 
 .localPacketOut(localPacketOut_000_011)
); 
//######################################################################################
//####################### Instantiate of Router 001_011 ################################
//######################################################################################
 Base_Router # (.routerNo(16),.routerID(6'b001_011),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_001_011
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_010_011_e), 
 .eastGntUpStr(eastGnt_001_011_w), 
 .eastUpStrFull(eastFull_001_011_w), 
 .eastPacketIn(westPacket_010_011_e),
 .eastReqDnStr(eastReq_001_011_w), 
 .eastGntDnStr(westGnt_010_011_e),
 .eastDnStrFull(westFull_010_011_e),  
 .eastPacketOut(eastPacket_001_011_w),
 //******************************
 .northReqUpStr(southReq_001_010_n), 
 .northUpStrFull(northFull_001_011_s),
 .northGntUpStr(northGnt_001_011_s),
 .northPacketIn(southPacket_001_010_n),
 .northReqDnStr(northReq_001_011_s), 
 .northDnStrFull(southFull_001_010_n),
 .northGntDnStr(southGnt_001_010_n), 
 .northPacketOut(northPacket_001_011_s),
 //******************************
 .westReqUpStr(eastReq_000_011_w),  
 .westGntUpStr(westGnt_001_011_e),
 .westUpStrFull(westFull_001_011_e),  
 .westPacketIn(eastPacket_000_011_w),
 .westReqDnStr(westReq_001_011_e),  
 .westGntDnStr(eastGnt_000_011_w), 
 .westDnStrFull(eastFull_000_011_w),
 .westPacketOut(westPacket_001_011_e),
 //******************************
 .southReqUpStr(northReq_001_100_s), 
 .southGntUpStr(southGnt_001_011_n), 
 .southUpStrFull(southFull_001_011_n),
 .southPacketIn(northPacket_001_100_s),
 .southReqDnStr(southReq_001_011_n),
 .southGntDnStr(northGnt_001_100_s), 
 .southDnStrFull(northFull_001_100_s), 
 .southPacketOut(southPacket_001_011_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_001_011), 
 .localGntUpStr(localGntUpStr_001_011), 
 .localUpStrFull(localUpStrFull_001_011),
 .localPacketIn(localPacketIn_001_011),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_001_011), 
 .localDnStrFull(localDnStrFull_001_011), 
 .localGntDnStr(localGntDnStr_001_011), 
 .localPacketOut(localPacketOut_001_011)
); 
//######################################################################################
//####################### Instantiate of Router 010_011 ################################
//######################################################################################
 Base_Router # (.routerNo(17),.routerID(6'b010_011),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_010_011
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_011_011_e), 
 .eastGntUpStr(eastGnt_010_011_w), 
 .eastUpStrFull(eastFull_010_011_w), 
 .eastPacketIn(westPacket_011_011_e),
 .eastReqDnStr(eastReq_010_011_w), 
 .eastGntDnStr(westGnt_011_011_e),
 .eastDnStrFull(westFull_011_011_e),  
 .eastPacketOut(eastPacket_010_011_w),
 //******************************
 .northReqUpStr(southReq_010_010_n), 
 .northUpStrFull(northFull_010_011_s),
 .northGntUpStr(northGnt_010_011_s),
 .northPacketIn(southPacket_010_010_n),
 .northReqDnStr(northReq_010_011_s), 
 .northDnStrFull(southFull_010_010_n),
 .northGntDnStr(southGnt_010_010_n), 
 .northPacketOut(northPacket_010_011_s),
 //******************************
 .westReqUpStr(eastReq_001_011_w),  
 .westGntUpStr(westGnt_010_011_e),
 .westUpStrFull(westFull_010_011_e),  
 .westPacketIn(eastPacket_001_011_w),
 .westReqDnStr(westReq_010_011_e),  
 .westGntDnStr(eastGnt_001_011_w), 
 .westDnStrFull(eastFull_001_011_w),
 .westPacketOut(westPacket_010_011_e),
 //******************************
 .southReqUpStr(northReq_010_100_s), 
 .southGntUpStr(southGnt_010_011_n), 
 .southUpStrFull(southFull_010_011_n),
 .southPacketIn(northPacket_010_100_s),
 .southReqDnStr(southReq_010_011_n),
 .southGntDnStr(northGnt_010_100_s), 
 .southDnStrFull(northFull_010_100_s), 
 .southPacketOut(southPacket_010_011_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_010_011), 
 .localGntUpStr(localGntUpStr_010_011), 
 .localUpStrFull(localUpStrFull_010_011),
 .localPacketIn(localPacketIn_010_011),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_010_011), 
 .localDnStrFull(localDnStrFull_010_011), 
 .localGntDnStr(localGntDnStr_010_011), 
 .localPacketOut(localPacketOut_010_011)
); 
//######################################################################################
//####################### Instantiate of Router 011_011 ################################
//######################################################################################
 Base_Router # (.routerNo(18),.routerID(6'b011_011),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_011_011
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_100_011_e), 
 .eastGntUpStr(eastGnt_011_011_w), 
 .eastUpStrFull(eastFull_011_011_w), 
 .eastPacketIn(westPacket_100_011_e),
 .eastReqDnStr(eastReq_011_011_w), 
 .eastGntDnStr(westGnt_100_011_e),
 .eastDnStrFull(westFull_100_011_e),  
 .eastPacketOut(eastPacket_011_011_w),
 //******************************
 .northReqUpStr(southReq_011_010_n), 
 .northUpStrFull(northFull_011_011_s),
 .northGntUpStr(northGnt_011_011_s),
 .northPacketIn(southPacket_011_010_n),
 .northReqDnStr(northReq_011_011_s), 
 .northDnStrFull(southFull_011_010_n),
 .northGntDnStr(southGnt_011_010_n), 
 .northPacketOut(northPacket_011_011_s),
 //******************************
 .westReqUpStr(eastReq_010_011_w),  
 .westGntUpStr(westGnt_011_011_e),
 .westUpStrFull(westFull_011_011_e),  
 .westPacketIn(eastPacket_010_011_w),
 .westReqDnStr(westReq_011_011_e),  
 .westGntDnStr(eastGnt_010_011_w), 
 .westDnStrFull(eastFull_010_011_w),
 .westPacketOut(westPacket_011_011_e),
 //******************************
 .southReqUpStr(northReq_011_100_s), 
 .southGntUpStr(southGnt_011_011_n), 
 .southUpStrFull(southFull_011_011_n),
 .southPacketIn(northPacket_011_100_s),
 .southReqDnStr(southReq_011_011_n),
 .southGntDnStr(northGnt_011_100_s), 
 .southDnStrFull(northFull_011_100_s), 
 .southPacketOut(southPacket_011_011_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_011_011), 
 .localGntUpStr(localGntUpStr_011_011), 
 .localUpStrFull(localUpStrFull_011_011),
 .localPacketIn(localPacketIn_011_011),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_011_011), 
 .localDnStrFull(localDnStrFull_011_011), 
 .localGntDnStr(localGntDnStr_011_011), 
 .localPacketOut(localPacketOut_011_011)
); 
//######################################################################################
//####################### Instantiate of Router 100_011 ################################
//######################################################################################
 Base_Router # (.routerNo(19),.routerID(6'b100_011),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_100_011
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(1'b0), 
 .eastGntUpStr(), 
 .eastUpStrFull(), 
 .eastPacketIn(0),
 .eastReqDnStr(), 
 .eastGntDnStr(1'b0),
 .eastDnStrFull(1'b0),  
 .eastPacketOut(),
 //******************************
 .northReqUpStr(southReq_100_010_n), 
 .northUpStrFull(northFull_100_011_s),
 .northGntUpStr(northGnt_100_011_s),
 .northPacketIn(southPacket_100_010_n),
 .northReqDnStr(northReq_100_011_s), 
 .northDnStrFull(southFull_100_010_n),
 .northGntDnStr(southGnt_100_010_n), 
 .northPacketOut(northPacket_100_011_s),
 //******************************
 .westReqUpStr(eastReq_011_011_w),  
 .westGntUpStr(westGnt_100_011_e),
 .westUpStrFull(westFull_100_011_e),  
 .westPacketIn(eastPacket_011_011_w),
 .westReqDnStr(westReq_100_011_e),  
 .westGntDnStr(eastGnt_011_011_w), 
 .westDnStrFull(eastFull_011_011_w),
 .westPacketOut(westPacket_100_011_e),
 //******************************
 .southReqUpStr(northReq_100_100_s), 
 .southGntUpStr(southGnt_100_011_n), 
 .southUpStrFull(southFull_100_011_n),
 .southPacketIn(northPacket_100_100_s),
 .southReqDnStr(southReq_100_011_n),
 .southGntDnStr(northGnt_100_100_s), 
 .southDnStrFull(northFull_100_100_s), 
 .southPacketOut(southPacket_100_011_n),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_100_011), 
 .localGntUpStr(localGntUpStr_100_011), 
 .localUpStrFull(localUpStrFull_100_011),
 .localPacketIn(localPacketIn_100_011),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_100_011), 
 .localDnStrFull(localDnStrFull_100_011), 
 .localGntDnStr(localGntDnStr_100_011), 
 .localPacketOut(localPacketOut_100_011)
); 
//######################################################################################
//######################################################################################
//##########################         Fifth row         #################################
//######################################################################################
//######################################################################################
//####################### Instantiate of Router 000_100 ################################
//######################################################################################
 Base_Router # (.routerNo(20),.routerID(6'b000_100),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_000_100
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_001_100_e), 
 .eastGntUpStr(eastGnt_000_100_w), 
 .eastUpStrFull(eastFull_000_100_w), 
 .eastPacketIn(westPacket_001_100_e),
 .eastReqDnStr(eastReq_000_100_w), 
 .eastGntDnStr(westGnt_001_100_e),
 .eastDnStrFull(westFull_001_100_e),  
 .eastPacketOut(eastPacket_000_100_w),
 //******************************
 .northReqUpStr(southReq_000_011_n), 
 .northUpStrFull(northFull_000_100_s),
 .northGntUpStr(northGnt_000_100_s),
 .northPacketIn(southPacket_000_011_n),
 .northReqDnStr(northReq_000_100_s), 
 .northDnStrFull(southFull_000_011_n),
 .northGntDnStr(southGnt_000_011_n), 
 .northPacketOut(northPacket_000_100_s),
 //******************************
 .westReqUpStr(1'b0),  
 .westUpStrFull(),
 .westGntUpStr(), 
 .westPacketIn(0),
 .westReqDnStr(),  
 .westDnStrFull(1'b0),
 .westGntDnStr(1'b0), 
 .westPacketOut(),
 //******************************
 .southReqUpStr(1'b0), 
 .southGntUpStr(), 
 .southUpStrFull(),
 .southPacketIn(0),
 .southReqDnStr(),
 .southGntDnStr(1'b0), 
 .southDnStrFull(1'b0), 
 .southPacketOut(),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_000_100), 
 .localGntUpStr(localGntUpStr_000_100), 
 .localUpStrFull(localUpStrFull_000_100),
 .localPacketIn(localPacketIn_000_100),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_000_100), 
 .localDnStrFull(localDnStrFull_000_100), 
 .localGntDnStr(localGntDnStr_000_100), 
 .localPacketOut(localPacketOut_000_100)
); 
//######################################################################################
//####################### Instantiate of Router 001_100 ################################
//######################################################################################
 Base_Router # (.routerNo(21),.routerID(6'b001_100),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_001_100
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_010_100_e), 
 .eastGntUpStr(eastGnt_001_100_w), 
 .eastUpStrFull(eastFull_001_100_w), 
 .eastPacketIn(westPacket_010_100_e),
 .eastReqDnStr(eastReq_001_100_w), 
 .eastGntDnStr(westGnt_010_100_e),
 .eastDnStrFull(westFull_010_100_e),  
 .eastPacketOut(eastPacket_001_100_w),
 //******************************
 .northReqUpStr(southReq_001_011_n), 
 .northUpStrFull(northFull_001_100_s),
 .northGntUpStr(northGnt_001_100_s),
 .northPacketIn(southPacket_001_011_n),
 .northReqDnStr(northReq_001_100_s), 
 .northDnStrFull(southFull_001_011_n),
 .northGntDnStr(southGnt_001_011_n), 
 .northPacketOut(northPacket_001_100_s),
 //******************************
 .westReqUpStr(eastReq_000_100_w),  
 .westGntUpStr(westGnt_001_100_e),
 .westUpStrFull(westFull_001_100_e),  
 .westPacketIn(eastPacket_000_100_w),
 .westReqDnStr(westReq_001_100_e),  
 .westGntDnStr(eastGnt_000_100_w), 
 .westDnStrFull(eastFull_000_100_w),
 .westPacketOut(westPacket_001_100_e),
 //******************************
 .southReqUpStr(1'b0), 
 .southGntUpStr(), 
 .southUpStrFull(),
 .southPacketIn(0),
 .southReqDnStr(),
 .southGntDnStr(1'b0), 
 .southDnStrFull(1'b0), 
 .southPacketOut(),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_001_100), 
 .localGntUpStr(localGntUpStr_001_100), 
 .localUpStrFull(localUpStrFull_001_100),
 .localPacketIn(localPacketIn_001_100),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_001_100), 
 .localDnStrFull(localDnStrFull_001_100), 
 .localGntDnStr(localGntDnStr_001_100), 
 .localPacketOut(localPacketOut_001_100)
); 
//######################################################################################
//####################### Instantiate of Router 010_100 ################################
//######################################################################################
 Base_Router # (.routerNo(22),.routerID(6'b010_100),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_010_100
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_011_100_e), 
 .eastGntUpStr(eastGnt_010_100_w), 
 .eastUpStrFull(eastFull_010_100_w), 
 .eastPacketIn(westPacket_011_100_e),
 .eastReqDnStr(eastReq_010_100_w), 
 .eastGntDnStr(westGnt_011_100_e),
 .eastDnStrFull(westFull_011_100_e),  
 .eastPacketOut(eastPacket_010_100_w),
 //******************************
 .northReqUpStr(southReq_010_011_n), 
 .northUpStrFull(northFull_010_100_s),
 .northGntUpStr(northGnt_010_100_s),
 .northPacketIn(southPacket_010_011_n),
 .northReqDnStr(northReq_010_100_s), 
 .northDnStrFull(southFull_010_011_n),
 .northGntDnStr(southGnt_010_011_n), 
 .northPacketOut(northPacket_010_100_s),
 //******************************
 .westReqUpStr(eastReq_001_100_w),  
 .westGntUpStr(westGnt_010_100_e),
 .westUpStrFull(westFull_010_100_e),  
 .westPacketIn(eastPacket_001_100_w),
 .westReqDnStr(westReq_010_100_e),  
 .westGntDnStr(eastGnt_001_100_w), 
 .westDnStrFull(eastFull_001_100_w),
 .westPacketOut(westPacket_010_100_e),
 //******************************
 .southReqUpStr(1'b0), 
 .southGntUpStr(), 
 .southUpStrFull(),
 .southPacketIn(0),
 .southReqDnStr(),
 .southGntDnStr(1'b0), 
 .southDnStrFull(1'b0), 
 .southPacketOut(),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_010_100), 
 .localGntUpStr(localGntUpStr_010_100), 
 .localUpStrFull(localUpStrFull_010_100),
 .localPacketIn(localPacketIn_010_100),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_010_100), 
 .localDnStrFull(localDnStrFull_010_100), 
 .localGntDnStr(localGntDnStr_010_100), 
 .localPacketOut(localPacketOut_010_100)
); 
//######################################################################################
//####################### Instantiate of Router 011_100 ################################
//######################################################################################
 Base_Router # (.routerNo(23),.routerID(6'b011_100),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_011_100
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(westReq_100_100_e), 
 .eastGntUpStr(eastGnt_011_100_w), 
 .eastUpStrFull(eastFull_011_100_w), 
 .eastPacketIn(westPacket_100_100_e),
 .eastReqDnStr(eastReq_011_100_w), 
 .eastGntDnStr(westGnt_100_100_e),
 .eastDnStrFull(westFull_100_100_e),  
 .eastPacketOut(eastPacket_011_100_w),
 //******************************
 .northReqUpStr(southReq_011_011_n), 
 .northUpStrFull(northFull_011_100_s),
 .northGntUpStr(northGnt_011_100_s),
 .northPacketIn(southPacket_011_011_n),
 .northReqDnStr(northReq_011_100_s), 
 .northDnStrFull(southFull_011_011_n),
 .northGntDnStr(southGnt_011_011_n), 
 .northPacketOut(northPacket_011_100_s),
 //******************************
 .westReqUpStr(eastReq_010_100_w),  
 .westGntUpStr(westGnt_011_100_e),
 .westUpStrFull(westFull_011_100_e),  
 .westPacketIn(eastPacket_010_100_w),
 .westReqDnStr(westReq_011_100_e),  
 .westGntDnStr(eastGnt_010_100_w), 
 .westDnStrFull(eastFull_010_100_w),
 .westPacketOut(westPacket_011_100_e),
 //******************************
 .southReqUpStr(1'b0), 
 .southGntUpStr(), 
 .southUpStrFull(),
 .southPacketIn(0),
 .southReqDnStr(),
 .southGntDnStr(1'b0), 
 .southDnStrFull(1'b0), 
 .southPacketOut(),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_011_100), 
 .localGntUpStr(localGntUpStr_011_100), 
 .localUpStrFull(localUpStrFull_011_100),
 .localPacketIn(localPacketIn_011_100),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_011_100), 
 .localDnStrFull(localDnStrFull_011_100), 
 .localGntDnStr(localGntDnStr_011_100), 
 .localPacketOut(localPacketOut_011_100)
); 
//######################################################################################
//####################### Instantiate of Router 100_100 ################################
//######################################################################################
 Base_Router # (.routerNo(24),.routerID(6'b100_100),.dataWidth(dataWidth),.addressWidth(addressWidth) ,
                    .fifoDepth(fifoDepth),.dim(dim)) Router_100_100
 ( 
 .clk(clk), 
 .reset(reset),
 //******************************
 .eastReqUpStr(1'b0), 
 .eastGntUpStr(), 
 .eastUpStrFull(), 
 .eastPacketIn(0),
 .eastReqDnStr(), 
 .eastGntDnStr(1'b0),
 .eastDnStrFull(1'b0),  
 .eastPacketOut(),
 //******************************
 .northReqUpStr(southReq_100_011_n), 
 .northUpStrFull(northFull_100_100_s),
 .northGntUpStr(northGnt_100_100_s),
 .northPacketIn(southPacket_100_011_n),
 .northReqDnStr(northReq_100_100_s), 
 .northDnStrFull(southFull_100_011_n),
 .northGntDnStr(southGnt_100_011_n), 
 .northPacketOut(northPacket_100_100_s),
 //******************************
 .westReqUpStr(eastReq_011_100_w),  
 .westGntUpStr(westGnt_100_100_e),
 .westUpStrFull(westFull_100_100_e),  
 .westPacketIn(eastPacket_011_100_w),
 .westReqDnStr(westReq_100_100_e),  
 .westGntDnStr(eastGnt_011_100_w), 
 .westDnStrFull(eastFull_011_100_w),
 .westPacketOut(westPacket_100_100_e),
 //******************************
 .southReqUpStr(1'b0), 
 .southGntUpStr(), 
 .southUpStrFull(),
 .southPacketIn(0),
 .southReqDnStr(),
 .southGntDnStr(1'b0), 
 .southDnStrFull(1'b0), 
 .southPacketOut(),
  //******************************
//Connected to Injector  
 .localReqUpStr(localReqUpStr_100_100), 
 .localGntUpStr(localGntUpStr_100_100), 
 .localUpStrFull(localUpStrFull_100_100),
 .localPacketIn(localPacketIn_100_100),
//Connected to Collector 
 .localReqDnStr(localReqDnStr_100_100), 
 .localDnStrFull(localDnStrFull_100_100), 
 .localGntDnStr(localGntDnStr_100_100), 
 .localPacketOut(localPacketOut_100_100)
); 
//#########################################################################################
//#########################################################################################
//###########################                             #################################
//###########################   Modules(PEs) Intantiation #################################
//###########################                             #################################
//ModuleID = 6'b000_000 = 0 || ModuleID = 6'b000_001 = 1 || ModuleID = 6'b000_010 = 2
//ModuleID = 6'b000_011 = 3 || ModuleID = 6'b000_100 = 4 || ModuleID = 6'b000_101 = 5
//ModuleID = 6'b000_110 = 6 || ModuleID = 6'b000_111 = 7 || ModuleID = 6'b001_000 = 8
//..........................etc 
//#########################################################################################
//###########################            First row        #################################
//###########################                             #################################
//#########################################################################################
//#########################################################################################
//#######################  Instantiate of PE_Module 000_000  ##############################
//#####################  Instantiate of Local Port Injector ###############################

Injector_000_000 # (.ModuleID(6'b000_000),.dataWidth(dataWidth),.dim(dim)) Local_Injector_000_000
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_000_000),
 .GntDnStr(localGntUpStr_000_000),
 .DnStrFull(localUpStrFull_000_000),
 .PacketOut(localPacketIn_000_000) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_000_000 # (.ModuleID(6'b000_000),.dataWidth(dataWidth),.dim(dim)) Local_Collector_000_000
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_000_000),
 .GntUpStr(localGntDnStr_000_000), 
 .UpStrFull(localDnStrFull_000_000),
 .PacketIn(localPacketOut_000_000) 
);
//#########################################################################################
//#######################  Instantiate of PE_Module 001_000  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_001_000 # (.ModuleID(6'b000_001),.dataWidth(dataWidth),.dim(dim)) Local_Injector_001_000
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_001_000),
 .GntDnStr(localGntUpStr_001_000),
 .DnStrFull(localUpStrFull_001_000),
 .PacketOut(localPacketIn_001_000) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_001_000 # (.ModuleID(6'b000_001),.dataWidth(dataWidth),.dim(dim)) Local_Collector_001_000
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_001_000),
 .GntUpStr(localGntDnStr_001_000), 
 .UpStrFull(localDnStrFull_001_000),
 .PacketIn(localPacketOut_001_000) 
);


//#########################################################################################
//#######################  Instantiate of PE_Module 010_000  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_010_000 # (.ModuleID(6'b000_010),.dataWidth(dataWidth),.dim(dim)) Local_Injector_010_000
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_010_000),
 .GntDnStr(localGntUpStr_010_000),
 .DnStrFull(localUpStrFull_010_000),
 .PacketOut(localPacketIn_010_000) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_010_000 # (.ModuleID(6'b000_010),.dataWidth(dataWidth),.dim(dim)) Local_Collector_010_000
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_010_000),
 .GntUpStr(localGntDnStr_010_000), 
 .UpStrFull(localDnStrFull_010_000),
 .PacketIn(localPacketOut_010_000) 
);

//#########################################################################################
//#######################  Instantiate of PE_Module 011_000  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_011_000 # (.ModuleID(6'b000_011),.dataWidth(dataWidth),.dim(dim)) Local_Injector_011_000
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_011_000),
 .GntDnStr(localGntUpStr_011_000),
 .DnStrFull(localUpStrFull_011_000),
 .PacketOut(localPacketIn_011_000) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_011_000 # (.ModuleID(6'b000_011),.dataWidth(dataWidth),.dim(dim)) Local_Collector_011_000
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_011_000),
 .GntUpStr(localGntDnStr_011_000), 
 .UpStrFull(localDnStrFull_011_000),
 .PacketIn(localPacketOut_011_000) 
);

//#########################################################################################
//#######################  Instantiate of PE_Module 100_000  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_100_000 # (.ModuleID(6'b000_100),.dataWidth(dataWidth),.dim(dim)) Local_Injector_100_000
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_100_000),
 .GntDnStr(localGntUpStr_100_000),
 .DnStrFull(localUpStrFull_100_000),
 .PacketOut(localPacketIn_100_000) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_100_000 # (.ModuleID(6'b000_100),.dataWidth(dataWidth),.dim(dim)) Local_Collector_100_000
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_100_000),
 .GntUpStr(localGntDnStr_100_000), 
 .UpStrFull(localDnStrFull_100_000),
 .PacketIn(localPacketOut_100_000) 
);
//#########################################################################################
//###########################          Second row         #################################
//###########################                             #################################
//#########################################################################################
//##################################### - 5 - #############################################
//#######################  Instantiate of PE_Module 000_001  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_000_001 # (.ModuleID(6'b000_101),.dataWidth(dataWidth),.dim(dim)) Local_Injector_000_001
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_000_001),
 .GntDnStr(localGntUpStr_000_001),
 .DnStrFull(localUpStrFull_000_001),
 .PacketOut(localPacketIn_000_001) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_000_001 # (.ModuleID(6'b000_101),.dataWidth(dataWidth),.dim(dim)) Local_Collector_000_001
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_000_001),
 .GntUpStr(localGntDnStr_000_001), 
 .UpStrFull(localDnStrFull_000_001),
 .PacketIn(localPacketOut_000_001) 
);

//###################################### - 6 - ############################################
//#######################  Instantiate of PE_Module 001_001  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_001_001 # (.ModuleID(6'b000_110),.dataWidth(dataWidth),.dim(dim)) Local_Injector_001_001
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_001_001),
 .GntDnStr(localGntUpStr_001_001),
 .DnStrFull(localUpStrFull_001_001),
 .PacketOut(localPacketIn_001_001) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_001_001 # (.ModuleID(6'b000_110),.dataWidth(dataWidth),.dim(dim)) Local_Collector_001_001
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_001_001),
 .GntUpStr(localGntDnStr_001_001), 
 .UpStrFull(localDnStrFull_001_001),
 .PacketIn(localPacketOut_001_001) 
);

//####################################### - 7 - ###########################################
//#######################  Instantiate of PE_Module 010_001  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_010_001 # (.ModuleID(6'b000_111),.dataWidth(dataWidth),.dim(dim)) Local_Injector_010_001
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_010_001),
 .GntDnStr(localGntUpStr_010_001),
 .DnStrFull(localUpStrFull_010_001),
 .PacketOut(localPacketIn_010_001) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_010_001 # (.ModuleID(6'b000_111),.dataWidth(dataWidth),.dim(dim)) Local_Collector_010_001
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_010_001),
 .GntUpStr(localGntDnStr_010_001), 
 .UpStrFull(localDnStrFull_010_001),
 .PacketIn(localPacketOut_010_001) 
);

//###################################### - 8 - ############################################
//#######################  Instantiate of PE_Module 011_001  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_011_001 # (.ModuleID(6'b001_000),.dataWidth(dataWidth),.dim(dim)) Local_Injector_011_001
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_011_001),
 .GntDnStr(localGntUpStr_011_001),
 .DnStrFull(localUpStrFull_011_001),
 .PacketOut(localPacketIn_011_001) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_011_001 # (.ModuleID(6'b001_000),.dataWidth(dataWidth),.dim(dim)) Local_Collector_011_001
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_011_001),
 .GntUpStr(localGntDnStr_011_001), 
 .UpStrFull(localDnStrFull_011_001),
 .PacketIn(localPacketOut_011_001) 
);

//###################################### - 9 - ############################################
//#######################  Instantiate of PE_Module 100_001  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_100_001 # (.ModuleID(6'b001_001),.dataWidth(dataWidth),.dim(dim)) Local_Injector_100_001
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_100_001),
 .GntDnStr(localGntUpStr_100_001),
 .DnStrFull(localUpStrFull_100_001),
 .PacketOut(localPacketIn_100_001) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_100_001 # (.ModuleID(6'b001_001),.dataWidth(dataWidth),.dim(dim)) Local_Collector_100_001
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_100_001),
 .GntUpStr(localGntDnStr_100_001), 
 .UpStrFull(localDnStrFull_100_001),
 .PacketIn(localPacketOut_100_001) 
);
//#########################################################################################
//###########################            Third row        #################################
//###########################                             #################################
//#########################################################################################
//###################################### - 10 - ###########################################
//#######################  Instantiate of PE_Module 000_010  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_000_010 # (.ModuleID(6'b001_010),.dataWidth(dataWidth),.dim(dim)) Local_Injector_000_010
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_000_010),
 .GntDnStr(localGntUpStr_000_010),
 .DnStrFull(localUpStrFull_000_010),
 .PacketOut(localPacketIn_000_010) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_000_010 # (.ModuleID(6'b001_010),.dataWidth(dataWidth),.dim(dim)) Local_Collector_000_010
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_000_010),
 .GntUpStr(localGntDnStr_000_010), 
 .UpStrFull(localDnStrFull_000_010),
 .PacketIn(localPacketOut_000_010) 
);
//##################################### - 11 - ############################################
//#######################  Instantiate of PE_Module 001_010  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_001_010 # (.ModuleID(6'b001_011),.dataWidth(dataWidth),.dim(dim)) Local_Injector_001_010
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_001_010),
 .GntDnStr(localGntUpStr_001_010),
 .DnStrFull(localUpStrFull_001_010),
 .PacketOut(localPacketIn_001_010) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_001_010 # (.ModuleID(6'b001_011),.dataWidth(dataWidth),.dim(dim)) Local_Collector_001_010
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_001_010),
 .GntUpStr(localGntDnStr_001_010), 
 .UpStrFull(localDnStrFull_001_010),
 .PacketIn(localPacketOut_001_010) 
);
//###################################### - 12 - ###########################################
//#######################  Instantiate of PE_Module 010_010  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_010_010 # (.ModuleID(6'b001_100),.dataWidth(dataWidth),.dim(dim)) Local_Injector_010_010
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_010_010),
 .GntDnStr(localGntUpStr_010_010),
 .DnStrFull(localUpStrFull_010_010),
 .PacketOut(localPacketIn_010_010) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_010_010 # (.ModuleID(6'b001_100),.dataWidth(dataWidth),.dim(dim)) Local_Collector_010_010
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_010_010),
 .GntUpStr(localGntDnStr_010_010), 
 .UpStrFull(localDnStrFull_010_010),
 .PacketIn(localPacketOut_010_010) 
);
//####################################### - 13 - ##########################################
//#######################  Instantiate of PE_Module 011_010  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_011_010 # (.ModuleID(6'b001_101),.dataWidth(dataWidth),.dim(dim)) Local_Injector_011_010
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_011_010),
 .GntDnStr(localGntUpStr_011_010),
 .DnStrFull(localUpStrFull_011_010),
 .PacketOut(localPacketIn_011_010) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_011_010 # (.ModuleID(6'b001_101),.dataWidth(dataWidth),.dim(dim)) Local_Collector_011_010
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_011_010),
 .GntUpStr(localGntDnStr_011_010), 
 .UpStrFull(localDnStrFull_011_010),
 .PacketIn(localPacketOut_011_010) 
);
//###################################### - 14 - ###########################################
//#######################  Instantiate of PE_Module 100_010  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_100_010 # (.ModuleID(6'b001_110),.dataWidth(dataWidth),.dim(dim)) Local_Injector_100_010
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_100_010),
 .GntDnStr(localGntUpStr_100_010),
 .DnStrFull(localUpStrFull_100_010),
 .PacketOut(localPacketIn_100_010) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_100_010 # (.ModuleID(6'b001_110),.dataWidth(dataWidth),.dim(dim)) Local_Collector_100_010
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_100_010),
 .GntUpStr(localGntDnStr_100_010), 
 .UpStrFull(localDnStrFull_100_010),
 .PacketIn(localPacketOut_100_010) 
);
//#########################################################################################
//###########################           Fourth row        #################################
//###########################                             #################################
//#########################################################################################
//##################################### - 15 - ############################################
//#######################  Instantiate of PE_Module 000_011  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_000_011 # (.ModuleID(6'b001_111),.dataWidth(dataWidth),.dim(dim)) Local_Injector_000_011
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_000_011),
 .GntDnStr(localGntUpStr_000_011),
 .DnStrFull(localUpStrFull_000_011),
 .PacketOut(localPacketIn_000_011) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_000_011 # (.ModuleID(6'b001_111),.dataWidth(dataWidth),.dim(dim)) Local_Collector_000_011
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_000_011),
 .GntUpStr(localGntDnStr_000_011), 
 .UpStrFull(localDnStrFull_000_011),
 .PacketIn(localPacketOut_000_011) 
);
//##################################### - 16 - ############################################
//#######################  Instantiate of PE_Module 001_011  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_001_011 # (.ModuleID(6'b010_000),.dataWidth(dataWidth),.dim(dim)) Local_Injector_001_011
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_001_011),
 .GntDnStr(localGntUpStr_001_011),
 .DnStrFull(localUpStrFull_001_011),
 .PacketOut(localPacketIn_001_011) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_001_011 # (.ModuleID(6'b010_000),.dataWidth(dataWidth),.dim(dim)) Local_Collector_001_011
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_001_011),
 .GntUpStr(localGntDnStr_001_011), 
 .UpStrFull(localDnStrFull_001_011),
 .PacketIn(localPacketOut_001_011) 
);
//######################################## - 17 - #########################################
//#######################  Instantiate of PE_Module 010_011  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_010_011 # (.ModuleID(6'b010_001),.dataWidth(dataWidth),.dim(dim)) Local_Injector_010_011
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_010_011),
 .GntDnStr(localGntUpStr_010_011),
 .DnStrFull(localUpStrFull_010_011),
 .PacketOut(localPacketIn_010_011) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_010_011 # (.ModuleID(6'b010_001),.dataWidth(dataWidth),.dim(dim)) Local_Collector_010_011
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_010_011),
 .GntUpStr(localGntDnStr_010_011), 
 .UpStrFull(localDnStrFull_010_011),
 .PacketIn(localPacketOut_010_011) 
);
//###################################### - 18 - ###########################################
//#######################  Instantiate of PE_Module 011_011  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_011_011 # (.ModuleID(6'b010_010),.dataWidth(dataWidth),.dim(dim)) Local_Injector_011_011
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_011_011),
 .GntDnStr(localGntUpStr_011_011),
 .DnStrFull(localUpStrFull_011_011),
 .PacketOut(localPacketIn_011_011) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_011_011 # (.ModuleID(6'b010_010),.dataWidth(dataWidth),.dim(dim)) Local_Collector_011_011
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_011_011),
 .GntUpStr(localGntDnStr_011_011), 
 .UpStrFull(localDnStrFull_011_011),
 .PacketIn(localPacketOut_011_011) 
);
//#######################################  19  ############################################
//#######################  Instantiate of PE_Module 100_011  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_100_011 # (.ModuleID(6'b010_011),.dataWidth(dataWidth),.dim(dim)) Local_Injector_100_011
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_100_011),
 .GntDnStr(localGntUpStr_100_011),
 .DnStrFull(localUpStrFull_100_011),
 .PacketOut(localPacketIn_100_011) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_100_011 # (.ModuleID(6'b010_011),.dataWidth(dataWidth),.dim(dim)) Local_Collector_100_011
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_100_011),
 .GntUpStr(localGntDnStr_100_011), 
 .UpStrFull(localDnStrFull_100_011),
 .PacketIn(localPacketOut_100_011) 
);
//#########################################################################################
//###########################          Fifth row          #################################
//###########################                             #################################
//#########################################################################################
//###################################### - 20 - ###########################################
//#######################  Instantiate of PE_Module 000_100  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_000_100 # (.ModuleID(6'b010_100),.dataWidth(dataWidth),.dim(dim)) Local_Injector_000_100
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_000_100),
 .GntDnStr(localGntUpStr_000_100),
 .DnStrFull(localUpStrFull_000_100),
 .PacketOut(localPacketIn_000_100) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_000_100 # (.ModuleID(6'b010_100),.dataWidth(dataWidth),.dim(dim)) Local_Collector_000_100
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_000_100),
 .GntUpStr(localGntDnStr_000_100), 
 .UpStrFull(localDnStrFull_000_100),
 .PacketIn(localPacketOut_000_100) 
);
//###################################### -21 - ############################################
//#######################  Instantiate of PE_Module 001_100  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_001_100 # (.ModuleID(6'b010_101),.dataWidth(dataWidth),.dim(dim)) Local_Injector_001_100
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_001_100),
 .GntDnStr(localGntUpStr_001_100),
 .DnStrFull(localUpStrFull_001_100),
 .PacketOut(localPacketIn_001_100) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_001_100 # (.ModuleID(6'b010_101),.dataWidth(dataWidth),.dim(dim)) Local_Collector_001_100
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_001_100),
 .GntUpStr(localGntDnStr_001_100), 
 .UpStrFull(localDnStrFull_001_100),
 .PacketIn(localPacketOut_001_100) 
);
//####################################### - 22 - ##########################################
//#######################  Instantiate of PE_Module 010_100  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_010_100 # (.ModuleID(6'b010_110),.dataWidth(dataWidth),.dim(dim)) Local_Injector_010_100
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_010_100),
 .GntDnStr(localGntUpStr_010_100),
 .DnStrFull(localUpStrFull_010_100),
 .PacketOut(localPacketIn_010_100) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_010_100 # (.ModuleID(6'b010_110),.dataWidth(dataWidth),.dim(dim)) Local_Collector_010_100
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_010_100),
 .GntUpStr(localGntDnStr_010_100), 
 .UpStrFull(localDnStrFull_010_100),
 .PacketIn(localPacketOut_010_100) 
);
//####################################### - 23 - ##########################################
//#######################  Instantiate of PE_Module 011_100  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_011_100 # (.ModuleID(6'b010_111),.dataWidth(dataWidth),.dim(dim)) Local_Injector_011_100
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_011_100),
 .GntDnStr(localGntUpStr_011_100),
 .DnStrFull(localUpStrFull_011_100),
 .PacketOut(localPacketIn_011_100) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_011_100 # (.ModuleID(6'b010_111),.dataWidth(dataWidth),.dim(dim)) Local_Collector_011_100
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_011_100),
 .GntUpStr(localGntDnStr_011_100), 
 .UpStrFull(localDnStrFull_011_100),
 .PacketIn(localPacketOut_011_100) 
);
//####################################### - 24 - ##########################################
//#######################  Instantiate of PE_Module 100_100  ##############################
//#####################  Instantiate of Local Port Injector ###############################
Injector_100_100 # (.ModuleID(6'b011_000),.dataWidth(dataWidth),.dim(dim)) Local_Injector_100_100
(
 .reset(reset),
 .clk(clk), 
// -- Output Port Traffic: --
 .ReqDnStr(localReqUpStr_100_100),
 .GntDnStr(localGntUpStr_100_100),
 .DnStrFull(localUpStrFull_100_100),
 .PacketOut(localPacketIn_100_100) //Packet in from local port
);
//#####################  Instantiate of Local Port Collector #############################
Collector_100_100 # (.ModuleID(6'b011_000),.dataWidth(dataWidth),.dim(dim)) Local_Collector_100_100
(
 .reset(reset),
 .clk(clk), 
 .ReqUpStr(localReqDnStr_100_100),
 .GntUpStr(localGntDnStr_100_100), 
 .UpStrFull(localDnStrFull_100_100),
 .PacketIn(localPacketOut_100_100) 
);

//#########################################################################################
endmodule
//#########################################################################################

