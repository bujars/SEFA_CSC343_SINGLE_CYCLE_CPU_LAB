library IEEE;
use IEEE.std_logic_1164.all;
use work.SEFA_SINGLE_CYCLE_CPU_PACKAGE.all;



-- The purpose of this component is to be the adder that handles the condition when 
-- we continue to the direct next address (ie +4). 

ENTITY SEFA_PC_PLUS_IMMEDIATE_PLUS_4 IS
	PORT(
		SEFA_PC_PLUS_4 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		SEFA_SIGN_EXTENDED_IMM : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		SEFA_PC_NEW : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END SEFA_PC_PLUS_IMMEDIATE_PLUS_4;

ARCHITECTURE arch OF SEFA_PC_PLUS_IMMEDIATE_PLUS_4 IS

SIGNAL OVERFLOW : STD_LOGIC; -- Just a 
-- signal that we might to fill all variables with .

BEGIN

	PC_PLUS_IMMEDIATE_PLUS_4: SEFA_SIGNED_LPM_ADD_SUB PORT MAP (
				SEFA_add_sub => '1',
				SEFA_dataa => SEFA_PC_PLUS_4,
				SEFA_datab => SEFA_SIGN_EXTENDED_IMM,
				SEFA_overflow => OVERFLOW,
				SEFA_result => SEFA_PC_NEW
				);

END arch; 