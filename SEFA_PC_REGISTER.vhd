library IEEE;
use IEEE.std_logic_1164.all;
use work.SEFA_SINGLE_CYCLE_CPU_PACKAGE.all;


entity SEFA_PC_REGISTER IS
	generic (SEFA_N: integer := 32);
	port(
	SEFA_clk: in std_logic; -- clock
		SEFA_wren: in std_logic; -- write enable (if it is 0, the stored data will not change)
		SEFA_rden: in std_logic; -- read enable (only when it is 1, the stored data will be displayed to output)
		SEFA_chen: in std_logic; --  chip enable (if it is 0, the output will be undefined)
		SEFA_data: in std_logic_vector (SEFA_N-1 downto 0); -- data input
		SEFA_PC: out std_logic_vector(SEFA_N-1 downto 0)
		);
end SEFA_PC_REGISTER;


architecture arch of SEFA_PC_REGISTER is 

begin

	PC: SEFA_Register_N_VHDL port map (
					SEFA_clk => SEFA_clk, 
					SEFA_wren => SEFA_wren, 
					SEFA_rden => SEFA_rden, 
					SEFA_chen => SEFA_chen, 
					SEFA_data => SEFA_data, 
					SEFA_q => SEFA_PC
					);
	
end arch; 