module Op_Dot
    (
        input i_G_Low,i_G_High,
        input i_P_Low,i_P_High,
        output o_Gen,o_Pass
    );

    assign o_Gen = i_G_High | (i_G_Low &i_P_High) ;
    assign o_Pass = i_P_Low & i_P_High;
endmodule