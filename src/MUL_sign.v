module MUL_sign 
#(
        parameter WIDTH = 16
)(
    input  signed  [ WIDTH   - 1 : 0 ] i_MUL_A,i_MUL_B,
    output signed  [ 2*WIDTH - 1 : 0 ] o_PRODUCT
);
    assign o_PRODUCT = i_MUL_A * i_MUL_B ;
endmodule