LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.SEFA_SINGLE_CYCLE_CPU_PACKAGE.ALL;


-- THIS IS THE FILE THAT COMPUTES OR BETWEEN INPUT A AND INPUT B


ENTITY SEFA_NOR_COMPONENT IS 
GENERIC(SEFA_N : INTEGER := 32);
PORT(
	SEFA_INPUT_A : IN STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
	SEFA_INPUT_B : IN STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
	SEFA_NOR_RESULT : OUT STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0)
);
END SEFA_NOR_COMPONENT;

ARCHITECTURE ARCH OF SEFA_NOR_COMPONENT IS
BEGIN
	
	SEFA_NOR_RESULT <= SEFA_INPUT_A NOR SEFA_INPUT_B;

END ARCH;