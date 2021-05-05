LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY SEFA_CPU_CONTROL_SIGNALS IS
PORT(
	SEFA_OPCODE : IN STD_LOGIC_VECTOR(5 DOWNTO 0); -- NOTE I MIGHT BE ABLE TO SIMPLIFY THIS TO JUST OPCODE OR FUNCT AS WE DON'T HAVE MIXED VALUES AS OF NOW...
	SEFA_FUNCT: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
	SEFA_ALUctr : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	SEFA_ExtOp : OUT STD_LOGIC;
	SEFA_ALUSrc : OUT STD_LOGIC;
	SEFA_MemWr : OUT STD_LOGIC;
	SEFA_MemtoReg : OUT STD_LOGIC;
	SEFA_PCSrc : OUT STD_LOGIC;
	SEFA_RegDst : OUT STD_LOGIC;
	SEFA_RegWr : OUT STD_LOGIC

);

END SEFA_CPU_CONTROL_SIGNALS;

ARCHITECTURE ARCH OF SEFA_CPU_CONTROL_SIGNALS IS

BEGIN


PROCESS(SEFA_OPCODE, SEFA_FUNCT)
BEGIN
	CASE SEFA_OPCODE IS
		WHEN "000000" => -- R type instructions
			CASE SEFA_FUNCT IS
				WHEN "100000" =>
					-- ADD 
					SEFA_ALUctr <= "0000";
					SEFA_ExtOp <= '-'; -- According to this, this is how we represent dontcare...https://groups.google.com/forum/#!topic/comp.lang.vhdl/dp1Mgkn7mPU
					SEFA_ALUSrc <= '0';
					SEFA_MemWr <= '0';
					SEFA_MemtoReg <= '0';
					SEFA_PCSrc <= '0';
					SEFA_RegDst <= '1';
					SEFA_RegWr <= '1';
				WHEN "100010" => 
					-- SUB
					SEFA_ALUctr <= "0001";
					SEFA_ExtOp <= '-';
					SEFA_ALUSrc <= '0';
					SEFA_MemWr <= '0';
					SEFA_MemtoReg <= '0';
					SEFA_PCSrc <= '0';
					SEFA_RegDst <= '1';
					SEFA_RegWr <= '1';
				WHEN "100101" =>
					-- OR
					SEFA_ALUctr <= "0010";
					SEFA_ExtOp <= '0';
					SEFA_ALUSrc <= '0';
					SEFA_MemWr <= '0';
					SEFA_MemtoReg <= '0';
					SEFA_PCSrc <= '0';
					SEFA_RegDst <= '1';
					SEFA_RegWr <= '1';
				WHEN "100011" => 
					-- SUBU
					SEFA_ALUctr <= "0011";
					SEFA_ExtOp <= '-';
					SEFA_ALUSrc <= '0';
					SEFA_MemWr <= '0';
					SEFA_MemtoReg <= '0';
					SEFA_PCSrc <= '0';
					SEFA_RegDst <= '1';
					SEFA_RegWr <= '1';
				WHEN "100100" => 
					-- AND  -- JUST COPIED OR SO IDK IF CORRECT. 
					SEFA_ALUctr <= "0010";
					SEFA_ExtOp <= '0';
					SEFA_ALUSrc <= '0';
					SEFA_MemWr <= '0';
					SEFA_MemtoReg <= '0';
					SEFA_PCSrc <= '0';
					SEFA_RegDst <= '1';
					SEFA_RegWr <= '1';
				WHEN "100111" => 
					-- NOR  -- JUST COPIED OR SO IDK IF CORRECT. 
					SEFA_ALUctr <= "0010";
					SEFA_ExtOp <= '0';
					SEFA_ALUSrc <= '0';
					SEFA_MemWr <= '0';
					SEFA_MemtoReg <= '0';
					SEFA_PCSrc <= '0';
					SEFA_RegDst <= '1';
					SEFA_RegWr <= '1';
				WHEN "100011" => 
					-- ADDU
					SEFA_ALUctr <= "1001"; -- -- -- SETTING THIS ONE AS 9 SO WHEN WE ADD MORE, KEEP AT 9. 
					SEFA_ExtOp <= '-';
					SEFA_ALUSrc <= '0';
					SEFA_MemWr <= '0';
					SEFA_MemtoReg <= '0';
					SEFA_PCSrc <= '0';
					SEFA_RegDst <= '1';
					SEFA_RegWr <= '1';
			END CASE; 
		WHEN "001000" =>
			-- ADDI
			SEFA_ALUctr <= "0100";
			SEFA_ExtOp <= '1';
			SEFA_ALUSrc <= '1';
			SEFA_MemWr <= '0';
			SEFA_MemtoReg <= '0';
			SEFA_PCSrc <= '0';
			SEFA_RegDst <= '0';
			SEFA_RegWr <= '1';
		WHEN "001001" =>
			-- ADDIU
			SEFA_ALUctr <= "0101";
			SEFA_ExtOp <= '0'; -- NOTE I MADE THIS CHANGE. IM NOT SURE IF ITS CORRECT THOUGH. 
			SEFA_ALUSrc <= '1';
			SEFA_MemWr <= '0';
			SEFA_MemtoReg <= '0';
			SEFA_PCSrc <= '0';
			SEFA_RegDst <= '0';
			SEFA_RegWr <= '1';
		WHEN "001100" => 
			-- ORI
			SEFA_ALUctr <= "0111";
			SEFA_ExtOp <= '0';
			SEFA_ALUSrc <= '1';
			SEFA_MemWr <= '0';
			SEFA_MemtoReg <= '0';
			SEFA_PCSrc <= '0';
			SEFA_RegDst <= '0';
			SEFA_RegWr <= '1';
		WHEN "001100" => 
			-- ANDI
			SEFA_ALUctr <= "1000";
			SEFA_ExtOp <= '0';
			SEFA_ALUSrc <= '1';
			SEFA_MemWr <= '0';
			SEFA_MemtoReg <= '0';
			SEFA_PCSrc <= '0';
			SEFA_RegDst <= '0';
			SEFA_RegWr <= '1';
	END CASE; 

END PROCESS;

END ARCH; 