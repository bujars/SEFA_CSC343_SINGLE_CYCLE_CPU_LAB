LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.SEFA_SINGLE_CYCLE_CPU_PACKAGE.ALL;

ENTITY SEFA_NON_LPM_INSTRUCTION_MEMORY IS
PORT(
	SEFA_clock: IN STD_LOGIC;
	SEFA_data: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	SEFA_address: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	SEFA_wren: IN STD_LOGIC;
	SEFA_q: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END SEFA_NON_LPM_INSTRUCTION_MEMORY;


ARCHITECTURE ARCH OF SEFA_NON_LPM_INSTRUCTION_MEMORY IS
	TYPE SEFA_MEMORY IS ARRAY(0 TO 32) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL SEFA_MEM: SEFA_MEMORY := (
	 "10001100000000000000000000000000",  -- LW FROM DATA ADDRESS 0. PUT IN REGISTER 0. 
	 "10001100001000010000000000000001",  --LW FROM DATA ADDRESS 1. PUT IN REGISTER 1. 
	 "01100000000000011000000000000000",  -- MULT THE FIRST TWO REGISERS. RESULT IN REGISTER 16. 
	 "10001100010000100000000000000010",  --LW FROM DATA ADDRESS 2. PUT IN REGISTER 2. 
	 "10001100011000110000000000000011",  --LW FROM DATA ADDRESS 3. PUT IN REGISTER 3. 
	 "01100000010000111000100000000000",  -- MULT REGISTER 2 AND 3. RESULT IN REGISTER 17.
	 "10001100100001000000000000000100",  --LW FROM DATA ADDRESS 4. PUT IN REGISTER 4.
	 "10001100101001010000000000000101",  --LW FROM DATA ADDRESS 5. PUT IN REGISTER 5.
	 "01100000100001011001000000000000",  -- MULT REGISTER 4 AND 5. RESULT IN REGISTER 18.
	 "10001100110001100000000000000110",  --LW FROM DATA ADDRESS 6. PUT IN REGISTER 6.
	 "10001100111001110000000000000111",  --LW FROM DATA ADDRESS 7. PUT IN REGISTER 7.
	 "01100000110001111001100000000000",  -- MULT REGISTER 6 AND 7. RESULT IN REIGSTER 19.
	 "10001101000010000000000000001000",  --LW FROM DATA ADDRESS 8. PUT IN REGISTER 8.
	 "10001101001010010000000000001001",  --LW FROM DATA ADDRESS 9. PUT IN REGISTER 9.
	 "01100001000010011010000000000000",  -- MULT REGISTER 8 AND 9. RESULT IN REGISTER 20.
	 "00000001000010011010100000100000", -- ADD REGISTER 16 AND 17 (FIRST TWO MULTIPLICATIONS). RESULT IN REGISTER 21.
	 "00000010011101001011000000100000", -- ADD REGISTER 18 AND 19 (SECOND TWO MULTIPLICATIONS). RESULT IN REGISTER 22.
	 "00000010101101101011100000100000", -- ADD REGISTER 21 AND 22. RESULT IN REGISTER 23.
	 "00000010010101111100000000100000", -- ADD REGISTER 20 AND 23. RESULT IN REGISTER 24.
	 
	 OTHERS => X"00000000" 
	 
	 
	 -- SOME NOTES ABOUT THE INSTRUCTIONS. SO FOR LOAD, RECALL WE NEED A BASE POINTER AND AN IMMEDIATE.
	 -- HERE WE USE THE REGISTER THAT WE WILL STORE IT AS THE BASE POINTER BECAUSE THE VALUE IS DEFAULTED TO 0
	 -- AND WE INDEX (OFFSET) FROM 0 INCREMENTED BY 1!
	 
	 -- FOR ALL COMPUTATIONS, IM JUST STORING THE RESULT AFTER REGISTER 16 BUT IT CAN BE RIGHT AFTER WE LOAD THE PAIRS.
	 
	 
	 
	 -- NOTE I MADE SOME CHANGES TO THE NUMBERS BECAUSE OF MISCOUNTING. REFER TO THE TOP NUMBERS BUT SPLIT LIKE BELOW FOR CLARITY. 
	 
--	 "100011 00000 00000 0000000000000000",  -- LW FROM DATA ADDRESS 0. PUT IN REGISTER 0. 
--	 "100011 00001 00001 0000000000000001",  --LW FROM DATA ADDRESS 1. PUT IN REGISTER 1. 
--	 "011000 00000 00001 10000 00000 000000",  -- MULT THE FIRST TWO REGISERS. RESULT IN REGISTER 16. 
--	 "100011 00010 00010 0000000000000010",  --LW FROM DATA ADDRESS 2. PUT IN REGISTER 2. 
--	 "100011 00011 00011 0000000000000011",  --LW FROM DATA ADDRESS 3. PUT IN REGISTER 3. 
--	 "011000 00010 00011 10001 00000 000000",  -- MULT REGISTER 2 AND 3. RESULT IN REGISTER 17.
--	 "100011 00100 00100 0000000000000100",  --LW FROM DATA ADDRESS 4. PUT IN REGISTER 4.
--	 "100011 00101 00101 0000000000000101",  --LW FROM DATA ADDRESS 5. PUT IN REGISTER 5.
--	 "011000 00100 00101 10010 00000 000000",  -- MULT REGISTER 4 AND 5. RESULT IN REGISTER 18.
--	 "100011 00110 00110 0000000000000110",  --LW FROM DATA ADDRESS 6. PUT IN REGISTER 6.
--	 "100011 00111 00111 0000000000000111",  --LW FROM DATA ADDRESS 7. PUT IN REGISTER 7.
--	 "011000 00110 00111 10011 00000 000000",  -- MULT REGISTER 6 AND 7. RESULT IN REIGSTER 19.
--	 "100011 01000 01000 0000000000001000",  --LW FROM DATA ADDRESS 8. PUT IN REGISTER 8.
--	 "100011 01001 01001 0000000000001001",  --LW FROM DATA ADDRESS 9. PUT IN REGISTER 9.
--	 "011000 01100 01101 10100 00000 000000",  -- MULT REGISTER 8 AND 9. RESULT IN REGISTER 20.
--	 "000000 10000 10001 10101 00000 100000", -- ADD REGISTER 16 AND 17 (FIRST TWO MULTIPLICATIONS). RESULT IN REGISTER 21.
--	 "000000 10011 10100 10110 00000 100000", -- ADD REGISTER 18 AND 19 (SECOND TWO MULTIPLICATIONS). RESULT IN REGISTER 22.
--	 "000000 10000 10001 10111 00000 100000", -- ADD REGISTER 21 AND 22. RESULT IN REGISTER 23.
--	 "000000 10010 01110 11000 00000 100000", -- ADD REGISTER 20 AND 23. RESULT IN REGISTER 24.
--	 
	 
	);	
BEGIN
	PROCESS(SEFA_clock)
	 BEGIN
		IF (SEFA_clock'EVENT AND SEFA_clock = '1') THEN
			IF(SEFA_wren = '1') THEN
				SEFA_MEM(TO_INTEGER(UNSIGNED(SEFA_address))) <= SEFA_data;
		END IF;
	END IF;
	END PROCESS;
	SEFA_q <= SEFA_MEM(TO_INTEGER(UNSIGNED(SEFA_address)));
END ARCH;