module Carry_Gen
#(
    parameter WIDTH = 16
)    
(
    input  i_CI,
    input  [WIDTH - 1 : 0] i_Pre_Pass,
    input  [WIDTH - 1 : 0] i_Pre_Gen,
    output [WIDTH - 1 : 0] o_Bit_Carry
);
    //Carry_Gen
    logic [WIDTH - 1 : 0] Carry ;

    assign Carry = i_Pre_Gen | {WIDTH{i_CI}}&i_Pre_Pass ;

    assign o_Bit_Carry = Carry;
	


endmodule
