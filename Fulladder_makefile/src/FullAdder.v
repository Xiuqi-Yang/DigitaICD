module FullAdder (
        input A,B,CIN,
        output COUT,S
);

   assign COUT  = (A & B) | (A ^ B) & CIN;
   assign S = A ^ B ^ CIN ; 
endmodule