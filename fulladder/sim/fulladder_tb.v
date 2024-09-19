`timescale 1 ns/ 1 ns

module full_add2_tb();
	reg a;
	reg b;
	reg cin;
	reg clk,reset_n;//reset_n:active low
	// wires                                               
	wire cout;
	wire sum;					

parameter CLK_PERIOD = 20;
parameter Delay = 40;
parameter N = 8;


	full_add2 u_full_add2 (  
		.a   	(a),
		.b		(b),
		.cin	(cin),
		.cout	(cout),
		.sum	(sum),
		.clk    (clk),
		.reset_n    (reset_n)
	); 

initial begin
  reset_n = 0;
  #(Delay);
  reset_n = 1;
end

initial begin
  clk = 0;
  forever 
  begin
    #(CLK_PERIOD/2) clk =~clk;
  end
end  
/*
	always@(posedge clk)
	begin
		if(!reset_n)
		begin
			a   <= 0;
			b   <= 0;
			cin <= 0;
		end
		else
		begin
			a   <= {$random}%2;//1 or 0
			b   <= {$random}%2;
			cin <= ($random)%2;
		end
	end
*/

initial 
	begin
		#(10*Delay);
		$finish;
	end
	//always #10 clk = ~clk; //时钟频率50Hz
                                                  
endmodule
