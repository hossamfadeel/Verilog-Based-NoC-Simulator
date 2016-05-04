`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:11:49 12/25/2012 
// Design Name: 
// Module Name:    FIFO_M 
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
module FIFO ( clk, reset, reqUpStr , gntUpStr , full, PacketIn,
                         reqInCtr , gntInCtr , empty, PacketOut );
// --------------------------------------------------------------------------- //
// ------------------------ Parameter Declarations --------------------------- //
parameter dataWidth = 32; // number of bits for data bus
parameter addressWidth = 4;// number of bits for address bus
parameter fifoDepth =  ( ( 1 << addressWidth ) - 1 ); // number of entries in fifo buffer
parameter dim = 2;// dimension of x,y fields in source and destination  
// ------------------------ Inputs Declarations ------------------------------ //
input clk;
input reset;
input reqUpStr;// Up stream router request  
input reqInCtr;// Input controller request  
input [dataWidth-1:0] PacketIn;// input data Packet to fifo
// ------------------------ Outputs Declarations ----------------------------- //
output gntUpStr;// Up stream router grant  
output gntInCtr;// Input controller grant  
output full;// indicator for FIFO buffer .. if full = 1 else = 0
output empty;// indicator for FIFO buffer .. if empty = 1 else = 0
output [dataWidth-1:0] PacketOut;// output data Packet form fifo
// --------------------------- Wire Declarations ----------------------------- //
wire clk;
wire reset;
wire reqUpStr;// Up stream router request  
reg  gntUpStr;// Up stream router grant  
wire reqInCtr;// Input controller request  
wire [dataWidth-1:0] PacketIn;// input data Packet to fifo
reg [dataWidth-1:0] PacketOut;// output data Packet form fifo
wire full;// indicator for FIFO buffer .. if full = 1 else = 0
wire empty;// indicator for FIFO buffer .. if empty = 1 else = 0
//reg writeEnable;// write enable to ram buffer
//reg readEnable;// read enable to ram buffer
//wire [addressWidth-1:0] compAddr;// variable used to compare address   
//wire [addressWidth:0] compAddr;// i add extra bit due to addition
// ------------------------ Registers Declarations --------------------------- // 
reg gntInCtr;// Input controller grant 
wire [addressWidth-1:0] writeAddr;// write address to ram buffer
wire [addressWidth-1:0] readAddr;// read address from ram buffer
reg [addressWidth:0] write_ptr;// write pointer to get Full and Empty flags
reg [addressWidth:0] read_ptr;// write pointer to get Full and Empty flags
reg EnableGnt;
reg [dataWidth-1:0] ram[2**addressWidth-1:0];
//=============================================================================
// Extracting read and write address from corrosponding pointers
assign readAddr = read_ptr [addressWidth-1:0];
assign writeAddr = write_ptr [addressWidth-1:0];
assign read_buf = reqInCtr && !empty;// read signal ... 
assign write_buf = reqUpStr && !full && EnableGnt ;// write signal ... 
// Generating fifo full status
// FIFO full is asserted when both pointers point to same address but their
// MSBs are different
assign full = ( (writeAddr == readAddr) &&
(write_ptr[addressWidth] ^ read_ptr[addressWidth]) );	
//FIFO is empty when read pointer is same as write pointer
assign empty = ( read_ptr == write_ptr ); // MSBs are idintical



always @(posedge clk or negedge reset)
  begin
    if( !reset)//reset all registers
      begin 
        gntInCtr  <= 0; gntUpStr <= 0; EnableGnt <= 1;  //DataBuffer = 0;
        write_ptr <= {(addressWidth+1){1'b0}}; //readEnable	 <= 0; writeEnable <= 0; 
		  read_ptr <= {(addressWidth+1){1'b0}};  
      end
    else 
      begin
// handle request from up stream router 
			if ( !reqUpStr)
				EnableGnt <= 1;			
//  ---------------------------- write process ------------------------- // 			
			 if (write_buf)// Buffer not Full
				begin
						gntUpStr 	<= 1;	EnableGnt <= 0; //writeEnable <= 1;
					//write_ptr <= write_ptr + {{addressWidth{1'b0}},1'b1};
					write_ptr <= write_ptr + 1'b1;
					//writeAddr	<= writeAddr + 1'b1;
					 ram[writeAddr] <= PacketIn;
				end
			else	
			begin	
			gntUpStr 	<= 0; //writeEnable <= 0; 
			end								
// ----------------------------- read process -------------------------- //
			if (read_buf )
				begin						
					 gntInCtr <= 1; //readEnable  <= 1;
					//read_ptr <= read_ptr + {{addressWidth{1'b0}},1'b1};
					read_ptr <= read_ptr + 1'b1;
					//readAddr 	<= readAddr + 1'b1;	
				   PacketOut <= ram[readAddr];
				end
			else 
			begin	
			gntInCtr	<= 0;  //readEnable  <= 0;	
			end		
      end // reset
  end // always  

//// Memory write
//always @(posedge clk or negedge reset)
//begin
//if (writeEnable)
//ram[writeAddr] <= PacketIn;
//end
//// Memory Read
//always @(posedge clk)
//begin
//if (readEnable)
//begin
//PacketOut <= ram[readAddr];
//end
//end

endmodule

// ------------------------  instantiation Devices --------------------------- //

/* instantiate ram to buffer received Packet. */
//ram # (.dataWidth(dataWidth),.addressWidth(addressWidth)) fifoBuffer
//(
//.clk(clk),
//.reset(reset),
//.writeEn(writeEnable),
//.readEn(readEnable),
//.writeAddr(writeAddr),
//.readAddr(readAddr),
//.dataIn(PacketIn),
//.dataOut(PacketOut)
//);
//initial 
//   begin 
//		gntInCtr 	<= 0;
//		gntUpStr		<= 0;
//		writeEnable <= 0;
//		readEnable	<= 0;
//		writeAddr	<= 0;
//		readAddr 	<= 0;	
//		EnableGnt <= 1;		
//   end
//	
//// ----------------------- Sequential  Logic  -------------------------------- //
//always @(posedge clk or negedge reset)
//  begin
//    if( !reset)//reset all registers
//      begin 
//        gntInCtr 		<= 0;
//		  gntUpStr		<= 0;
//		  readEnable	<= 0;
//		  writeEnable 	<= 0;
//        writeAddr 	<= 0;
//        readAddr 		<= 0;
//		  EnableGnt <= 1;
//      end
//      // --------------------------------------------------------------------- //
//    else
//      begin
//// handle request from up stream router 
//			if ( !reqUpStr)
//				EnableGnt <= 1;			
//				
//			 if ( reqUpStr && ! full  && EnableGnt)// Buffer not Full
//				begin
//					gntUpStr 	<= 1;
//					EnableGnt 	<= 0;
//					writeEnable <= 1;
//					writeAddr	<= writeAddr + 1'b1;
//				end
//			else
//				begin
//					gntUpStr 	<= 0;
//					writeEnable <= 0;
//				end
//			
//			if ( reqInCtr && ! empty )
//				begin						
//					gntInCtr		<= 1; 
//					readEnable  <= 1;
//					readAddr 	<= readAddr +1'b1;						
//				end
//			else 
//				begin
//					readEnable  <= 0;
//					gntInCtr		<= 0;
//				end
//      end // reset
//  end // always  
//// ----------------------- Combinational Logic  ------------------------------ //
//// enabel writing to fifo when request is applied from Up stream Router
////assign writeEnable = (! gntUpStr )? reqUpStr : 1'b0 ; // if full writeEn=req else 0;
//							/*(cond) ? (result if cond true):(result if cond false)*/
//// enable reading from fifo when request is applied from input Controller
////assign gntInCtr = (! empty )? reqInCtr : 1'b0 ;
//
////assign readEnable = (! empty )? reqInCtr : 1'b0 ;
//// address compare signal 
//assign compAddr = readAddr + fifoDepth ;
//// full indicator when write address equals to fifo depth
//assign full = ( writeAddr == compAddr ); // shalaby
////assign full_FFC = ( writeAddr == (compAddr-4) ); // shalaby
////assign full = ( (writeAddr == compAddr) & writeEnable ); // maher
//// empty indicator when read address equals to read address.
//assign empty = ( writeAddr == readAddr );
//// --------------------------------------------------------------------------- //
//endmodule
