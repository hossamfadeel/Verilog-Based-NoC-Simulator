`timescale 1ns / 1ps

module Injector_010_100(
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
integer Injector_Log_22;
reg [7:0] num; //0 : 255
// --------------------------------------------------------------------------- //
initial 
   begin 		
		xSrc <= 0; ySrc <= 0; xDst <= 0; yDst <= 0; STATE	<= IDLE; CYCLE_COUNTER <= 0;
		dataBuf <= 0; PacketID <= 0;	num <= 0;	RandomInfo <= 0; Count <= 0; Delay <= 0;
		//for Simulation log
		Injector_Log_22 = $fopen("Injector_Log_22.txt","w");
		//$fdisplay(Injector_Log_22, "     SimulationTime ;   SendTime      ; SenderID   ; PacketID     ");	
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
if(num >= 0 && num < 4)
	begin //to 000_000
		//1bit direction +3bit position
		xDst <= 4'b0_010;  yDst <= 4'b1_100; 
	end
else if(num >= 4 && num < 8)
	begin //to 001_000
		//1bit direction +3bit position
		xDst <= 4'b1_001;  yDst <= 4'b1_100; 
	end
else if(num >= 8 && num < 12)
	begin //to 010_000
		//1bit direction +3bit position
		xDst <= 4'b0_000;  yDst <= 4'b1_100; 
	end
else if(num >= 12 && num < 16)
	begin //to 011_000
		//1bit direction +3bit position
		xDst <= 4'b1_001;  yDst <= 4'b1_100; 
	end
else if(num >= 16 && num < 20)
	begin //to 100_000
		//1bit direction +3bit position
		xDst <= 4'b1_010;  yDst <= 4'b1_100; 
	end
//###################         Second Row         ####################																							
else if(num >= 20 && num < 24)
	begin //to 000_001
		//1bit direction +3bit position
		xDst <= 4'b0_010;  yDst <= 4'b1_011; 
	end
else if(num >= 24 && num < 28)
	begin //to 001_001
		//1bit direction +3bit position
		xDst <= 4'b0_001;  yDst <= 4'b1_011; 
	end
else if(num >= 28 && num < 32)
	begin //to 010_001
		//1bit direction +3bit position
		xDst <= 4'b0_000;  yDst <= 4'b1_011; 
	end
else if(num >= 32 && num < 36)
	begin //to 011_001
		//1bit direction +3bit position
		xDst <= 4'b1_001;  yDst <= 4'b1_011; 
	end
else if(num >= 36 && num < 40)
	begin //to 100_001
		//1bit direction +3bit position
		xDst <= 4'b1_010;  yDst <= 4'b1_011; 
	end
//###################         Third  Row         ####################									
else if(num >= 40 && num < 44)
	begin //to 000_010
		//1bit direction +3bit position
		xDst <= 4'b0_010;  yDst <= 4'b1_010; 
	end
else if(num >= 44 && num < 48)
	begin //to 001_010
		//1bit direction +3bit position
		xDst <= 4'b0_001;  yDst <= 4'b1_010; 
	end
else if(num >= 48 && num < 52)
	begin //to 010_010
		//1bit direction +3bit position
		xDst <= 4'b0_000;  yDst <= 4'b1_010; 
	end
else if(num >= 52 && num < 56)
	begin //to 011_010
		//1bit direction +3bit position
		xDst <= 4'b1_001;  yDst <= 4'b1_010; 
	end
else if(num >= 56 && num < 60)
	begin //to 100_010
		//1bit direction +3bit position
		xDst <= 4'b1_010;  yDst <= 4'b1_010; 
	end
//###################         Fourth  Row         ####################									
else if(num >= 60 && num < 64)
	begin //to 000_011
		//1bit direction +3bit position
		xDst <= 4'b0_010;  yDst <= 4'b1_001; 
	end
else if(num >= 64 && num < 68)
	begin //to 001_011
		//1bit direction +3bit position
		xDst <= 4'b0_001;  yDst <= 4'b1_001; 
	end
else if(num >= 68 && num < 72)
	begin //to 010_011
		//1bit direction +3bit position
		xDst <= 4'b0_000;  yDst <= 4'b1_001; 
	end
else if(num >= 72 && num < 76)
	begin //to 011_011
		//1bit direction +3bit position
		xDst <= 4'b1_001;  yDst <= 4'b1_001; 
	end
else if(num >= 76 && num < 80)
	begin //to 100_011
		//1bit direction +3bit position
		xDst <= 4'b1_010;  yDst <= 4'b1_001; 
	end
//###################        Fifth   Row         ####################
else if(num >= 80 && num < 84)
	begin //to 000_100
		//1bit direction +3bit position
		xDst <= 4'b0_010;  yDst <= 4'b0_000; 
	end
else if(num >= 84 && num < 88)
	begin //to 001_100
		//1bit direction +3bit position
		xDst <= 4'b0_001;  yDst <= 4'b0_000; 
	end
else if(num >= 88 && num < 92)
	begin //to 011_100
		//1bit direction +3bit position
		xDst <= 4'b1_001;  yDst <= 4'b0_000; 
	end
else if(num >= 92 && num < 96)
	begin //to 100_100
		//1bit direction +3bit position
		xDst <= 4'b1_010;  yDst <= 4'b0_000; 
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
			$fdisplay(Injector_Log_22,  $time, " ; %d ; %d ; %d ", CYCLE_COUNTER, ModuleID,PacketID);			
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


