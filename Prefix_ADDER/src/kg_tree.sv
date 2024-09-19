module kg_tree #
(
    parameter WIDTH = 16
)(  
    input  [ WIDTH -1 : 0 ] i_Bit_Pass,i_Bit_Gen,
    output [ WIDTH -1 : 0 ] o_Pass,o_Gen
);
    parameter Level = $clog2(WIDTH) ;//16 :level = 4
    wire [ WIDTH - 1 : 0 ] Node_Pass [0 : Level    ] ;
    wire [ WIDTH - 1 : 0 ] Node_Gen  [0 : Level    ] ;
    
    assign Node_Pass[0] = i_Bit_Pass;
    assign Node_Gen[0]  = i_Bit_Gen ;
    generate 
    for (genvar i = 1 ; i <= Level  ; i++) begin: gen_level // i = level-1 ,j = node
        for (genvar j = 0; j < WIDTH; j++) begin: genblk_node
            if( j < 2**(i-1)) begin:gen_wire
                assign  Node_Pass[i][j] = Node_Pass[i-1][j];
                assign   Node_Gen[i][j] =  Node_Gen[i-1][j];
            end
            else begin:gen_node
            Op_Dot u_Op_Dot (
                // Inputs
                .i_G_High(Node_Gen[i-1][j]),
                .i_G_Low (Node_Gen[i-1][j-2**(i-1)]),
                .i_P_High(Node_Pass[i-1][j]),
                .i_P_Low (Node_Pass[i-1][j-2**(i-1)]),
                // Outputs
                .o_Gen   (Node_Gen[i][j]),
                .o_Pass  (Node_Pass[i][j])
            );
            end
        end
    end
    endgenerate 

    assign o_Pass = Node_Pass[Level];
    assign o_Gen  =  Node_Gen[Level];
endmodule