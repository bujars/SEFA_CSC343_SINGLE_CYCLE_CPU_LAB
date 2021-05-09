LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
LIBRARY altera_mf; 
USE altera_mf.all;


-- SO I THINK IM JUST OVERCOMPLICATING WHAT THE WHOLE PROJECT IS SUPPOSED TO DO.
-- BUT THIS FILE SHOULD BE NO DIFFERENT THANT DATA MEMORY AND INSTRUCTION MEMORY
-- THINK OF IT LIKE MIPS
-- WE HAVE A DATA WINDOW (THAT ONLY HAS THE VALUES WE LOAD OR STORE --> RECALL WE NEED TO LOAD/STORE OUR VALUES)
-- WE HAVE A INSTRUCTION "MEMORY" --> BASICALLY OUT DISASSEMBLY WINDOW IS CONSIDERED THAT. EVERYTHING STARTS AT "0"
-- AND WE GO THROUGH EACH INSTRUCTION (THE IMPORTANCE OF PC)
-- FINALLY WE HAVE THE REGISTERS FILE. 
-- THIS IS MORE INTERMEDIATE TBH AND ITS MOSTLY JUST FOR STORING REGISTER VALUES.
-- SO LIKE LAST ASSIGNMENT, WE WOULD JUST GET THE VALUES FROM RAM, AND PUT INTO REGISTER SIGNALS.
-- ITS LEGIT BASICALLY THAT....
-- SO FOR EXAMPLE WHEN WE LOAD A, WE GET IT FROM DATA MEMORY, AND THROW IT INTO ONE OF THE ADDRESSES FROM INSTRUCTION
-- THIS IS ALL DEFINED BY US! 


ENTITY SEFA_RAM3PORT IS
PORT
(
	SEFA_clock : IN STD_LOGIC;
	SEFA_data : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
	SEFA_rdaddress_a : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
	SEFA_rdaddress_b : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
	SEFA_wraddress : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
	SEFA_wren : IN STD_LOGIC := '1';
	SEFA_qa : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
	SEFA_qb : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
);

END SEFA_RAM3PORT;

ARCHITECTURE SYN OF SEFA_RAM3PORT IS

SIGNAL sub_wire0 : STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL sub_wire1 : STD_LOGIC_VECTOR (31 DOWNTO 0);
COMPONENT alt3pram
GENERIC(
indata_aclr : STRING;
indata_reg : STRING;
lpm_file : STRING;
intended_device_family : STRING;
lpm_type : STRING; 
outdata_aclr_a : STRING;
outdata_aclr_b : STRING; 
outdata_reg_a : STRING;
outdata_reg_b : STRING;
rdaddress_aclr_a : STRING;
rdaddress_aclr_b : STRING;
rdaddress_reg_a : STRING;
rdaddress_reg_b : STRING;
rdcontrol_aclr_a : STRING;
rdcontrol_aclr_b : STRING; 
rdcontrol_reg_a : STRING;
rdcontrol_reg_b : STRING;
width : 	NATURAL;
widthad : NATURAL;
write_aclr : STRING;
write_reg : STRING
); 

PORT (
qa : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
outclock : IN STD_LOGIC;
qb : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
wren : IN STD_LOGIC;
inclock : IN STD_LOGIC ;
data : IN STD_LOGIC_VECTOR(31 DOWNTO 0); 
rdaddress_a : IN STD_LOGIC_VECTOR( 4 DOWNTO 0); 
wraddress : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
rdaddress_b : IN STD_LOGIC_VECTOR (4 DOWNTO 0)
);
END COMPONENT;

BEGIN
SEFA_qa <= sub_wire0(31 downto 0);
SEFA_qb <= sub_wire1(31 downto 0);
alt3pram_component: alt3pram GENERIC MAP (
indata_aclr => "OFF",
indata_reg => "INCLOCK",
lpm_file => "SEFA_REGISTER_MEMORY_1.mif", -- REALLY PRAYING THIS WILL WORK...
intended_device_family => "Stratix II",
lpm_type => "alt3pram",
outdata_aclr_a => "OFF",
outdata_aclr_b => "OFF", 
outdata_reg_a => "UNREGISTERED",
outdata_reg_b => "UNREGISTERED",
rdaddress_aclr_a => "OFF",
rdaddress_aclr_b => "OFF",
rdaddress_reg_a => "INCLOCK",
rdaddress_reg_b => "INCLOCK",
rdcontrol_aclr_a => "OFF",
rdcontrol_aclr_b => "OFF",
rdcontrol_reg_a => "UNREGISTERED",
rdcontrol_reg_b => "UNREGISTERED",
width => 	32,
widthad => 5,
write_aclr => "OFF",
write_reg => "INCLOCK"
)
PORT MAP (
outclock => SEFA_clock,
wren => SEFA_wren,
inclock => SEFA_clock,
data => SEFA_data,
rdaddress_a => SEFA_rdaddress_a,
wraddress => SEFA_wraddress,
rdaddress_b => SEFA_rdaddress_b,
qa => sub_wire0,
qb => sub_wire1
);
END SYN;
