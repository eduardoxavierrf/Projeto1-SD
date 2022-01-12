library ieee;
use ieee.std_logic_1164.all;

entity testbench is
	generic(
		n: integer:= 4
	);
end;

architecture tb_ULA of testbench is
component ULA
	port (
		Cin: in std_logic;
		A, B: in std_logic_vector(n-1 downto 0);
		K: in std_logic_vector(2 downto 0);
		Cout: out std_logic;
		OV: out std_logic; --Overflow
		Y: out std_logic_vector(n-1 downto 0)
	);
end component;

-- sinais auxiliares

signal c_in, c_out, o_v: std_logic;
signal a_1, b_1, y_1: std_logic_vector(n-1 downto 0);
signal k_aux: std_logic_vector(2 downto 0);

-- código concorrente

begin

-- instância da ula para interconexão do componente com o processo de estimulação

	ULA0: ULA port map (Cin => c_in, A => a_1, B => b_1, K => k_aux, Cout => c_out, OV => o_v, Y => y_1);
	
	estimulo: process
	begin
		wait for 15 ns; c_in <= '0'; a_1 <= "0110"; b_1 <= "0010"; k_aux <= "000";
		wait for 15 ns; k_aux <= "001";
		wait for 15 ns; k_aux <= "010";
		wait for 15 ns; k_aux <= "011";
		wait;
	end process estimulo;
	
end tb_ULA;
	
	
	
	
	
	
	
	
	
	
	
	