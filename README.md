# SEFA_CSC343_SINGLE_CYCLE_CPU_LAB

Files we need
- SEFA_ALU
- SEFA_ALU_MUX
- SEFA_AND
- SEFA_BRANCHING_MUX
- SEFA_BRANCHING_SIGNED_EXTEDNED
- SEFA_CPU_CONTROL_SIGNALS
- SEFA_Comparator_N
- SEFA_HI_REGISTER
- SEFA_LO_REGISTER
- SEFA_IMMEDIATE_EXTENDED_MUX
- SEFA_IMMEDIATE_EXTENDER
- SEFA_IR_REGISTER
- SEFA_LO_REGISTER
- SEFA_LPM_DIVIDE
- SEFA_LPM_MULT
- SEFA_MAIN
- SEFA_NAL
- SEFA_NON_LPM_DATA_MEMORY
- SEFA_NON_LPM_INSTRUCTION_MEMORY
- SEFA_NON_LPM_REGISTER_FILE
- SEFA_NOR
- SEFA_OR
- SEFA_PC_PLUS_4
- SEFA_PC_PLUS_IMMEDIATE_PLUS_4
- SEFA_PC_REGISTER
- SEFA_Register_N_VHDL
- SEFA_SELECT_MEM_TO_REG
- SEFA_SELECT_REGISTER_FILE_INPUT
- SEFA_SELECT_SECOND_ALU_INPUT
- SEFA_SIGNED_LPM_ADD_SUB
- SEFA_SIGN_EXTEND_IMM_16_TO_32
- SEFA_SIGN_EXTEND_IMM_26_TO_32
- SEFA_SINGLE_CYCLE_CPU_PACKAGE
- SEFA_STORE_PC_VALUE
- SEFA_UNSIGNED_LPM_ADD_SUB
- SEFA_ZERO_EXTEND_IMM_16_TO_32


# Things that must be changed
- the values inside of SEFA_NON_LPM_DATA_MEMORY
(this is to form unique dot products as values are pulled from here). 
Instruction memory can stay the same as it just pulls values in pairs and stores them then computes.
This however, can be changed if you want to switch up the registers. See notes.

# Things to note 
The ALUCtr in CPU_CONTROL_SIGNALs can also be uniquly changed! I just added the associated binary number as I implemented a new instruction. 
Note if the ALUCtr value is changed, all files that require it must also be updated (ie ALU, ALU_MUX, etc...search repo for the variable name) 


The MUX files could also be removed. Logic can be added to its parent files (ie ALU for ALU_MUX) and must be converted to process(begin). This is just a stylistic choice. I seperated mine.

Right now, all multiplication values need to remain under 32 bits. This is becasue I only implemented SEFA_LO to go into BUS W. In the future mflo needs to be implemented (hacky probably incorrect way is just to expand size of busW or amek a ram5port).

LPM modules for data, instruction, and register ram was not working due to timing issues. I thus converted to the hardcoded way using vector arrays. 
All data related to the files (such as data memory) are directly there. No MIF files are required for hard coded rams.



