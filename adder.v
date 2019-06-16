module ADDER_32bit(clk,rst,A, B, F);
   
   input clk, rst;
   input [31:0]A,B;

   output [31:0]F;
   reg [31:0]F;
	
//   reg [1:0]sign;
//   reg [7:0]exponent;

//	reg [7:0]difference;
//	reg [23:0]mantissa;

//////////////// PIPE-LINE REGISTERS /////////////////
reg [62:0] P1;
reg [40:0] P2;
reg [31:0] P3;
//////////////////////////////////////////////////////

initial
begin	
	P1 = 0;
	P2 = 0;
	P3 = 0;
end

wire [1:0]sign;
wire [7:0]difference;

assign sign = A[31]+B[31];
assign difference = (P1[62:55] - P1[31:24]);

//always @ ( F or A or B )
always @ ( posedge clk )
begin
/////////////////////////////////////////////////////////
	P1[0] <= (sign == 1'b1) ? 1'b1 : 1'b0;
	P1[31:1] <= A[30:0];
	P1[62:32] <= B[30:0];
///////////////////////////////////////////////////////////
	P2[0] <= P1[0];
	
	if (P1[31:24] == P1[62:55]) begin
	   P2[24:1] <= P1[23:1] + P1[54:32];
	end
	else if (P1[31:24] < P1[62:55]) begin
	   P2[23:1] <= (P1[23:1] >> difference ) + P1[54:32];
	   P2[24] <= 1'b0;	   
	end

	P2[32:25] <= P1[31:24];
	P2[40:33] <= P1[62:55];
///////////////////////////////////////////////////////////
	P3[0] <= P2[0];
	
	if (P2[32:25] == P2[40:33]) begin
	   P3[23:1] <= P2[24:2];
	   P3[31:24] <= P2[32:25] + 8'h01;
	end
	else if (P2[32:25] < P2[40:33]) begin
	   P3[31:24] <= P2[40:33] + 8'h01;   
	end

///////////////////////////////////////////////////////////
	F[31] <= P3[0];
	F[30:0] <= P3[31:1];



	//solve for the sign bit part
	//sign = A[31]+B[31];
	//F[31] = (sign == 1'b1) ? 1'b1 : 1'b0;
	
	//solve for the mantissa part and exponent part
//	if (A[30:23] == B[30:23]) begin
//	   mantissa = A[22:0] + B[22:0];
//	   exponent = A[30:23] + 8'h01;
//	   F[30:0] = {exponent, mantissa[23:1]};
//	end
//	else if (A[30:23] < B[30:23]) begin
//	   difference = (B[30:23] - A[30:23]);
//	   F[22:0] = (A[22:0] >> difference ) + B[22:0];
//	   F[30:23] = B[30:23] + 8'h01;
//	end

end

endmodule
