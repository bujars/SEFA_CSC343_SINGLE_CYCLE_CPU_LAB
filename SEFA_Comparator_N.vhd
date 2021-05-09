library IEEE;
use IEEE.std_logic_1164.all;
use work.SEFA_SINGLE_CYCLE_CPU_PACKAGE.all;

-- The purpose of this component is to perform bitwise comparason of bits. That is, if each bit is equal, 
-- return true (1), else return false (0).
-- Note we use the = for both inputs to perform this. 


entity SEFA_Comparator_N IS
	GENERIC(SEFA_N : INTEGER := 32);
	PORT(
			SEFA_IN0, SEFA_IN1 : IN STD_LOGIC_VECTOR(SEFA_N-1 DOWNTO 0);
			SEFA_OUT : OUT STD_LOGIC
	);
end SEFA_Comparator_N;
	
ARCHITECTURE arch OF SEFA_Comparator_N IS 

BEGIN

	PROCESS(SEFA_IN0, SEFA_IN1)
	begin 
		IF (SEFA_IN0 = SEFA_IN1) THEN -- If all bits are the same, return true
			SEFA_OUT <= '1';
		ELSE
			SEFA_OUT <= '0'; -- return false if all bits are not the same
		END IF;
	END PROCESS;
	
END arch; 