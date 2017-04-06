-- zamienia liczby bnc na  dziesietne na wyswietlaczu segmentowym
library ieee;
use ieee.std_logic_1164.all;
entity bnc_na_decimal is 
port(
		data_in1, data_in2, data_in3, data_in4 : in std_logic_vector(3 downto 0);
		wys0, wys1, wys2, wys3						:out std_logic_vector(7 downto 0)

);
end entity;

architecture main of bnc_na_decimal is
	
	begin
	with data_in1 select 
	wys0 <= 	"11000000" when "0000",	-- 0
				"11111001" when "0001", -- 1
				"10100100" when "0010",	-- 2
				"10110000" when "0011", -- 3
				"10011001" when "0100", -- 4
				"10010010" when "0101",	-- 5
				"10000010" when "0110", -- 6
				"11111000" when "0111", -- 7
				"10000000" when "1000", -- 8
				"10010000" when "1001",	-- 9
				"00000000" when others;	-- bug
				
	with data_in2 select 
	wys1 <= 	"11000000" when "0000",	-- 0
				"11111001" when "0001", -- 1
				"10100100" when "0010",	-- 2
				"10110000" when "0011", -- 3
				"10011001" when "0100", -- 4
				"10010010" when "0101",	-- 5
				"10000010" when "0110", -- 6
				"11111000" when "0111", -- 7
				"10000000" when "1000", -- 8
				"10010000" when "1001",	-- 9
				"00000000" when others;	-- bug
	
	with data_in3 select 
	wys2 <= 	"11000000" when "0000",	-- 0
				"11111001" when "0001", -- 1
				"10100100" when "0010",	-- 2
				"10110000" when "0011", -- 3
				"10011001" when "0100", -- 4
				"10010010" when "0101",	-- 5
				"10000010" when "0110", -- 6
				"11111000" when "0111", -- 7
				"10000000" when "1000", -- 8
				"10010000" when "1001",	-- 9
				"00000000" when others;	-- bug
	
	with data_in4 select 
	wys3 <= 	"11000000" when "0000",	-- 0
				"11111001" when "0001", -- 1
				"10100100" when "0010",	-- 2
				"10110000" when "0011", -- 3
				"10011001" when "0100", -- 4
				"10010010" when "0101",	-- 5
				"10000010" when "0110", -- 6
				"11111000" when "0111", -- 7
				"10000000" when "1000", -- 8
				"10010000" when "1001",	-- 9
				"00000000" when others;	-- bug
end architecture;