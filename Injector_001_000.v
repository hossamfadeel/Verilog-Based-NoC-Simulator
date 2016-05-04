`timescale 1ns / 1ps

module Injector_001_000(
// Global Settings 
/*-- for Injection rate (load) and typr of traffic (Random, ..etc) it will be defined in the 
Top module i.e. Traffic Generator.*/
reset,
clk, 
// -- Output Port Traffic: --
ReqDnStr,
GntDnStr,
DnStrFull,
PacketOut
);              
// ------------------------ Parameter Declarations --------------------------- //
//for 5x5 mesh
parameter routerID=6'b000_000; // change depends on mesh size 
parameter ModuleID =6'b000_000;
parameter CLOCK_MULT=3'b001; //// packet injection rate (percentage of cycles)
parameter dataWidth = 32;// number of bits for data bus
parameter dim = 4;// dimension of x,y fields in source and destination  
//Injector States 				
parameter 	IDLE			=2'b00,
				PKT_PREP		=2'b01, 
				SEND_REQ		=2'b10, 
				WAIT_GRANT	=2'b11;	
// ------------------------ Inputs Declarations ------------------------------ //
input clk;
input reset;
input DnStrFull; // indicator from Local about FIFO buffer status.. if full = 1 else = 0
input GntDnStr; // Grant from Down Stream Router
// ------------------------ Outputs Declarations ----------------------------- //
output ReqDnStr;  // Injector send request to router to send packets
output [dataWidth-1:0] PacketOut;// output data packet form Injector
// --------------------------- Wire Declarations ----------------------------- //
wire clk;
wire reset;
wire DnStrFull;// indicator for Injector about Local FIFO buffer status .. if full = 1 else = 0
wire GntDnStr; // Grant from Down Stream Router
wire [dataWidth-1:0] PacketOut;// output data packet form fifo
// --------------------------------------------------------------------------- //
// ------------------------ Registers Declarations --------------------------- //
reg ReqDnStr; // request to Local Port FIFO Buffer  
reg [dataWidth-1:0] dataBuf;// data buffer register 
//Packet Contents
// source and destination registers 
// 3 bit for position and 1 bit for direction
reg [dim-1:0] xDst, yDst, xSrc, ySrc;
reg [1:0] STATE;
//PacketID and RandomInfo can be adjusted to fit the diminsion bits
reg [9:0]    PacketID;  	// 0:1023
reg [9:0]    RandomInfo; // 
reg [31:0]   CYCLE_COUNTER; //Timestamp 
integer Delay, Count;
//for Simulation log
integer Injector_Log_1;
reg [7:0] num; //0 : 255
// --------------------------------------------------------------------------- //
initial 
   begin 		
		xSrc <= 0; ySrc <= 0; xDst <= 0; yDst <= 0; STATE	<= IDLE; CYCLE_COUNTER <= 0;
		dataBuf <= 0; PacketID <= 0;	num <= 0;	RandomInfo <= 0; Count <= 0; Delay <= 0;
		//for Simulation log
		Injector_Log_1 = $fopen("Injector_Log_1.txt","w");
		//$fdisplay(Injector_Log_1, "     SimulationTime ;   SendTime      ; SenderID   ; PacketID     ");	
   end
	
always @(posedge clk)
   begin 
   CYCLE_COUNTER <= CYCLE_COUNTER + 1'b1;   
   end	
//###########################   Modules(PEs) Injector ################################### 
always @(posedge clk or negedge reset)  
begin
if( !reset)
	begin 
	xSrc <= 0; ySrc <= 0; xDst <= 0; yDst <= 0;
	dataBuf <= 0; PacketID <= 0;	num <= 0;	RandomInfo <= 0;
	ReqDnStr 		<= 0; Count <= 0;
	STATE	<= IDLE;
	end  
//#########################################################################################################		
else 					
	begin 
	case(STATE)
//################## STATE ###############################################		
IDLE:begin 
//######################################################################
//Note: Comment Delay and Its Condition If you want to see Full Signal Or increase the Probability
//Delay between two consequence packets. to be changed to change Injection Rate		
Delay 	<= {$random}% 16;//{$random}%3;// 0,1,2,3 are selected randomly
num 		<= {$random}% 95;// 0,1,2,3, ... to 95 are selected randomly
STATE	<= PKT_PREP;
end
//######################################################################
PKT_PREP:begin
//################### Packeckt Preparation #############################
//Directions: East -> 1 	North -> 1		//xDst <= 4'b0_011;  yDst <= 4'b1_010;
//				  West -> 0 	South -> 0     //1bit direction +3bit position
//###################         First Row           ####################
if(num >= 0 && num < 96)
	begin //to 010_000
		xDst <= 4'b1_001;  yDst <= 4'b0_000; 
	end
//######################################################################																
PacketID <= PacketID + 1'b1; 
RandomInfo <= $random;	
xSrc	<= 0;	
ySrc	<= 0;
STATE	<= SEND_REQ;
//%%%%%%%%%%%%%%%%%%%%%%%%%%% END of Packeckt Preparation %%%%%%%%%%%%%%%%%%%%%%%%%%%								
end
//######################################################################
SEND_REQ:begin	
//######################################################################
if (PacketID != 1023)
begin
	if (Count == Delay)
		begin
		if (!DnStrFull) // Buffer not Full !=1
			begin
			ReqDnStr <= 1; //send request to Local Port
			dataBuf  <= {xDst, yDst, xSrc,ySrc,PacketID, ModuleID};//, RandomInfo} ;
			//PacketOut      <= dataBuf;
			STATE	<= WAIT_GRANT;
			Count <= 0;
			$fdisplay(Injector_Log_1,  $time, " ; %d ; %d ; %d ", CYCLE_COUNTER, ModuleID,PacketID);			
			end //if
		else 
			begin
			STATE <= SEND_REQ;
			end 
		end//if delay
	else 
		begin
		Count <= Count+1'b1;					
		end
		 
end	//if (PacketID != 1023)		
end //SEND_REQ
//######################################################################	
WAIT_GRANT: begin
//######################################################################
if (GntDnStr) // Buffer not Full
	begin
	ReqDnStr 			<=0; //send request to Local Port
	STATE		<= IDLE;
	end
else
	begin
	STATE		<= WAIT_GRANT;
	end
end
endcase
	end //else
end // always 
assign PacketOut = dataBuf;
endmodule

//#########################################################################################################