LIBRARY IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY RUCH IS
GENERIC(DLUGOSC_ZLICZANIA :INTEGER := 2_000_000);
PORT(
		CLK_IN 		: IN STD_LOGIC;
		CLK_OUT		: OUT STD_LOGIC 

);
END ENTITY;

ARCHITECTURE MAIN OF RUCH IS

	SIGNAL LICZNIK :INTEGER RANGE 0 TO DLUGOSC_ZLICZANIA  + 1:=0;
	SIGNAL STAN 	:STD_LOGIC:= '0';
	
	BEGIN
	
	CLK_OUT <= STAN;
	
	----------------------------------------------------------
		PROCESS(CLK_IN )
			BEGIN
			IF(CLK_IN'EVENT AND CLK_IN = '1') THEN
			
				IF(LICZNIK >= DLUGOSC_ZLICZANIA ) THEN
					LICZNIK <= 0;
				ELSE 
					LICZNIK <= LICZNIK + 1;
				END IF;
			
				IF(LICZNIK = 1) THEN 
					STAN <= NOT STAN; 
				END IF;
			END IF;
		END PROCESS;

END MAIN;