module FullAdder_tb();
    
    typedef enum {BASIC,OPTIONAL} Question;
    reg CIN,A,B;
    Question q;
    parameter DELAY = 50;
    parameter N     = 8 ;

    reg [2:0] REG_DATA [ 0 : N*(N-1)];
    integer Istream ,file1;

    wire COUT;
    wire S;

    FullAdder u_FullAdder (
        // Inputs
        .A  (A),
        .B  (B),
        .CIN(CIN),
        // Outputs
        .COUT (COUT),
        .S  (S)
    );

    initial begin
        q = OPTIONAL ;//change the enum type q,to get the different inputVector
        Gen_InputVector(q);
        $display("test vector generates successfully!");
        file1 = $fopen("./Check.txt");
        if(!file1) begin
            $display("Not exist Check.txt");
            $finish;
        end
        $readmemb("./InputVector.txt",REG_DATA);
        test_case();
    end

    initial begin
        #(100*DELAY);
        $finish;
    end
    
    // task_description
    task test_case();
        int k,M;
        if(q == BASIC)
            M = N ;
        else
            M = N*(N-1)+1;;
        $display("%d\n",k);
        {CIN,A,B} = 3'b000;
        $fdisplay(file1,"No\tB\tA\tCIN\tCOUT");
        for( k = 0; k<M;k++) begin
            {A,B,CIN} = REG_DATA[k];
            #(DELAY);
            $fdisplay(file1,"Vector%d\t%d\t%d\t%d\t%d\t%d",k,CIN,A,B,S,COUT);
        end
        $fclose(file1);
        $finish;
    endtask : test_case

    // function_description
    function void Gen_InputVector(Question q);
        if(q == OPTIONAL) begin
            int i,j;
            reg [2:0] Vector;
            reg [2:0] initial_Vector;
            Istream = $fopen("./InputVector.txt");
            for( i = 0 ; i<N-1 ; i++) begin
                initial_Vector = i;
                $fdisplay(Istream, "%b",initial_Vector);
                for( j = N - 1 ; j>i+1 ;j--) begin
                    Vector = j;
                    $fdisplay(Istream, "%b",Vector);
                    $fdisplay(Istream, "%b",initial_Vector);
                end
            end
            for( i = N-1 ; i>=0;i--) begin
                Vector = i;
                $fdisplay(Istream,"%b",Vector);
            end
            $fclose(Istream);
        end
        else if(q == BASIC) begin
            int i;
            reg [2:0] Vector;
            Istream = $fopen("./InputVector.txt");
            for (i = 0 ;i<8;i=i+1) begin
                Vector = i;
                $fdisplay(Istream, "%b",Vector);
            end
            $fclose(Istream);
        end
    endfunction : Gen_InputVector;
/*
initial begin
$vcdpluson;
end
*/
endmodule

