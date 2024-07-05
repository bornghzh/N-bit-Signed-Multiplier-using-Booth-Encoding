`timescale 1ns/1ns
module multiplier6#(parameter nb = 32)
(
//---------------------Port directions and deceleration
   input clk,  
   input start,
   input signed [nb-1:0] A,
   input signed [nb-1:0] B, 
   output reg signed [(2*nb)-1:0] Product,
   output ready
    );




//----------------------------------------------------

//--------------------------------- register deceleration
reg signed [nb+1:0] Multiplicand;
reg [($clog2(nb))-1:0] counter;
reg [3:0] ab;
reg abb;
reg [nb-1:0] BB;
reg signed [nb+1:0] adder_output;

//-----------------------------------------------------

//----------------------------------- wire deceleration
wire c_out;
wire [nb:0] chose;
//-------------------------------------------------------

//------------------------------------ combinational logic
assign ready = counter[$clog2(nb)-1];


//-------------------------------------------------------

//------------------------------------- sequential Logic
always @ (*)
adder_output = {Product[2*nb-1], Product[2*nb-1], Product[2*nb-1:nb]};

always @ (posedge clk)

   if(start) begin
      counter <= 0 ;
      Multiplicand <= {A>>>2, A[1] , A[0]};
      Product <= {{nb{1'b0}}, B};
      BB <= B;
      abb = 0;
   end

   else if(! ready) begin

         abb <= Product[1];
         Product <= ($signed(Product)) >>> 2;
         counter <= counter + 1;
         ab = {Product[1:0],abb};
              if(counter<=nb/2)
         begin
                   case (ab)
   3'b000: Product[2*nb-1:nb-2]<= adder_output;
   3'b001: Product[2*nb-1:nb-2]<=Multiplicand + adder_output;
   3'b010: Product[2*nb-1:nb-2] <= Multiplicand + adder_output;
   3'b011: Product[2*nb-1:nb-2] <= (Multiplicand + Multiplicand) + adder_output  ;
   3'b100: Product[2*nb-1:nb-2] <= -(Multiplicand + Multiplicand) + adder_output;
   3'b101: Product[2*nb-1:nb-2] <= -Multiplicand + adder_output;
   3'b110: Product[2*nb-1:nb-2] <= -Multiplicand + adder_output;
   3'b111: Product[2*nb-1:nb-2] <= adder_output;
   endcase
             
         end

   end   

endmodule