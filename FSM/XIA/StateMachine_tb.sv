module StateMachine_tb;

    parameter CLK_T = 10;
    parameter N = 8;
    parameter DELAY = 100;
    parameter S0 = 2'd0;
    parameter S1 = 2'd1;
    parameter S2 = 2'd2;
    parameter S3 = 2'd3;
    
    reg A;
    reg B;
    reg CIN;
 
    reg rst;
    reg start;
    reg NRST;
    reg CLK;
 
    wire COUT;
    wire S;
    reg ref_SUM,ref_COUT;
   class i_Packet;
      randc bit [2:0] vector;
      constraint cons { 
                     vector >= 3'b000;
                     vector <= 3'b111;}
   endclass

   i_Packet p;
   StateMachine U1(
               .A(A),
               .B(B),
               .CIN(CIN),
               .rst(rst),
               .start(start),
               .CLK(CLK),
               .NRST(NRST),
               .COUT(COUT),
               .S(S));
 
    initial begin
       CLK = 0;
       forever #(CLK_T/2) CLK = ~CLK;
    end
 
    initial begin
       //Reset
       #1 NRST = 1'b1;
       #1 NRST = 1'b0;
          rst  = 1'b0;
          start = 1'b0;
       #4 NRST = 1'b1;
      repeat(10) begin
         @(posedge CLK) 
            rst = 1'b0;
         data_check();
      end
      
      repeat(10) #CLK_T;
      $finish;
    end
  
   always begin:Drive_data
      @(posedge CLK);
      #1;
      {ref_COUT,ref_SUM} = A+B+CIN;
      @(negedge CLK);
      p=new();
      p.randomize();
      {A,B,CIN} = p.vector;
   end

   task data_check();
      rst = 1;
      `ifdef REG_OUTPUT
       @(posedge CLK);
      #2;
      assert(U1.CS == S0) $display("time:%d,RST right!",$time());
      #(CLK_T/2) rst = 1'b0;

      start = 1'b1;
      @(posedge CLK);
      #2;
      assert(U1.CS == S1) $display("time:%d,SO->S1 right!",$time());
      @(posedge CLK);
      #2;
      assert((S == ref_SUM) && (COUT == 1'b0) ) $display("time:%d,S1:data check right",$time());
      assert(U1.CS == S2) $display("time:%d,S1->S2 right!",$time());

      @(posedge CLK);
      #2;
      assert((S == 1'b0) && (ref_COUT == ref_COUT) ) $display("time:%d,S2:data check right",$time());
      assert(U1.CS == S3) $display("time:%d,S2->S3 right!",$time());

      @(posedge CLK);
      #2;
      assert((S == ref_SUM) && (COUT == ref_COUT) ) $display("time:%d,S3:data check right",$time());
      assert(U1.CS == S1) $display("time:%d,S3->S1 right!",$time());

      @(posedge CLK);
      #2;
      assert((S == ref_SUM) && (COUT == 1'b0) ) $display("time:%d,S1:data check right",$time());
      `else 
      //
       @(posedge CLK);
      #2;
      assert(U1.CS == S0) $display("time:%d,RST right!",$time());
      #(CLK_T/2) rst = 1'b0;

      start = 1'b1;
      @(posedge CLK);
      #2;
      assert(U1.CS == S1) $display("time:%d,SO->S1 right!",$time());
      assert((S == ref_SUM) && (COUT == 1'b0) ) $display("time:%d,S1:data check right",$time());

      @(posedge CLK);
      #2;
      assert(U1.CS == S2) $display("time:%d,S1->S2 right!",$time());
      assert((S == 1'b0) && (ref_COUT == ref_COUT) ) $display("time:%d,S2:data check right",$time());

      @(posedge CLK);
      #2;
      assert(U1.CS == S3) $display("time:%d,S2->S3 right!",$time());
      assert((S == ref_SUM) && (COUT == ref_COUT) ) $display("time:%d,S3:data check right",$time());

      @(posedge CLK);
      #2;
      assert(U1.CS == S1) $display("time:%d,S3->S1 right!",$time());
      assert((S == ref_SUM) && (COUT == 1'b0) ) $display("time:%d,S1:data check right",$time());
      `endif
   endtask

   initial begin
      $fsdbDumpfile("tb.fsdb");
      $fsdbDumpvars();
   end

endmodule