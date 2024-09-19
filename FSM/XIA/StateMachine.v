module StateMachine(
    input CLK,NRST,rst,start,
    input CIN,A,B,
    output  S,COUT
);


    parameter S0 = 2'd0;
    parameter S1 = 2'd1;
    parameter S2 = 2'd2;
    parameter S3 = 2'd3;

`ifdef REG_OUTPUT
    reg S_inter,COUT_inter,S_inter_REG,COUT_inter_REG;
    reg [3:0] CS,NS;
    reg sum,co;
`else
    reg S_inter,COUT_inter;
    reg [3:0] CS,NS;
    reg sum,co;
`endif
    //ADDER
    assign {CO,SUM} = A+B+CIN
    ;

    //State Transfer
    always@(posedge CLK or negedge NRST) begin
        if(~NRST) 
            CS <= S0;
        else
            CS <= NS;
    end
    
    //Output Comb
    always@(*) begin
        case(CS)
        S0:begin
            NS = start ? S1:S0;
            {S_inter,COUT_inter} = 2'b00;
        end
        S1:begin
            NS = rst ? S0:S2;
            {S_inter,COUT_inter} ={SUM,1'b0};
        end
        S2: begin
            NS = rst ? S0:S3;
            {S_inter,COUT_inter} ={1'b0,CO};
        end
        S3: begin
            NS = rst ? S0:S1;
            {S_inter,COUT_inter} ={SUM,CO};
        end
        endcase
    end



`ifdef REG_OUTPUT // register output
    always@(posedge CLK or negedge NRST)  begin
        if(!NRST)
            {COUT_inter_REG,S_inter_REG} <= 2'b00;
        else
            {COUT_inter_REG,S_inter_REG} <= {COUT_inter,S_inter};
    end
    assign {COUT,S} = {COUT_inter_REG,S_inter_REG};
`else //output
    assign {COUT,S} = {COUT_inter,S_inter};
`endif 

endmodule