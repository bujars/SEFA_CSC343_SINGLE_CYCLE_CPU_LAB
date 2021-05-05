LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.SEFA_SINGLE_CYCLE_CPU_PACKAGE.ALL;


-- THIS IS THE FILE THAT CHOOSES WHICH OPERATION THE ALU IS SUPPOSED TO OUTPUT. 
-- IT TAKES IN ALL THE RESULTS OF THE DIFFERNT ALU OPERATIONS AND SELECTS THE OUTPUT USING WHEN CLAUSE WITH CODE CONDITION CHECKING.


ENTITY SEFA_ALU_MUX IS 
GENERIC(SEFA_N : INTEGER := 32);
PORT(
--	SEFA_OPCODE : IN STD_LOGIC_VECTOR(5 DOWNTO 0); -- AS PER CONTROL SIGNALS FROM CPU CONTROLLER. 
--	SEFA_FUNCT: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
	SEFA_ALUctr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	SEFA_ADD : IN STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
	SEFA_SUB : IN STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
	SEFA_ADDU : IN STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
	SEFA_ADDI : IN STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
	SEFA_ADDIU : IN STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
	SEFA_SUBU : IN STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
	SEFA_AND : IN STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
	SEFA_OR : IN STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
	SEFA_NOR : IN STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
	SEFA_ANDI : IN STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
	SEFA_ORI : IN STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
	
	SEFA_ALU_RESULT : OUT STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0)
	-- NOTE IM NOT SURE HOW WE ARE GOING TO DO OUTPUT FOR MUL/DIV WHICH IS 64 BITS.......FOR NOW IGNORING.
	-- pOSSIBLY HAVE TWO OUTPUTS ONE
	-- MULT: FIRST HAS FIRST 32 BITS SECOND HAS SECOND 32 BITS
	-- DIV: FIRST HAS QUOT SECOND HAS REMAINDER
	-- FOR OTHER OPERATIONS WE ONLY FOCUS ON MAIN ONE. 
);
END SEFA_ALU_MUX;

ARCHITECTURE ARCH OF SEFA_ALU_MUX IS
BEGIN
	
	-- NOTE THE CONDITION CODES ARE CURRENTLY DUMMY CODES. WILL NEED TO UPDATE BASED ON THE ACTUAL TABLE. 
--	SEFA_ALU_RESULT <= SEFA_ADD WHEN (SEFA_OPCODE = "000000" AND SEFA_FUNCT = "100000") ELSE
--							SEFA_SUB WHEN (SEFA_OPCODE = "000000" AND SEFA_FUNCT = "100010") ELSE
--							SEFA_ADDU WHEN (SEFA_OPCODE = "000000" AND SEFA_FUNCT = "100001") ELSE
--							SEFA_ADDI WHEN SEFA_OPCODE = "001000" ELSE
--							SEFA_ADDIU WHEN SEFA_OPCODE = "001001" ELSE
--							SEFA_SUBU WHEN (SEFA_OPCODE = "000000" AND SEFA_FUNCT = "100011") ELSE
--							SEFA_AND WHEN (SEFA_OPCODE = "000000" AND SEFA_FUNCT = "100100") ELSE
--							SEFA_OR WHEN (SEFA_OPCODE = "000000" AND SEFA_FUNCT = "100101") ELSE
--							SEFA_NOR WHEN (SEFA_OPCODE = "000000" AND SEFA_FUNCT = "100111") ELSE
--							SEFA_ANDI WHEN SEFA_OPCODE = "001011" ELSE
--							SEFA_ORI;

		SEFA_ALU_RESULT <= SEFA_ADD WHEN (SEFA_ALUctr = "0000") ELSE
							SEFA_SUB WHEN (SEFA_ALUctr = "0001") ELSE
							SEFA_OR WHEN (SEFA_ALUctr = "0010") ELSE
							SEFA_ADDI WHEN (SEFA_ALUctr = "0011") ELSE
							SEFA_ADDIU WHEN (SEFA_ALUctr = "0100") ELSE
							SEFA_SUBU WHEN (SEFA_ALUctr = "0101") ELSE
							SEFA_AND WHEN (SEFA_ALUctr = "0110") ELSE
							SEFA_ORI WHEN (SEFA_ALUctr = "0111") ELSE
							SEFA_NOR WHEN (SEFA_ALUctr = "1000") ELSE
							SEFA_ANDI WHEN (SEFA_ALUctr = "1001") ELSE
							SEFA_ADDU;
							
							-- NEED TO FIGURE OUT ELSE CONDITION.... BECAUSE ITS NOT ALWAYS ADDU.
							-- Also, (besides add, sub, ori) need to determine if theres an actual AluOp value
							-- that needs to be followed.

END ARCH;
