library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;
entity Hub is 
port(
		first 					:IN UNSIGNED (6 downto 0);
		SECOND 					:IN UNSIGNED (6 downto 0);
		wys1,wys2,wys3,wys4 	:out std_logic_vector(3 downto 0)
);

end entity;

architecture sterowanie of Hub is
	
	

		SIGNAL FIRST_NUMBER,SECEND_NUMBER	:INTEGER RANGE 0 TO 100;
		SIGNAL ONE_1,TEEN_1	:INTEGER RANGE 0 TO 10;
		SIGNAL ONE_2,TEEN_2	:INTEGER RANGE 0 TO 10;
		
		BEGIN
		FIRST_NUMBER	<=	TO_INTEGER (UNSIGNED(first));
		SECEND_NUMBER	<=	TO_INTEGER (UNSIGNED(SECOND));
	
			ONE_1 <=FIRST_NUMBER MOD(10);
			TEEN_1 <=(FIRST_NUMBER / 10) MOD(10);
			ONE_2 <=SECEND_NUMBER MOD(10);
			TEEN_2 <=(SECEND_NUMBER / 10) MOD(10);
			
				WITH TEEN_1 SELECT
					WYS3 <=	"0000"	WHEN 0,
								"0001"	WHEN 1,
								"0010"	WHEN 2,
								"0011"	WHEN 3,
								"0100" 	WHEN 4,
								"0101"	WHEN 5,
								"0110"	WHEN 6,
								"0111"	WHEN 7,
								"1000"	WHEN 8,
								"1001"	WHEN 9,	
								"1111"	WHEN OTHERS;
				
				
				WITH ONE_1 SELECT
					WYS4 <=	"0000"	WHEN 0,
								"0001"	WHEN 1,
								"0010"	WHEN 2,
								"0011"	WHEN 3,
								"0100" 	WHEN 4,
								"0101"	WHEN 5,
								"0110"	WHEN 6,
								"0111"	WHEN 7,
								"1000"	WHEN 8,
								"1001"	WHEN 9,	
								"1111"	WHEN OTHERS;
								
					WITH TEEN_2 SELECT
					WYS1 <=	"0000"	WHEN 0,
								"0001"	WHEN 1,
								"0010"	WHEN 2,
								"0011"	WHEN 3,
								"0100" 	WHEN 4,
								"0101"	WHEN 5,
								"0110"	WHEN 6,
								"0111"	WHEN 7,
								"1000"	WHEN 8,
								"1001"	WHEN 9,	
								"1111"	WHEN OTHERS;
				
				
					WITH ONE_2 SELECT
					WYS2 <=	"0000"	WHEN 0,
								"0001"	WHEN 1,
								"0010"	WHEN 2,
								"0011"	WHEN 3,
								"0100" 	WHEN 4,
								"0101"	WHEN 5,
								"0110"	WHEN 6,
								"0111"	WHEN 7,
								"1000"	WHEN 8,
								"1001"	WHEN 9,	
								"1111"	WHEN OTHERS;
				
end architecture;