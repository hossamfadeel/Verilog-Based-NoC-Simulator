`timescale 1ns / 1ps
/*
#####################################################################################
 Company: 
 Engineer: 
 
 Create Date:    18:54:00 06/22/2013 
 Design Name: 
 Module Name:    InputPortController 
 Project Name: 
 Target Devices: 
 Tool versions: 
 Description: This file implements Input Controller which implements routing 
                algorithm and set up commnication between output Controller and
                fifo buffer.
                Network On Chip Router.

 Dependencies: 

 Revision: 
 Revision 0.01 - File Created
 Additional Comments: 

#####################################################################################
*/
module InputPortController ( clk, reset, req , gnt , empty , PacketIn,
                          reqOutCntr, gntOutCntr, PacketOut );
// --------------------------------------------------------------------------- //
// ------------------------ Parameter Declarations --------------------------- //
parameter routerNo  = 24; // change depends on mesh size
parameter dataWidth = 32;// number of bits for data bus
// dimension of x,y fields in source and destination  
parameter dim = 4;
// names of states of FSM 
parameter Idle = 2'b00,
          Read = 2'b01,
          Route = 2'b10,
          Grant = 2'b11; 		 
// ------------------------ Inputs Declarations ------------------------------ //
input clk;
input reset;
input gnt;// grant from FIFO Buffer  
input empty;// indicator from FIFO buffer .. if empty = 1 else = 0
input [dataWidth-1:0] PacketIn;// input data Packet to fifo
// grant bus from output controller which grant communication with other routers 
input [4:0] gntOutCntr;
// ------------------------ Outputs Declarations ----------------------------- //
output req;// request to FIFO Buffer   
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
// --------------------------- Wire Declarations ----------------------------- //
wire clk;
wire reset;  
wire gnt;// grant from fifo buffer 
// grant bus from output controller which grant communication with other routers 
wire [4:0] gntOutCntr;
wire [dataWidth-1:0] PacketIn;// input data Packet from fifo
wire [dataWidth-1:0] PacketOut;// output data Packet to output Controller
wire empty;// indicator from FIFO buffer .. if empty = 1 else = 0
// ------------------------ Registers Declarations --------------------------- //
reg req, EnableRoute;// request to FIFO Buffer  
// request bus to output controller which establish connection to other routers
// 4 ports + Local Network Inerface 
reg [4:0] reqOutCntr;		
reg [dataWidth-1:0] dataBuf,Temp;// data buffer register 
// source and destination registers for 2X2 mesh x and y has 2 bit each one 1 bit for direction and 1 bit for position
reg [dim-1:0] xDst, yDst, xSrc, ySrc;
// FSM register 
reg [1:0] State;
//for Simulation log
integer Routing_Log;			 
//INITIALIZATIONS
initial 
	begin
		req <= 0; EnableRoute <= 0;
		xSrc <= 0; ySrc <= 0; xDst <= 0; yDst <= 0; //x_Dir <= 0; y_Dir <= 0;
		req <= 0;
		dataBuf <= 0;
		Temp <= 0;
		State <= Idle;
		reqOutCntr <= 0;
		Routing_Log = $fopen("Routing_Log.txt","w");
		$fdisplay(Routing_Log, "    Routing_Log     ");
	end
// ------------------------  instantiation Devices --------------------------- //
// ----------------------- Sequential  Logic  -------------------------------- //

//always @(*)
//begin
//	$fdisplay(Routing_Log, $time, " ; %b ;%d  ", PacketIn,routerNo);
//	xDst = PacketIn[dataWidth-1:dataWidth-dim];					//31:30
//	yDst = PacketIn[dataWidth-dim-1:dataWidth-(dim*2)];		//29:28
//	xSrc = PacketIn[dataWidth-(dim*2)-1:dataWidth-(dim*3)];	//27:26
//	ySrc = PacketIn[dataWidth-(dim*3)-1:dataWidth-(dim*4)];	//25:24
//end

always @(posedge clk or negedge reset)
  begin
    if( !reset)//reset all registers 
      begin 
		  req 			<= 0;
        dataBuf 		<= 0;
		  Temp 			<= 0;
        State 			<= Idle;
        reqOutCntr 	<= 0;
      end
    else
      begin
        case (State)// FSM 
          // Ideal state .. check if fifo buffer is empty or not ,
          // if not empty .. Input Controller get one data Packet.
          Idle :
			 begin
				 if ( !empty )
					begin
					  State 	<= Read;
					  req 	<= 1;
					end
//				else if (empty && (PacketIn != Temp) && (Temp != 0))
//					begin
//					State 	<= Read;
//					EnableRoute <= 1;
//					end
				else
					begin
						req 	<= 0;
						//EnableRoute <= 0;
						State <= Idle;
					end
					
			 end//Idle
          // read data Packet ..extract source and destnation            
          Read : 
			 begin     
				if ( gnt )// | EnableRoute )
					begin
						req <= 0;
						State <= Route;
						//EnableRoute <= 0;
//						if (PacketIn)
//							begin
//							State <= Route;
////							xDst <= PacketIn[dataWidth-1:dataWidth-dim];					//31:30
////							yDst <= PacketIn[dataWidth-dim-1:dataWidth-(dim*2)];		//29:28
////							xSrc <= PacketIn[dataWidth-(dim*2)-1:dataWidth-(dim*3)];	//27:26
////							ySrc <= PacketIn[dataWidth-(dim*3)-1:dataWidth-(dim*4)];	//25:24
////							Temp[dataWidth-1:dataWidth-(dim*4)] <= PacketIn[dataWidth-1:dataWidth-(dim*4)];
////							Temp[dataWidth-(dim*4)-1:0]  <= PacketIn[dataWidth-(dim*4)-1:0];
//							end
//						else State <= Idle;
					end 
				else
					begin
						req <= 0;
						State <= Read;
					end
			 end//Read
          // Routing algorithm .. x-y algorithm 
          Route : 
			 begin
            State <= Grant;
				dataBuf[dataWidth-1:dataWidth-(dim*4)] <= PacketIn[dataWidth-1:dataWidth-(dim*4)];
				dataBuf[dataWidth-(dim*4)-1:0]  <= PacketIn[dataWidth-(dim*4)-1:0];
// ########################    define direction   ##################################### 

				//if ( xDst[dim-2:0] > xSrc[ dim-2:0] ) // Optmaize compartor 
if ( PacketIn[dataWidth-2:dataWidth-dim] > PacketIn[dataWidth-(dim*2)-2:dataWidth-(dim*3)] ) // Optmaize compartor 				
              begin
					dataBuf[dataWidth-(dim*2)-1:dataWidth-(dim*3)] <= PacketIn[dataWidth-(dim*2)-1:dataWidth-(dim*3)]+1;
					dataBuf[dataWidth-(dim*3)-1:dataWidth-(dim*4)] <= PacketIn[dataWidth-(dim*3)-1:dataWidth-(dim*4)];
					 //if ( xDst[dim-1] ) // negative sign .. MSB
					 if ( PacketIn[dataWidth-1] )
                  begin
						reqOutCntr[0] <= 1;  // move east direction  
						end
                else
						begin
						reqOutCntr[2] <= 1;  // move west direction    
						end
              end//end if
// ########################    define direction   ##################################### 
////							xDst <= PacketIn[dataWidth-1:dataWidth-dim];					//31:30
////							yDst <= PacketIn[dataWidth-dim-1:dataWidth-(dim*2)];		//29:28
////							xSrc <= PacketIn[dataWidth-(dim*2)-1:dataWidth-(dim*3)];	//27:26
////							ySrc <= PacketIn[dataWidth-(dim*3)-1:dataWidth-(dim*4)];	//25:24				
else if ( PacketIn[dataWidth-dim-2:dataWidth-(dim*2)] > PacketIn[dataWidth-(dim*3)-2:dataWidth-(dim*4)] ) // Optmaize compartor				
				//else if ( yDst[dim-2:0] > ySrc[dim-2:0] ) // Optmaize compartor
              begin
					dataBuf[dataWidth-(dim*2)-1:dataWidth-(dim*3)] <= PacketIn[dataWidth-(dim*2)-1:dataWidth-(dim*3)];
					dataBuf[dataWidth-(dim*3)-1:dataWidth-(dim*4)] <= PacketIn[dataWidth-(dim*3)-1:dataWidth-(dim*4)]+1;
					 //if ( yDst[dim-1] ) // negative sign ... MSB
					 if ( PacketIn[dataWidth-dim-1] ) // negative sign ... MSB
						begin
                  reqOutCntr[1] <= 1;  // move north direction  
						end
                else
					   begin
						reqOutCntr[3] <= 1;  // move south direction    
						end
              end
// ########################    define direction   ##################################### 
            else 
              begin
					reqOutCntr[4]	<= 1;  //Local Port
					dataBuf[dataWidth-(dim*2)-1:dataWidth-(dim*3)] <= PacketIn[dataWidth-(dim*2)-1:dataWidth-(dim*3)];
					dataBuf[dataWidth-(dim*3)-1:dataWidth-(dim*4)] <= PacketIn[dataWidth-(dim*3)-1:dataWidth-(dim*4)];
              end 
          end
        // Grant communication between Output controller and Input Controller 
        // ------------------------------------------------------------------- //           
        Grant : 
			  if ( gntOutCntr)//  
				 begin
					State <= Idle;
					reqOutCntr <= 0;
				 end
       endcase
      end // reset
  end // always 
// ----------------------- Combinational Logic  ------------------------------ //
assign PacketOut = dataBuf;
// --------------------------------------------------------------------------- //
endmodule
// ----------------------------- End of File --------------------------------- //
