library IEEE;
use IEEE.std_logic_1164.all;
use work.SEFA_SINGLE_CYCLE_CPU_PACKAGE.all;



-- THIS IS THE ALU COMPONENT. HERE WE GET OUR TWO INPUTS
-- RECALL INPUTS ARE BUS A AND BUS B OR EXT(IMM)
-- WE PERFORM ALL ALU OPERATIONS AND THEN PASS RESULTS INTO ALU MUX TO RETURN THE RESULT BASED ON CODE. 

-- NOTE FOR IMMEDIATE COMPUTATIONS, THE VALUE WILL ALREADY BE EXTENDED BEFORE COMING INTO THE ALU!
-- THUS WE CAN REPURPOSE COMPONENTS FOR EXTENDED IMMEDIATES. 

ENTITY SEFA_ALU IS 
GENERIC(SEFA_N : INTEGER := 32);
PORT(
--	SEFA_OPCODE : IN STD_LOGIC_VECTOR(5 DOWNTO 0);  -- note I am removing these as ALU op is what determines which operation to perform. AluOp is determined by OpCode and Funct in CPUController. 
--	SEFA_FUNCT : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
	SEFA_ALUctr : IN STD_LOGIC_VECTOR(3 DOWNTO 0); -- Currently setting as 4 bits wide as we don't have that many instructions.
	SEFA_INPUT_A : IN STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
	SEFA_INPUT_B : IN STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
	SEFA_ALU_OUTPUT : OUT STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
	SEFA_HI : OUT STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
	SEFA_LO : OUT STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0)
	-- NOTE IM NOT SURE HOW WE ARE GOING TO DO OUTPUT FOR MUL/DIV WHICH IS 64 BITS.......FOR NOW IGNORING.
	-- pOSSIBLY HAVE TWO OUTPUTS ONE
	-- MULT: FIRST HAS FIRST 32 BITS SECOND HAS SECOND 32 BITS
	-- DIV: FIRST HAS QUOT SECOND HAS REMAINDER
	-- FOR OTHER OPERATIONS WE ONLY FOCUS ON MAIN ONE. 
);
END SEFA_ALU;

ARCHITECTURE ARCH OF SEFA_ALU IS

SIGNAL SEFA_ADD : STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
SIGNAL SEFA_SUB : STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);

---- MULTI AND DIVIDE WE NEED TO SPLIT UP
--SIGNAL SEFA_MULT: STD_LOGIC_VECTOR(SEFA_N*2-1 DOWNTO 0);
--SIGNAL SEFA_DIV: STD_LOGIC_VECTOR(SEFA_N*2-1 DOWNTO 0);

SIGNAL SEFA_AND : STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
SIGNAL SEFA_OR : STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
SIGNAL SEFA_NOR : STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
SIGNAL SEFA_SLL : STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
SIGNAL SEFA_SRL : STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0); 
SIGNAL SEFA_SRA: STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
SIGNAL SEFA_ADDU : STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
SIGNAL SEFA_SUBU: STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
SIGNAL SEFA_ADDI: STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
SIGNAL SEFA_ADDIU: STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
SIGNAL SEFA_ANDI: STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
SIGNAL SEFA_ORI: STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);

-- Do we need overflow?
SIGNAL SEFA_ADD_OVERFLOW : STD_LOGIC;
SIGNAL SEFA_SUB_OVERFLOW : STD_LOGIC;
SIGNAL SEFA_ADDI_OVERFLOW : STD_LOGIC;

--- FOR MULTIPLICATION
SIGNAL SEFA_MULT : STD_LOGIC_VECTOR(63 DOWNTO 0); -- NOTE 64 BIT OUTPUT
SIGNAL SEFA_DIVIDE_QUOTIENT : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL SEFA_DIVIDE_REMAINDER : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

-- SIGNED ADD/SUB/ADDI

	SEFA_ADD_COMPUTE : SEFA_SIGNED_LPM_ADD_SUB PORT MAP (SEFA_add_sub => '1', SEFA_dataa => SEFA_INPUT_A, SEFA_datab=> SEFA_INPUT_B, SEFA_overflow => SEFA_ADD_OVERFLOW, SEFA_result=> SEFA_ADD);
	SEFA_SUB_COMPUTE : SEFA_SIGNED_LPM_ADD_SUB PORT MAP (SEFA_add_sub => '0', SEFA_dataa=> SEFA_INPUT_A, SEFA_datab=> SEFA_INPUT_B, SEFA_overflow=> SEFA_SUB_OVERFLOW, SEFA_result=> SEFA_SUB);
	SEFA_ADDI_COMPUTE : SEFA_SIGNED_LPM_ADD_SUB PORT MAP (SEFA_add_sub => '1', SEFA_dataa => SEFA_INPUT_A, SEFA_datab=> SEFA_INPUT_B, SEFA_overflow => SEFA_ADDI_OVERFLOW, SEFA_result=> SEFA_ADDI);

-- UNSIGNED ADDU/SUBU/ADDIU
	
	SEFA_ADDU_COMPUTE : SEFA_UNSIGNED_LPM_ADD_SUB PORT MAP (SEFA_add_sub => '1', SEFA_dataa=> SEFA_INPUT_A, SEFA_datab=> SEFA_INPUT_B, SEFA_result=> SEFA_ADDU);
	SEFA_SUBU_COMPUTE : SEFA_UNSIGNED_LPM_ADD_SUB PORT MAP (SEFA_add_sub => '0', SEFA_dataa=> SEFA_INPUT_A, SEFA_datab=> SEFA_INPUT_B, SEFA_result=> SEFA_SUBU);
	SEFA_ADDIU_COMPUTE : SEFA_UNSIGNED_LPM_ADD_SUB PORT MAP (SEFA_add_sub => '1', SEFA_dataa=> SEFA_INPUT_A, SEFA_datab=> SEFA_INPUT_B, SEFA_result=> SEFA_ADDIU);

	
-- BOOLEAN
	
	SEFA_AND_COMPUTE : SEFA_AND_COMPONENT PORT MAP (SEFA_INPUT_A => SEFA_INPUT_A, SEFA_INPUT_B => SEFA_INPUT_B, SEFA_AND_RESULT => SEFA_AND);
	SEFA_OR_COMPUTE : SEFA_OR_COMPONENT PORT MAP (SEFA_INPUT_A => SEFA_INPUT_A, SEFA_INPUT_B => SEFA_INPUT_B, SEFA_OR_RESULT => SEFA_OR);
	SEFA_NOR_COMPUTE : SEFA_NOR_COMPONENT PORT MAP (SEFA_INPUT_A => SEFA_INPUT_A, SEFA_INPUT_B => SEFA_INPUT_B, SEFA_NOR_RESULT => SEFA_NOR);
	
	SEFA_ANDI_COMPUTE : SEFA_AND_COMPONENT PORT MAP (SEFA_INPUT_A => SEFA_INPUT_A, SEFA_INPUT_B => SEFA_INPUT_B, SEFA_AND_RESULT => SEFA_ANDI);
	SEFA_ORI_COMPUTE : SEFA_OR_COMPONENT PORT MAP (SEFA_INPUT_A => SEFA_INPUT_A, SEFA_INPUT_B => SEFA_INPUT_B, SEFA_OR_RESULT => SEFA_ORI);

	
	
-- MULTIPLICATION/DIVISION

	SEFA_MULT_COMPUTE : SEFA_LPM_MULT PORT MAP
	(
		SEFA_dataa => SEFA_INPUT_A,
		SEFA_datab => SEFA_INPUT_B,
		SEFA_result => SEFA_MULT
	);
	
	SEFA_DIVIDE_COMPUTE : SEFA_LPM_DIVIDE PORT MAP 
	(
		SEFA_denom => SEFA_INPUT_B,
		SEFA_numer => SEFA_INPUT_A,
		SEFA_quotient => SEFA_DIVIDE_QUOTIENT,
		SEFA_remain	=> SEFA_DIVIDE_REMAINDER
	);
	

-- FINALLY PICK THE RESULT EXCLUDING MULTIPLICATION AND DIVISION. 
	SEFA_ALU_MUX_OUTPUT : SEFA_ALU_MUX PORT MAP (
--			SEFA_oPCODE => SEFA_OPCODE, 
--			SEFA_FUNCT => SEFA_FUNCT,
			SEFA_ALUctr => SEFA_ALUctr,
			SEFA_ADD => SEFA_ADD, 
			SEFA_SUB => SEFA_SUB, 
			SEFA_AND => sEFA_AND,
			SEFA_OR => SEFA_OR,
			SEFA_NOR => SEFA_NOR,
			SEFA_ADDU => SEFA_ADDU,
			SEFA_SUBU => SEFA_SUBU,
			SEFA_ADDI => SEFA_ADDI,
			SEFA_ADDIU => SEFA_ADDIU,
			SEFA_ANDI => SEFA_ANDI,
			SEFA_ORI => SEFA_ORI,
			SEFA_MULT => SEFA_MULT, -- NEED TO ADD THIS HERE SO WE CAN TAKE OUT THE ALU OUTPUT (LO) PART. 
			SEFA_DIVIDE_QUOTIENT => SEFA_DIVIDE_QUOTIENT, 
			SEFA_DIVIDE_REMAINDER => SEFA_DIVIDE_REMAINDER,
			SEFA_ALU_RESULT => SEFA_ALU_OUTPUT);
	

	-- HANDLE THE MULTIPLICATION DIVISION RESULT SEPERATELY.
	-- THIS COULD ALSO BE MOVED INTO ITS OWN FILE OR BE COMBINED WITH
	-- ALU MUX OUTPUT. 
	PROCESS(SEFA_ALUctr ,SEFA_MULT, SEFA_DIVIDE_QUOTIENT, SEFA_DIVIDE_REMAINDER)
	BEGIN
		CASE SEFA_ALUctr IS 
			WHEN "1101" =>
				-- MULTIPLY
				SEFA_HI <= SEFA_MULT(63 DOWNTO 32);
				SEFA_LO <= SEFA_MULT(31 DOWNTO 0);
			WHEN "1110" => 
				-- DIVIDE
				SEFA_HI <= SEFA_DIVIDE_QUOTIENT;
				SEFA_LO <= SEFA_DIVIDE_REMAINDER;
			WHEN OTHERS =>
				SEFA_HI <= (OTHERS => 'X');
				SEFA_LO <= (OTHERS => 'X'); 
		END CASE;
	END PROCESS;
	

END ARCH;