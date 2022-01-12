library ieee;
use ieee.std_logic_1164.all;

entity decoder is
	port(
	K: in std_logic_vector(2 downto 0);
	D: out std_logic_vector(7 downto 0)
	);
end decoder;

architecture hardware of decoder is
begin
	D <= "10000000" when (K="000") else
		  "01000000" when (K="001") else
		  "00100000" when (K="010") else
		  "00010000" when (K="011") else
		  "00001000" when (K="100") else
		  "00000100" when (K="101") else
		  "00000010" when (K="110") else
		  "00000001";
end hardware;