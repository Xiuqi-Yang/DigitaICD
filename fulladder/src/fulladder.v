module full_add2
(
	input a,     	//加数
	input b,		//被加数
	input cin,		//进位输入
    input clk,
    input reset_n,
	output sum,		//结果输出
	output cout		//进位输出
);
	assign sum = a^b^cin;
	assign cout = (a&b)|((a^b)&cin);
endmodule
