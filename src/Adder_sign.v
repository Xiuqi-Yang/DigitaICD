module Adder_sign#
    (
        parameter  WIDTH = 16
    )(
        input  signed [WIDTH -1 : 0 ] i_ADD_A,i_ADD_B,
        output signed [WIDTH -1 : 0 ] o_SUM
    );
    
    assign o_SUM =  i_ADD_A + i_ADD_B;
endmodule