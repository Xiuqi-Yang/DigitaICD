module flip_flop
    #(
        parameter N = 16
    )(
        input  CLK,EN,NRST,
        input  [ N - 1 :0 ] in,
        output reg [ N - 1 : 0] out_reg
    );

        always@(posedge CLK or negedge NRST)
            if(!NRST) 
                out_reg <= 'b0;
            else if(EN)
                out_reg <= #1 in  ;
            else
                out_reg <= #1 out_reg;
endmodule