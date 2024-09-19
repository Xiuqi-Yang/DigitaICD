module pg_code
#(
    WIDTH = 16
)(
    input [ WIDTH - 1 : 0 ] i_A,i_B,
    output [WIDTH - 1 : 0 ] o_Bit_Pass,o_Bit_Gen
);

    assign o_Bit_Pass = i_A ^ i_B ;
    assign o_Bit_Gen  = i_A & i_B ;
endmodule