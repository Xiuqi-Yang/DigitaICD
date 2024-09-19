module StateMachine_tb();
reg CIN;
reg A;
reg B;
reg CLK;
reg NRST;
reg rst;
reg start;

wire S;
wire COUT;

parameter N = 1000;//Number of sequeial generated
parameter CLK_T = 50;
parameter DELAY = 50;

//set input_vector
reg[5:0] REG_DATA[N-1:0];//6 input except the clock signal
reg [1:0] state, next_state;
integer Inputstream;
integer i;

StateMachine M1(
	     //inputs
             .CIN(CIN),
             .A(A),
             .B(B),
             .CLK(CLK),
             .NRST(NRST),
             .rst(rst),
             .start(start),
             //outputs
             .S(S),
             .COUT(COUT));

//generate clock signal
initial
  begin
    CLK = 0; 
    //#5;
    forever #CLK_T CLK = !CLK;
   end

//Write in InputVector
initial
  begin
     Inputstream = $fopen("./Check.txt");
     if(!Inputstream) $finish;
     $readmemb("./InputVector.txt", REG_DATA);
  end

initial
  begin
    CIN=0;
    A=0;
    B=0;
    NRST=0;
    #(DELAY);
    $fdisplay(Inputstream,"No\tB\tA\tCIN\tS\tCOUT");   
    for(i=0;i<N;i=i+1)
      begin
	  #5
        {B,A,CIN,start,rst,NRST}=REG_DATA[i];        
        $fdisplay(Inputstream,"%d\t%d\t%d\t%d\t%d\t%d", i, CIN, A, B, S, COUT);
        #(2*DELAY-5);
        //#(2*DELAY);
      end
      $fclose(Inputstream);
      $finish;
end
//

initial
 begin
   #(100*DELAY);
   $finish;
end

endmodule

