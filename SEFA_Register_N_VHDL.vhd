library IEEE;
use IEEE.std_logic_1164.all;
use work.SEFA_SINGLE_CYCLE_CPU_PACKAGE.all;


-- NOTE, this is from Self Check Lab 4b (I just copied the code over)

entity SEFA_Register_N_VHDL is 
	generic (SEFA_N: integer := 32); -- The genetics feature permits us to change the side of this register desin easily. Its a const variable
	port (
		SEFA_clk: in std_logic; -- clock
		SEFA_wren: in std_logic; -- write enable (if it is 0, the stored data will not change)
		SEFA_rden: in std_logic; -- read enable (only when it is 1, the stored data will be displayed to output)
		SEFA_chen: in std_logic; --  chip enable (if it is 0, the output will be undefined)
		SEFA_data: in std_logic_vector (SEFA_N-1 downto 0); -- data input
		SEFA_q: out std_logic_vector(SEFA_N-1 downto 0) -- output. This is essentially just a display
		);
end SEFA_Register_N_VHDL;

architecture arch of SEFA_Register_N_VHDL is
	signal SEFA_storage : std_logic_vector(SEFA_N-1 downto 0);
	-- THis is the actual storage space of the register.
	-- the bulk of this work will be coordinating how the data input flows into the storage space 
	-- and then to the ouput. 
	
begin
	process (SEFA_clk)
	-- WE are defining a process that is sensative to changes in clock value. 
	-- When defining a process, the paranthesiss that come after it allow us to define our sensativity list. 
	begin
		-- defining 32 bit wide flip flop that is rising edge triggered. 
		if (rising_edge(SEFA_clk) and SEFA_wren = '1') -- when clock is ticked and writing is permissible, we send to storage (ie store the value -- current value)
			then SEFA_storage <= SEFA_data;
		end if;
	end process; 
	
	process ( SEFA_rden, SEFA_chen, SEFA_storage )
	-- this process is resposnive to changes in read enable, chip enable, and the storage space.
	-- Z is a common undefined logic value used for circuits. Using the others feature allows us to set every bit in q as undefined. 
	begin
		if (SEFA_rden = '1' and SEFA_chen = '1') -- if we want to read data to output and this new chip field is set, then read otherwise it has a default value
			then SEFA_q <= SEFA_storage;
		elsif(SEFA_chen = '0')
			then SEFA_q <= (others => 'Z');
		end if;
	end process;
end arch;

-- So to summarize. To make a N Register (that is something that stores a value)
-- It happens in two processes
-- the first process focuses soley on storing the current value (or rather our Flip Flop -- recall a flip flop stores value on edge change)
-- so thats exactly like dff assignment, where when edge (rising) is set, take that value. 
-- of course, we also have write enable which is basically like our enable bit from previous assignments. (so maybe its a combo of the two im not a hundred precent sure) 
-- then the second process is concerned with displaying the current value. And that only happens when rden and chen are set. Otherwise its not reading from register
-- and so we have an output of unidentified. 
-- Might be benefical to write all of this down on paper just so that we can remember it more. 