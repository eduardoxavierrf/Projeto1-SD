library ieee;
use ieee.std_logic_1164.all;

entity full_adder is port ( 
	A, B, Cin: in std_logic;
	S, Cout: out std_logic
	);
end full_adder;

architecture teste of full_adder is
signal aux1, aux2: std_logic;
begin
	S <= (A xor B) xor Cin;
	aux1 <= A and B;
	aux2 <= (A xor B) and Cin;
	Cout <= aux1 or aux2;
end teste;