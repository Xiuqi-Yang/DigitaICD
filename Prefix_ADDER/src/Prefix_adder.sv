module Prefix_adder
#(
        parameter WIDTH = 16
)(
    input i_CI,
    input  [WIDTH - 1 : 0] i_A,i_B ,
    output [WIDTH - 1 : 0] o_SUM   ,
    output o_CO
);


    wire [WIDTH - 1 : 0 ] o_Bit_Pass;
    wire [WIDTH - 1 : 0 ] o_Bit_Gen;

    pg_code #(
        .WIDTH(WIDTH)
    )
    u_pg_code (
        // Inputs
        .i_A       (i_A[WIDTH-1:0]),
        .i_B       (i_B[WIDTH-1:0]),
        // Outputs
        .o_Bit_Gen (o_Bit_Gen[WIDTH-1:0]),
        .o_Bit_Pass(o_Bit_Pass[WIDTH-1:0])
    );

    wire [ WIDTH -1 : 0 ] i_Bit_Pass;
    wire [ WIDTH -1 : 0 ] i_Bit_Gen;
    wire [ WIDTH -1 : 0 ] o_Pass;
    wire [ WIDTH -1 : 0 ] o_Gen;
    assign i_Bit_Pass = o_Bit_Pass;
    assign i_Bit_Gen  = o_Bit_Gen ;

    kg_tree #(
        .WIDTH(WIDTH)
    )
    u_kg_tree (
        // Inputs
        .i_Bit_Gen (i_Bit_Gen[WIDTH-1:0]),
        .i_Bit_Pass(i_Bit_Pass[WIDTH-1:0]),
        // Outputs
        .o_Gen     (o_Gen[WIDTH-1:0]),
        .o_Pass    (o_Pass[WIDTH-1:0])
    );

    wire [WIDTH - 1 : 0] i_Pre_Pass;
    wire [WIDTH - 1 : 0] i_Pre_Gen;
    wire [WIDTH - 1 : 0] o_Bit_Carry;

    assign i_Pre_Pass = o_Pass;
    assign i_Pre_Gen  = o_Gen ;

    Carry_Gen #(
        .WIDTH(WIDTH)
    )
    u_Carry_Gen (
        // Inputs
        .i_CI       (i_CI),
        .i_Pre_Gen  (i_Pre_Gen[WIDTH-1:0]),
        .i_Pre_Pass (i_Pre_Pass[WIDTH-1:0]),
        // Outputs
        .o_Bit_Carry(o_Bit_Carry[WIDTH-1:0])
    );

    assign o_SUM = o_Bit_Pass ^ {o_Bit_Carry[WIDTH-2 : 0],i_CI};
    assign o_CO  = o_Bit_Carry[WIDTH - 1];

endmodule