library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ster_wys is
port(
		wys0,wys1,wys2,wys3 	:in std_logic_vector(6 downto 0);
		clk						:in std_logic;	-- 50 MHz
		
		wys_out					:out std_logic_vector(6 downto 0);
		d_ster					:out std_logic_vector(3 downto 0)
);
end entity;

architecture zmiana of ster_wys is 

	begin
		process(clk)
			subtype small_int is integer range 0 to 4;
			variable licznik	:small_int:=0;
			begin
			if  rising_edge(clk) then
				if licznik <1 then
				licznik:= licznik + 1;
				wys_out	<=	wys0;
				d_ster<="0111";
			
				elsif licznik <2 then 
				licznik:= licznik + 1;
				wys_out<=wys1;
				d_ster<="1011";
			
				elsif licznik <3 then 
				licznik:= licznik + 1;
				wys_out<=wys2;
				d_ster<="1101";
			
				elsif licznik <4 then 
				licznik:= licznik + 1;
				wys_out<=wys3;
				d_ster<="1110";
			
				else 
				licznik:=0;
			end if;
			end if;
			
		end process;

end architecture;