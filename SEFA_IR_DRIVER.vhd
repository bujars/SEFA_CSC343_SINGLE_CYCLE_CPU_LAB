LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 
USE work.SEFA_SINGLE_CYCLE_CPU_PACKAGE.ALL;

--- Right now I am having a bit of trouble putting it all together. Ie what the main driver is and what not. 
--- So I'm going to work in a similar manner to how I did it for the Branching lab

--- THe assumption for this file will be, that we have the IR signal
--- at this point, and that we will break it apart, and call the respective files

--- So we know that we will need a file which gets the IR and calls this (some other stuff too possibly)
--- The control signals depend on the IR,
--- So for now, lets just assume we get the control signals here? -- I believe we can do that.
--- Also note, that I am passing IR as one vector, not its seperate parts. I'm not sure if we even need 
--- it to be the seperate parts. 

ENTITY SEFA_IR_DRIVER IS 
GENERIC(SEFA_N : INTEGER := 32);
PORT(
	SEFA_CLOCK : IN STD_LOGIC; --- NEED TO ADD CLOCK AS INPUT. 
	--SEFA_IR_INPUT : IN STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
	-- SEFA_SOME_UNKNOWN_OUTPUT : OUT STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0) -- THIS WAS ONLY USED FOR TESTING PURPOSES.
	
	SEFA_OPCODE : IN STD_LOGIC_VECTOR(5 DOWNTO 0); -- ALL INSTRUCTION
	SEFA_RS : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- R INSTRUCTION
	SEFA_RT : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- R INSTRUCTION
	SEFA_RD : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- R INSTRUCTION
	SEFA_SHAMT : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- R INSTRUCTION
	SEFA_FUNCT :  IN STD_LOGIC_VECTOR(5 DOWNTO 0); -- R INSTRUCTION
	SEFA_IMM16 :  IN STD_LOGIC_VECTOR(15 DOWNTO 0); -- I INSTRUCTION
	SEFA_IMM26 : IN STD_LOGIC_VECTOR(25 DOWNTO 0); -- J INSTRUCTION
	SEFA_ALUctr : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	SEFA_ExtOp : IN STD_LOGIC;
	SEFA_ALUSrc : IN STD_LOGIC;
	SEFA_MemWr : IN STD_LOGIC;
	SEFA_MemtoReg : IN STD_LOGIC;
	SEFA_PCSrc : IN STD_LOGIC;
	SEFA_RegDst : IN STD_LOGIC;
	SEFA_RegWr : IN STD_LOGIC
	
	
	
	
);
END SEFA_IR_DRIVER;

ARCHITECTURE ARCH OF SEFA_IR_DRIVER IS

	SIGNAL SEFA_REGISTER_FILE_SELECTED_INPUT : STD_LOGIC_VECTOR(4 DOWNTO 0);
	
	
	
	SIGNAL SEFA_BUS_A : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL SEFA_BUS_B : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL SEFA_BUS_A_2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL SEFA_BUS_B_2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL SEFA_BUS_W : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	
	SIGNAL SEFA_EXTENDED_IMM : STD_LOGIC_VECTOR(31 DOWNTO 0);

	
	SIGNAL SEFA_INPUT_B : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	
	
	--- NOTE THIS WILL CHANGE ONCE WE INCORPERATE MULTIPLY AND DIVIDE!
	SIGNAL SEFA_ALU_OUTPUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	
	
	SIGNAL SEFA_DATA_MEM_OUTPUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	
	-- THIS IS BUS W BASICALLY. 
	--SIGNAL SEFA_MEM_TO_REG_OUTPUT : STD_LOGIC_VECTOR(31 DOWNTO 0);
	

BEGIN
	

	
	GET_RegDest_Register: SEFA_SELECT_REGISTER_FILE_INPUT PORT MAP (
											SEFA_RT => SEFA_RT,
											SEFA_RD => SEFA_RD, 
											SEFA_RegDst => SEFA_RegDst,
											SEFA_REGISTER_FILE_SELECTED_INPUT => SEFA_REGISTER_FILE_SELECTED_INPUT
	);
	
	
	
--	
--	---- SO WE MIGHT NEED TO CALL THIS TWICE. 
--	---- The first time is to get the output of BUSA and BUSB.
--	--- the second time is for example if we need to write ......
--	--- Ugh I still don't truly get this file. 
--	Three_Port_Ram_Result : SEFA_RAM3PORT PORT MAP (
--		SEFA_clock => SEFA_CLOCK,
--		SEFA_data => SEFA_BUS_W, -- TBD. what is the data supposed to be if we dont have any wtf? 
--		-- isnt the purpose of this file to get it? 
--		SEFA_rdaddress_a => SEFA_RS,
--		SEFA_rdaddress_b => SEFA_RT,
--		SEFA_wraddress => SEFA_REGISTER_FILE_SELECTED_INPUT,
--		--SEFA_wren => SEFA_RegWr, 
--		SEFA_wren => '0', -- So i think as noted, this should write anything yet...(lol)
--		SEFA_qa => SEFA_BUS_A,
--		SEFA_qb => SEFA_BUS_B
--
--	);
--	
--	
--	ENTITY SEFA_NON_LPM_REGISTER_FILE IS
--PORT(
--	SEFA_clock: IN STD_LOGIC;
--	SEFA_data: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
--	SEFA_wraddress: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
--	SEFA_rdaddress_a: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
--	SEFA_rdaddress_b: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
--	SEFA_wren: IN STD_LOGIC;
--	SEFA_qa: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
--	SEFA_qb: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
--);
--END SEFA_NON_LPM_REGISTER_FILE;

	
	
	
	
	
	
	-- so what this is going to do, is its going to get the value of RS 
	-- ie in load word we have op | rs | rt | imm
	
	
	-- FOR THE FUNCTIONS THAT REQUIRE IMMEDIATE STUFF, THIS IS WHERE WE GET IT. 
	GET_EXTENDED_IMM: SEFA_IMMEDIATE_EXTENDER PORT MAP (
		SEFA_IMM16 => SEFA_IMM16,
		SEFA_ExtOp => SEFA_ExtOp,
		SEFA_EXTENDED_IMM => SEFA_EXTENDED_IMM
	
	);
	
	
	
	GET_ALU_INPUT_B:  SEFA_SELECT_SECOND_ALU_INPUT PORT MAP (
		SEFA_BUSB => SEFA_BUS_B, 
		SEFA_EXTENDED_IMM => SEFA_EXTENDED_IMM,
		SEFA_ALUsrc => SEFA_ALUsrc, 
		SEFA_INPUT_B => SEFA_INPUT_B
	);

	
	COMPUTE_ALU :  SEFA_ALU PORT MAP (
		SEFA_ALUctr => SEFA_ALUctr,
		SEFA_INPUT_A => SEFA_BUS_A, 
		SEFA_INPUT_B => SEFA_INPUT_B,
		SEFA_ALU_OUTPUT => SEFA_ALU_OUTPUT

);
	
	COMPUTE_DATA_MEM_COMPONET:  SEFA_NON_LPM_DATA_MEMORY PORT MAP 
	(
		SEFA_address => SEFA_ALU_OUTPUT(3 downto 0), 
		SEFA_clock => SEFA_CLOCK,
		SEFA_data => SEFA_BUS_B,
		SEFA_wren => SEFA_MemWr, 
		SEFA_q => SEFA_DATA_MEM_OUTPUT
	);
	
	U2 : SEFA_SELECT_MEM_TO_REG PORT MAP 
	(
		SEFA_ALU_OUTPUT => SEFA_ALU_OUTPUT,
		SEFA_DATA_MEM_OUTPUT => SEFA_DATA_MEM_OUTPUT,
		SEFA_MemtoReg => SEFA_MemtoReg, 
		SEFA_MEM_TO_REG_OUTPUT => SEFA_BUS_W
	);

	Three_Port_Ram_FINAL_RESULT : SEFA_NON_LPM_REGISTER_FILE PORT MAP (
		SEFA_clock => SEFA_CLOCK,
		SEFA_data => SEFA_BUS_W, -- TBD. what is the data supposed to be if we dont have any wtf? 
		-- isnt the purpose of this file to get it? 
		SEFA_rdaddress_a => SEFA_RS,
		SEFA_rdaddress_b => SEFA_RT,
		SEFA_wraddress => SEFA_REGISTER_FILE_SELECTED_INPUT,
		--SEFA_wren => SEFA_RegWr, 
		SEFA_wren => SEFA_RegWr, -- SHOULD BE 1 FOR LW?
		SEFA_qa => SEFA_BUS_A,
		SEFA_qb => SEFA_BUS_B

	);
	
	-- SEFA_SOME_UNKNOWN_OUTPUT <= SEFA_BUS_W; -- .....I think..... LOL fuck idk now fuck this. 


END ARCH;