module MatrixMultiplier
    #(
        parameter WIDTH = 8
    )(
        input                            NRST,CLK,START,
        input      signed [WIDTH - 1: 0] A,B,
        output     signed [2*WIDTH  : 0] OUT,
        output reg                       OUT_STROBE
    );
    localparam IDLE       = 4'b0000;
    localparam MUL_STAGE1 = 4'b0010;
    localparam MUL_STAGE2 = 4'b0100;
    localparam OUT_STAGE  = 4'b1000;

    reg [3:0] Current_State,Next_State;

    reg EN1,EN2,EN3 ;
    wire signed  [2*WIDTH - 1 : 0] MUL_PRODUCT ;
    wire signed  [2*WIDTH     : 0] SUM         ;
    wire  signed  [2*WIDTH - 1 : 0] MUL_PRODUCT_REG0,MUL_PRODUCT_REG1;

    reg out_valid ;
    assign OUT_STROBE = out_valid;
    //state machine
    always@( posedge CLK or negedge NRST ) begin:State_transfer
        if(!NRST)
            Current_State <= #1 IDLE ;
        else
            Current_State <= #1 Next_State;
    end
    always @(*) begin:State_Comb
        case(Current_State)
        IDLE       : begin Next_State    = START ? MUL_STAGE1 : IDLE ;
            {EN1,EN2,EN3} = 3'b000 ;
            out_valid = 1'b0;
        end
        MUL_STAGE1 : begin Next_State    = MUL_STAGE2 ;
            {EN1,EN2,EN3} =  3'b100 ;
            out_valid = 1'b0;
        end
        MUL_STAGE2 :begin Next_State = OUT_STAGE ;
            {EN1,EN2,EN3} =  3'b110 ;
            out_valid = 1'b0;
        end
        OUT_STAGE  :begin Next_State = MUL_STAGE1 ;
            {EN1,EN2,EN3} =  3'b001 ;
            out_valid = 1'b1;
        end
        endcase
        end

    wire [ WIDTH   - 1 : 0 ] i_MUL_A;
    wire [ WIDTH   - 1 : 0 ] i_MUL_B;
    wire [ 2*WIDTH - 1 : 0 ] o_PRODUCT;

    assign {i_MUL_A,i_MUL_B} = {A,B};

    MUL_sign #(
        .WIDTH(WIDTH)
    )
    u_MUL_sign (
        // Inputs
        .i_MUL_A  (i_MUL_A[WIDTH-1:0]),
        .i_MUL_B  (i_MUL_B[WIDTH-1:0]),
        // Outputs
        .o_PRODUCT(o_PRODUCT[2*WIDTH-1:0])
    );

    assign MUL_PRODUCT = o_PRODUCT;

    localparam MUL_REG_N = 2*WIDTH;

    flip_flop #(
        .N(MUL_REG_N)
    )
    u_filp_flop_mulreg0 (
        // Inputs
        .CLK    (CLK),
        .EN     (EN1),
        .NRST   (NRST),
        .in     (MUL_PRODUCT),
        // Outputs
        .out_reg(MUL_PRODUCT_REG0)
    );
 //mul reg 1

    flip_flop #(
        .N(MUL_REG_N)
    )
    u_filp_flop_mulreg1 (
        // Inputs
        .CLK    (CLK),
        .EN     (EN2),
        .NRST   (NRST),
        .in     (MUL_PRODUCT_REG0),
        // Outputs
        .out_reg(MUL_PRODUCT_REG1)
    );

    localparam ADD_WIDTH = 2*WIDTH + 1;


    Adder_sign #(
        .WIDTH(ADD_WIDTH)
    )
    u_Adder_sign (
        // Inputs
        .i_ADD_A({MUL_PRODUCT_REG0[MUL_REG_N-1],MUL_PRODUCT_REG0}),
        .i_ADD_B({MUL_PRODUCT_REG1[MUL_REG_N-1],MUL_PRODUCT_REG1}),
        // Outputs
        .o_SUM  (SUM)
    );


    flip_flop #(
        .N(ADD_WIDTH)
    )
    u_flip_flop (
        // Inputs
        .CLK    (CLK),
        .EN     (EN3),
        .NRST   (NRST),
        .in     (SUM),
        // Outputs
        .out_reg(OUT)
    );
    
endmodule
