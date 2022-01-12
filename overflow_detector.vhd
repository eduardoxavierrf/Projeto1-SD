library ieee;
use ieee.std_logic_1164.all;

entity overflow_detector is port ( 
	A, B, Z: in std_logic;
	O: out std_logic
	);
end overflow_detector;

architecture hardware of overflow_detector is
begin
	O <= (A and B) xor Z;
end hardware;