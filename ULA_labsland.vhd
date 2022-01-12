library ieee;
use ieee.std_logic_1164.all;

entity ULA_labsland is
	generic(
		n: integer:= 4
	);
	
	-- K: SW [2 / 0]
	-- A: SW [(2 + n) / 3]
	-- B: SW [(2 + 2n) / (3 + n)]
	-- n maximo: 7
	-- Cout: LEDG(0)
	-- OV: 

	port (
		SW: in std_logic_vector(17 downto 0);
		--KEY: in std_logic_vector(2 downto 0);
		LEDG: out std_logic_vector(0 downto 3);
		HEX3: out std_logic_vector(6 downto 0);
		HEX2: out std_logic_vector(6 downto 0);
		HEX0: out std_logic_vector(6 downto 0)
	);

end ULA_labsland;

architecture teste of ULA_labsland is
component full_adder port (
	A, B, Cin: in std_logic;
	S, Cout: out std_logic
	);
end component;
component overflow_detector port ( 
	A, B, Z: in std_logic;
	O: out std_logic
	);
end component;
component decoder port (
	K: in std_logic_vector(2 downto 0);
	D: out std_logic_vector(7 downto 0)
	);
end component;
component decoder_hex port (
    X: in std_logic_vector(n-1 downto 0);
	H: out std_logic_vector(6 downto 0)
    );
end component;

signal D: std_logic_vector (7 downto 0);

signal aux: std_logic_vector(n downto 0);
signal As: std_logic_vector(n-1 downto 0);
signal Bs: std_logic_vector(n-1 downto 0);
signal Cins: std_logic_vector(n downto 0);
signal Ss: std_logic_vector(n-1 downto 0);
signal K: std_logic_vector(2 downto 0);
signal Y: std_logic_vector(n-1 downto 0);
signal O: std_logic;

signal bit_or_bit: std_logic_vector(n-1 downto 0);
signal bit_and_bit: std_logic_vector(n-1 downto 0);
signal bit_xor_bit: std_logic_vector(n-1 downto 0);
signal bit_nand_bit: std_logic_vector(n-1 downto 0);

signal resultado: std_logic_vector(n-1 downto 0);
signal detect_zero: std_logic_vector(n-1 downto 0);

begin

    K(0) <= SW(0);
    K(1) <= SW(1);
    K(2) <= SW(2);
	Dcd: decoder port map (K => K, D => D);
	
	H1: decoder_hex port map (X => SW((2+n) downto 3), H => HEX3);
	H2: decoder_hex port map (X => SW((2+2*n) downto (3+n)), H => HEX2);

	-- 1 0 0 0 0 0 0 0  =>  soma
	-- 0 1 0 0 0 0 0 0  =>  incremento +1
	-- 0 0 1 0 0 0 0 0  =>  subtração
	-- 0 0 0 1 0 0 0 0  =>  complemento de 2
	-- 0 0 0 0 1 0 0 0  =>
	-- 0 0 0 0 0 1 0 0  =>
	-- 0 0 0 0 0 0 1 0  =>
	-- 0 0 0 0 0 0 0 1  =>

	Cins(0) <= D(6) or D(5) or D(4);

	FA3: for i in 0 to (n-1) generate
		bit_or_bit(i) <= SW(3+i) or SW(3+n+i);
		bit_and_bit(i) <= SW(3+i) and SW(3+n+i);
		bit_xor_bit(i) <= SW(3+i) xor SW(3+n+i);
		bit_nand_bit(i) <= SW(3+i) nand SW(3+n+i);
		
		As(i) <= ( SW(3+i) and (not D(4)) ) or ( (not SW(3+i)) and (not D(7)) and (not D(6)) and (not D(5)) );
		Bs(i) <= ( SW(3+n+i) and (not D(6)) and (not D(4)) and (not D(5)) ) or
					( (not SW(3+n+i)) and (not D(7)) and (not D(6)) and (not D(4)));
		FA3_i: full_adder port map (A => As(i), B => Bs(i), Cin => Cins(i), S => Ss(i), Cout => Cins(i+1));
	end generate;
	
	OVERF: overflow_detector port map (A => SW(3+n-1), B => SW(3+n+n-1), Z => Ss(n-1), O => O);
	
	result: for i in 0 to (n-1) generate
		resultado(i) <= (Ss(i) and (D(7) or D(6) or D(5) or D(4))) or (bit_or_bit(i) and D(3)) or (bit_xor_bit(i) and D(2)) or (bit_and_bit(i) and D(1)) or (bit_nand_bit(i) and D(0));
	end generate;
	
	detect_zero(0) <= resultado(0);
	zero: for i in 1 to (n-1) generate
		detect_zero(i) <= detect_zero(i-1) or resultado(i);
	end generate;

	Y <= resultado;
	H3: decoder_hex port map (X =>Y, H => HEX0);
	LEDG(0) <= Cins(n);
	-- Detecta numeros negativos nas operaçoes de subtraçao e troca de sinal
	LEDG(1) <= Ss(n-1) and (D(4) or D(5));
	-- Detecta overflow na operaçao de subtracao
	LEDG(2) <= O and D(4);
	-- Detecta zeros
	LEDG(3) <= not detect_zero(n-1);
	
	
end teste;