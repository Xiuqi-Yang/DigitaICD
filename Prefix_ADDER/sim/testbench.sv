module testbench();

    parameter WIDTH = 64 ;

    logic i_CI;
    logic [WIDTH - 1 : 0] i_A;
    logic [WIDTH - 1 : 0] i_B;
    logic [WIDTH - 1 : 0] o_SUM;
    logic o_CO;

    Prefix_adder #(
        .WIDTH(WIDTH)
    )
    u_Prefix_adder (
        // Inputs
        .i_A  (i_A[WIDTH-1:0]),
        .i_B  (i_B[WIDTH-1:0]),
        .i_CI (i_CI),
        // Outputs
        .o_CO (o_CO),
        .o_SUM(o_SUM[WIDTH-1:0])
    );
    
    bit [WIDTH - 1 :0] ref_SUM;
    bit ref_CO;
    int Error_CNT;

    initial begin
        repeat(10000) begin
            #3 Op_Gen(i_A, i_B, i_CI);
            #1 Compare(i_A, i_B, o_SUM, o_CO, i_CI);
        end
        assert(Error_CNT == 0) begin
            $display("test case all Pass");
        end
        else begin
            $display("Errors happend %d times",Error_CNT);
        end
        $finish;
    end

    // function_description
    task Compare(input bit [WIDTH - 1 :0] i_A,i_B,o_SUM,
            input bit o_CO,i_CI );
        {ref_CO,ref_SUM} = i_A + i_B + i_CI;
        if((ref_CO == o_CO)) begin
            $display("Carry_Righ!");
        end
        else begin
            $display("Carry_Wrong!");
            Error_CNT = Error_CNT + 1;
        end
        if((ref_SUM == o_SUM)) begin
            $display("SUM_Righ!");
        end
        else begin
            $display("SUM_Wrong!");
            Error_CNT = Error_CNT + 1;
        end
    endtask : Compare

    // task_description
    task Op_Gen(
            output [WIDTH - 1 :0] i_A,i_B,
            output i_CI
        );
        i_A = $random($time());
        i_B = $random($time()*$time());
        i_CI = $random($time()*$time()*$time());
    endtask : Op_Gen
    
    initial begin
        $fsdbDumpfile("testbench.fsdb");
        $fsdbDumpMDA();
        $fsdbDumpvars();
    end
endmodule



