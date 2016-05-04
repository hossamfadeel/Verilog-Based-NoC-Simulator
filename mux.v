// --------------------------------------------------------------------------- //
/*
  FILE NAME:	mux.v

  VERSION:      $Revision: 1.0 $

  AUTHOR(S):    Ahmed Shalaby

  DATE CREATED: 31/08/2011

  DESCRIPTION:  This file implements mux used by output controller.
*/
//*********************************************************
// --------------------------------------------------------------------------- //
module mux ( PacketInPort_0, PacketInPort_1, PacketInPort_2 , PacketInPort_3,
				 PacketInPort_4, sel, PacketOut );
// --------------------------------------------------------------------------- //
// ------------------------ Parameter Declarations --------------------------- //
// number of bits for data bus
parameter dataWidth = 100;
// --------------------------------------------------------------------------- //
// ------------------------ Inputs Declarations ------------------------------ //
// input data packet from all other ports and Network Interface to Mux
input [dataWidth-1:0] PacketInPort_0,PacketInPort_1,PacketInPort_2,PacketInPort_3,PacketInPort_4;
// select input 
input [2:0] sel;
// --------------------------------------------------------------------------- //
// ------------------------ Outputs Declarations ----------------------------- //
// output data packet form Mux
output [dataWidth-1:0] PacketOut;
// --------------------------------------------------------------------------- //
// --------------------------- Wire Declarations ----------------------------- //
// input data packet from all other ports and Network Interface to Mux
wire [dataWidth-1:0] PacketInPort_0,PacketInPort_1,PacketInPort_2,PacketInPort_3,PacketInPort_4;
// select input 
wire [2:0] sel;
// --------------------------------------------------------------------------- //
// ------------------------ Registers Declarations --------------------------- //
// output data packet form Mux
reg [dataWidth-1:0] PacketOut;
// --------------------------------------------------------------------------- //
// ------------------------  instantiation Devices --------------------------- //
// --------------------------------------------------------------------------- //
// ----------------------- Sequential  Logic  -------------------------------- //
always @ (sel or PacketInPort_0 or PacketInPort_1 or
                 PacketInPort_2 or PacketInPort_3 or PacketInPort_4 )
  begin
      case (sel)
        // depend on sel , output port connected to selected input port.
        // 4 ports .. NI + 3 other ports than Input
        3'b000: PacketOut = PacketInPort_0;
        3'b001: PacketOut = PacketInPort_1;
        3'b010: PacketOut = PacketInPort_2;
        3'b011: PacketOut = PacketInPort_3;
		  3'b100: PacketOut = PacketInPort_4;
		  default: PacketOut = 0; // Don't Care
		  //default: PacketOut = 32'hxxxx_xxxx; //xxxx_xxxx Don't Care
		  //32'hXXXX_XXXX
      endcase
  end
// ----------------------- Combinational Logic  ------------------------------ //  
// --------------------------------------------------------------------------- //
endmodule
// ----------------------------- End of File --------------------------------- //

///**********************************************************************
// * Date: Aug. 28, 1999
// * File: Mux 4 to 1.v (440 Examples)
// *
// * Behavioral Model of a 4 to 1 MUX (16 data inputs) 
//http://www.cecs.csulb.edu/~rallison/pdf/Mux_4_to_1.pdf
// **********************************************************************/
////*********************************************************
// module mux_4to1(Y, A, B, C, D, sel);
////*********************************************************
// output [15:0] Y;
// input [15:0] A, B, C, D;
// input [1:0] sel;
// reg [15:0] Y;
// always @(A or B or C or D or sel) 
// case ( sel )
// 2'b00: Y = A;
// 2'b01: Y = B;
// 2'b10: Y = C;
// 2'b11: Y = D;
// default: Y = 16'hxxxx;
// endcase
// endmodule

/************************************************************************ 
* Date: Aug. 16, 2006 
* File: Test Mux 4 to 1.v (440 Examples) 
* 
* Testbench to generate some stimulus and display the results for the 
* Mux 4 to 1 module -- with 4 sets of 16 data inputs and 2 select lines 
************************************************************************/ 
////********************************************************* 
//module Test_mux_4to1; 
////********************************************************* 
//wire [15:0] MuxOut; //use wire data type for outputs from instantiated module
//reg [15:0] A, B, C, D; //use reg data type for all inputs 
//reg [1:0] sel; // to the instantiated module
//reg clk; //to be used for timing of WHEN to change input values 
//// Instantiate the MUX (named DUT {device under test}) 
// mux_4to1 DUT(MuxOut, A, B, C, D, sel); 
////This block generates a clock pulse with a 20 ns period 
//always 
// #10 clk = ~clk; 
////This initial block will provide values for the inputs 
//// of the mux so that both inputs/outputs can be displayed 
//initial begin 
//$timeformat(-9, 1, " ns", 6); 
//clk = 1'b0; // time = 0 
//A = 16'hAAAA; B = 16'h5555; C = 16'h00FF; D = 16'hFF00; sel = 2'b00; 
//@(negedge clk) //will wait for next negative edge of the clock (t=20)
// A = 16'h0000; 
//@(negedge clk) //will wait for next negative edge of the clock (t=40)
// sel = 2'b01;
//@(negedge clk) //will wait for next negative edge of the clock (t=60)
// B = 16'hFFFF; 
//@(negedge clk) //will wait for next negative edge of the clock (t=80)
// sel = 2'b10; 
// A = 16'hA5A5; 
//@(negedge clk) //will wait for next negative edge of the clock (t=100)
// sel = 2'b00; 
//@(negedge clk) //will wait for next negative edge of the clock (t=120)
// $finish; // to shut down the simulation 
//end //initial
//// this block is sensitive to changes on ANY of the inputs and will 
//// then display both the inputs and corresponding output 
//always @(A or B or C or D or sel) 
// #1 $display("At t=%t / sel=%b A=%h B=%h C=%h D=%h / MuxOut=%h", 
// $time, sel, A, B, C, D, MuxOut); 
//endmodule 