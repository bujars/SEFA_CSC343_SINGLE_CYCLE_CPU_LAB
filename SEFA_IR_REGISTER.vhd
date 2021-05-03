library IEEE;
use IEEE.std_logic_1164.all;
use work.SEFA_SINGLE_CYCLE_CPU_PACKAGE.all;


-- The purpose for this component is because we will require an instruction register 
-- that will host the opcode | rs | rt | immediate fields

------- Aside Note to revisit --------

-- Note I am not sure how we will handle the fields of the data. 
-- By the data I am referring to opcode | rs | rt | immediate

-- Option one: we need a driver for t, which divides the data. 

-- Option two: we handle the combination of the data here as well (add them as seperate input signals).
-- Like are those all different imports? I wouldnt think so I would assume its just 32 bits, 


-------------------

entity SEFA_IR_REGISTER IS
	generic (SEFA_N: integer := 32);
	port(
	SEFA_clk: in std_logic; -- clock
		SEFA_wren: in std_logic; -- write enable (if it is 0, the stored data will not change)
		SEFA_rden: in std_logic; -- read enable (only when it is 1, the stored data will be displayed to output)
		SEFA_chen: in std_logic; --  chip enable (if it is 0, the output will be undefined)
		SEFA_data: in std_logic_vector (SEFA_N-1 downto 0); -- data input
		SEFA_IR: out std_logic_vector(SEFA_N-1 downto 0)
		);
end SEFA_IR_REGISTER;


architecture arch of SEFA_IR_REGISTER is 

begin

	-- Establish an IR register using the Self check lab 4b register component. 
	IR: SEFA_Register_N_VHDL port map (
					SEFA_clk => SEFA_clk, 
					SEFA_wren => SEFA_wren, 
					SEFA_rden => SEFA_rden, 
					SEFA_chen => SEFA_chen, 
					SEFA_data => SEFA_data, 
					SEFA_q => SEFA_IR
					);
	
end arch; 