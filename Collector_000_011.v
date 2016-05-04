
module Collector_000_011
(
// Global Settings 
clk, 
reset, 
// -- Input Port Traffic: --	Collector
PacketIn, //connect to localpacketOut,
UpStrFull, // connect to localDnStrFull, // it will be 0 where the task is to always collect packets
ReqUpStr, // connect to localReqDnStr, 
GntUpStr
);
 // ------------------------ Parameter Declarations --------------------------- //
 //for 4x4 mesh
parameter routerID = 6'b000_000; 
parameter ModuleID = 6'b000_000;
parameter dataWidth = 32;// number of bits for data bus
parameter dim = 4;// dimension of x,y fields in source and destination  
parameter 	WAIT_REQ=1'b0, 
				RECEIVE_DATA=1'b1;
// ------------------------ Inputs Declarations ------------------------------ //
input clk;
input reset;
input ReqUpStr;//  routers' Local Port send request to collector to receive packets -- always receive
// ------------------------ Outputs Declarations ----------------------------- //
output UpStrFull;  // Collector send Full to router -- Always Not full it is the destination
output GntUpStr;  

input [dataWidth-1:0] PacketIn;// output data packet form Local Port to Collector
// --------------------------- Wire Declarations ----------------------------- //
wire clk;
wire reset;
wire ReqUpStr;  // request from Local Port to Collector
wire [dataWidth-1:0] PacketIn;// Input data packet form Local Port
// ------------------------ Registers Declarations --------------------------- //
reg UpStrFull;// Always Not full it is the destination
reg GntUpStr;  
// data buffer register to accept the packet and Indicate its Information
reg [dataWidth-1:0] dataBuf;
//Packet Contents
reg [9:0]     PacketID;
reg [31:0]   CYCLE_COUNTER; //Timestamp 
reg  STATE_Collector; //reg [1:0] STATE_Collector;
reg [((dim-1)*2)-1:0] SenderID;
//reg [5:0] SenderID;
//for Simulation log
integer Collector_Log_15;
initial 
   begin 
		PacketID 	<= 0; UpStrFull <= 0; GntUpStr		<=0;
		CYCLE_COUNTER <= 0;	SenderID <= 0; STATE_Collector <= WAIT_REQ;
		//for Simulation log
		Collector_Log_15 = $fopen("Collector_Log_15.txt","w");
		//$fdisplay(Collector_Log_15, "      SimulationTime ; ReceiveTime ; SenderID ; ReceiverID ; PacketID ");	
   end

always @(posedge clk)
   begin 
   CYCLE_COUNTER = CYCLE_COUNTER + 1'b1;   
   end	
//###########################   Modules(PEs) Collector ################################### 
always @(posedge clk or negedge reset)
  begin
    if( !reset)// reset all registers   
      begin 
		PacketID 	<= 0; UpStrFull <= 0; GntUpStr		<=0;
		CYCLE_COUNTER <= 0;	SenderID <= 0; STATE_Collector <= WAIT_REQ;
      end
		else //if (ReqUpStr ) 
			begin 
			UpStrFull <=0; //send UpStrFull to Local Port
				case(STATE_Collector)
				WAIT_REQ:
					begin
						if(ReqUpStr) 
							begin
						    STATE_Collector <= RECEIVE_DATA;	
						    GntUpStr	<=1;
							PacketID 	<= PacketIn[((dim*4)-1) : ((dim*4)-1)-9];
							SenderID	<= PacketIn[((dim*4)-1)-10 : 0];
							end			
					end//WAIT_REQ
				RECEIVE_DATA:
					begin
						GntUpStr		<=0;
						STATE_Collector <= WAIT_REQ;
						$fdisplay(Collector_Log_15,  $time, " ;  %d; %d ; %d ; %d  ",  CYCLE_COUNTER,SenderID, ModuleID,PacketID);  		 
					end // RECEIVE_DATA
				 endcase	
    end // else
  end // always 
endmodule
