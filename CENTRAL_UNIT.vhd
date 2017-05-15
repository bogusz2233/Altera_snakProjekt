LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use WORK.KSZTALTY.ALL;
use WORK.FUNCTIONS.ALL;

ENTITY CENTRAL_UNIT IS
PORT(
---------------------------------------------------------------------------
------------------------WYSWIETLANIE---------------------------------------
---------------------------------------------------------------------------
		
			VPOS					:IN STD_LOGIC_VECTOR(10 DOWNTO 0);
			HPOS					:IN STD_LOGIC_VECTOR(10 DOWNTO 0);
			RGB					:OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
			CLK					:IN STD_LOGIC;
			
---------------------------------------------------------------------------
------------------------RUCH--PLAYER---------------------------------------
---------------------------------------------------------------------------

			UP,DOWN,LFT,RGT 	:IN STD_LOGIC;
			CLK_RUCH				:IN STD_LOGIC;-- SPRAWDZENIE CZY JAKIŚ PRZYCISK RUCHU JEST WCISNIETY
			CLK_ZMIANA			:IN STD_LOGIC; -- ZMIANA POŁOZENIE  PLAYER, ZMIANA, TAKTOWANIE CALEJ LOGIKI GRY
			
			-------TESTOWY CZY GRACZ WSZEDL NA COINS ----
			TEST_1 				:OUT STD_LOGIC;
			----WEJSCIE RESETUJACE GRE----------
			RESET					:IN STD_LOGIC;
			WYS_SEG7_2			:OUT UNSIGNED(6 DOWNTO 0);
			WYS_SEG7_1			:OUT UNSIGNED(6 DOWNTO 0);
			RAND_LICZNIK		:IN  UNSIGNED(0 TO 5)
		);
-----------------------------------------------------------------------



END CENTRAL_UNIT;

ARCHITECTURE MAIN OF CENTRAL_UNIT IS

-- resolution  640x480 

		SIGNAL X, Y 		:INTEGER RANGE 0 TO 2000;
		-----------logic position of plaYER------------------------------------------------
		SHARED VARIABLE PLY_X					:INTEGER RANGE -1 TO 17 :=8;
		SHARED VARIABLE PLY_Y					:INTEGER RANGE -1 TO 17 :=8;
		-----------logic position of MONSTER-----------------------------------------------
		SHARED VARIABLE CON_X					:INTEGER RANGE -1 TO 17 :=(TO_INTEGER (UNSIGNED(RAND_LICZNIK)));
		SHARED VARIABLE CON_Y					:INTEGER RANGE -1 TO 17 
		:=((TO_INTEGER (UNSIGNED(RAND_LICZNIK)))*(TO_INTEGER (UNSIGNED(RAND_LICZNIK)))) mod(16);
		
		--PARAMETRY PLAYERA POZYCJA I ROZMIAR
		SHARED VARIABLE SIZE_X 					:INTEGER :=25;
		SHARED VARIABLE SIZE_Y					:INTEGER :=25;
		SHARED VARIABLE POSITION_X 			:INTEGER RANGE -100 TO 640 :=120 + PLY_X * SIZE_X ;
		SHARED VARIABLE POSITION_Y 			:INTEGER RANGE -100 TO 480 :=40 + PLY_Y * SIZE_Y;

		
		SIGNAL DRAW_PLAYER 						:STD_LOGIC;
-------KIERUNEK PORUSZANIEQSIE PLAYERA-------------
		SIGNAL DIR_U, DIR_D, DIR_L, DIR_R	:STD_LOGIC :='0';
-----------------------------------------------------
------TLO--------------------------------------------
		SIGNAL DRAW_BACKGROUND					:STD_LOGIC;
		SHARED VARIABLE POSITIONBCK_X			:INTEGER RANGE 90 TO 150:=120;
		SHARED VARIABLE POSITIONBCK_Y			:INTEGER RANGE 20 TO 50:=40;
		SHARED VARIABLE SIZEBCK_X				:INTEGER RANGE 300 TO 500:=400;
		SHARED VARIABLE SIZEBCK_Y				:INTEGER RANGE 200 TO 500:=400;
-----------------------------------------------------		
-----------------------------------------------------
		SHARED VARIABLE SIZEC_X 				:INTEGER :=12;
		SHARED VARIABLE SIZEC_Y					:INTEGER :=12;
		SHARED VARIABLE POSITIONC_X 			:INTEGER RANGE -100 TO 640 :=120 + CON_X * (2 * (SIZEC_X) + 1);
		SHARED VARIABLE POSITIONC_Y 			:INTEGER RANGE -100 TO 480 :=40 + CON_Y * (2 * (SIZEC_Y) + 1);
		SIGNAL DRAW_COINS							:STD_LOGIC;
-----------------------------------------------------		
-----------------------------------------------------
		SIGNAL DRAW_OGON							:STD_LOGIC;
		SHARED VARIABLE POSITIONOGON_X		:INTEGER RANGE 90 TO 640;
		SHARED VARIABLE POSITIONOGON_Y		:INTEGER RANGE 20 TO 480;
		SHARED VARIABLE SIZEOGON_X				:INTEGER :=25;
		SHARED VARIABLE SIZEOGON_Y				:INTEGER :=25;
		
		SIGNAL PUNKTY		:INTEGER RANGE 0 TO 100 :=0;
		
		type T_2D is array (0 to 40, 0 to 1) of integer range -1 to 20; 	---  	|	x_position	| 	--- 20 means empty
		signal ogon_tab : T_2D;										---	|	y_position	|	---
-----------------------------------------------------
-----------------------------------------------------


		BEGIN
		-- aktualna pozycja rendowanego pisksela
		X 	<=	TO_INTEGER (UNSIGNED(HPOS));
		Y	<=	TO_INTEGER (UNSIGNED(VPOS));
	
		-------LICZENIE POZYCJI NA EKRANIE W PIKSELACH---------------------------------------
		
		
		
		PLAYER: PROSTOKAT(SIZE_X, SIZE_Y,POSITION_X , POSITION_Y, X, Y, DRAW_PLAYER);
		TLO	: PROSTOKAT(SIZEBCK_X, SIZEBCK_Y, POSITIONBCK_X, POSITIONBCK_Y, X, Y, DRAW_BACKGROUND);
		
		COINS : CIRCLE(SIZEC_X, POSITIONC_X, POSITIONC_Y, X, Y, DRAW_COINS);
		
		
		DRAWING: PROCESS(CLK)
			VARIABLE OGON_PIKSEL :BOOLEAN;
			BEGIN
					--MALUJEMY OGON
					OGON_PIKSEL := FALSE;
					for I in 0 to 40 loop
						IF((((POSITIONBCK_X + ogon_tab(I, 0) * SIZE_X ) < X ) 			AND
						((POSITIONBCK_X + ogon_tab(I, 0) * SIZE_X +  SIZE_X) > X  ))	AND
						((POSITIONBCK_Y + ogon_tab(I, 1) * SIZE_Y ) < Y )  				AND
						((POSITIONBCK_Y + ogon_tab(I, 1) * SIZE_Y + SIZE_Y) > Y  ))	
						THEN OGON_PIKSEL := TRUE;
						END IF;
					end loop;	
					
					IF(DRAW_PLAYER = '1') 	THEN 
						RGB<="100";
					ELSIF(OGON_PIKSEL)		THEN
							RGB<="010";
					ELSIF(DRAW_COINS ='1') 	THEN
						RGB<="001";
					ELSIF (DRAW_BACKGROUND	='1') THEN
						RGB<="000";
					ELSE 
						RGB<="111";
					END IF;
						
			END PROCESS;
---------------------------- RUCH  ------------------------
----------------------UP,DOWN,LFT,RGT ---------------------
		STERING: PROCESS(CLK_RUCH)
			BEGIN
			
				IF(RESET = '1' )THEN 
					DIR_U <='0';
					DIR_D <='0';
					DIR_L <='0';
					DIR_R <='0';
				ELSIF(CLK_RUCH'EVENT AND CLK_RUCH ='1') THEN
					IF UP = '1' OR DOWN = '1' OR LFT = '1' OR RGT = '1' THEN
						DIR_U <='0';
						DIR_D <='0';
						DIR_L <='0';
						DIR_R <='0';
						IF UP ='1' THEN 
							DIR_U <='1';
						END IF;
						
						IF DOWN ='1' THEN 
							DIR_D <='1';
						END IF;
						
						IF LFT ='1' THEN 
							DIR_L <='1';
						END IF;
						
						IF RGT ='1' THEN 
							DIR_R <='1';
						END IF;
					END IF;
				END IF;
		END PROCESS;
----------------------------------------------------------------------------------
----------------------------------------------------------------------------------


	UPDATE: PROCESS(CLK_ZMIANA)
		
		
		VARIABLE DZIESIATKI 	:INTEGER RANGE 0 TO 100 :=0;
		VARIABLE TYSIACE 		:INTEGER RANGE 0 TO 100 :=0;
		
		--RUCH CIAGLE O 20 PIKSELI
			BEGIN
			IF(RESET = '1')THEN 
				PLY_Y	:= 8;
				PLY_X := 8;
				CON_X :=(TO_INTEGER (UNSIGNED(RAND_LICZNIK)));
				CON_Y :=((TO_INTEGER (UNSIGNED(RAND_LICZNIK))) * (TO_INTEGER (UNSIGNED(RAND_LICZNIK)))) MOD(16);
				PUNKTY <= 0;
				for I in 0 to 40 loop
					for IA in 0 to 1 loop
						ogon_tab(I,IA) <= 20;
					end loop;
				end loop;
			ELSIF(CLK_ZMIANA'EVENT AND CLK_ZMIANA ='1') THEN
			
				--------ogon----------------------------------------------
			-----------------------------------------------------
				for I in 0 to 39 loop
					IF I < PUNKTY THEN
						ogon_tab(I +1,0) <= ogon_tab(I,0);
						ogon_tab(I +1,1) <= ogon_tab(I,1);
					END IF;
				end loop;	
			
			ogon_tab(0,0) <= PLY_X;
			ogon_tab(0,1) <= PLY_Y;
			
			---ZMIANA POŁOZENIA GRACZA-----------------------
				IF DIR_U = '1' THEN
					PLY_Y := PLY_Y - 1;
				ELSIF DIR_D = '1' THEN
					PLY_Y := PLY_Y + 1;
				ELSIF DIR_L ='1' THEN 
					PLY_X := PLY_X - 1;
				ELSIF DIR_R = '1'THEN 
					PLY_X := PLY_X + 1;
				END IF;
				
									----OGRANIECZENIE REGIONU DO PORUSZANIA---------------------
			IF(PLY_Y < 0) 		THEN PLY_Y :=15;
			ELSIF(PLY_Y > 15) THEN PLY_Y :=0;
			END IF;
			
			IF(PLY_X < 0) 		THEN PLY_X :=15;
			ELSIF(PLY_X > 15) THEN PLY_X :=0;
			END IF;
		
			-----------------------------------------------
			
			
			POSITION_X := POSITIONBCK_X + PLY_X * SIZE_X;
			POSITION_Y := POSITIONBCK_Y + PLY_Y * SIZE_Y;
			
		
			
			POSITIONC_X := POSITIONBCK_X + CON_X * (2 * SIZEC_X + 1);
			POSITIONC_Y := POSITIONBCK_Y + CON_Y * (2 * SIZEC_Y + 1);
			IF((CON_X = PLY_X) AND (CON_Y = PLY_Y)) THEN
				CON_X :=(TO_INTEGER (UNSIGNED(RAND_LICZNIK)));
				CON_Y :=((TO_INTEGER (UNSIGNED(RAND_LICZNIK))) * (TO_INTEGER (UNSIGNED(RAND_LICZNIK)))) MOD(16);
				PUNKTY <= PUNKTY + 1;
				
			END IF;
			
			TYSIACE := PUNKTY /100;
			DZIESIATKI := PUNKTY - (TYSIACE * 100);
			WYS_SEG7_1	<=TO_UNSIGNED(DZIESIATKI ,7);
			WYS_SEG7_2	<=TO_UNSIGNED(TYSIACE ,7);
		END IF;
			
			
	
	END PROCESS;	

END MAIN;
