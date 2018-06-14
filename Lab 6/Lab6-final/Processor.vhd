--------------------------------------------------------------------------------
--
-- LAB #6 - Processor 
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Processor is
    Port ( reset : in  std_logic;
	   clock : in  std_logic);
end Processor;

architecture holistic of Processor is
	component Control
   	     Port( clk : in  STD_LOGIC;
               opcode : in  STD_LOGIC_VECTOR (6 downto 0);
               funct3  : in  STD_LOGIC_VECTOR (2 downto 0);
               funct7  : in  STD_LOGIC_VECTOR (6 downto 0);
               Branch : out  STD_LOGIC_VECTOR(1 downto 0);
               MemRead : out  STD_LOGIC;
               MemtoReg : out  STD_LOGIC;
               ALUCtrl : out  STD_LOGIC_VECTOR(4 downto 0);
               MemWrite : out  STD_LOGIC;
               ALUSrc : out  STD_LOGIC;
               RegWrite : out  STD_LOGIC;
               ImmGen : out STD_LOGIC_VECTOR(1 downto 0));
	end component;

	component ALU
		Port(DataIn1: in std_logic_vector(31 downto 0);
		     DataIn2: in std_logic_vector(31 downto 0);
		     ALUCtrl: in std_logic_vector(4 downto 0);
		     Zero: out std_logic;
		     ALUResult: out std_logic_vector(31 downto 0) );
	end component;
	
	component Registers
	    Port(ReadReg1: in std_logic_vector(4 downto 0); 
                 ReadReg2: in std_logic_vector(4 downto 0); 
                 WriteReg: in std_logic_vector(4 downto 0);
		 WriteData: in std_logic_vector(31 downto 0);
		 WriteCmd: in std_logic;
		 ReadData1: out std_logic_vector(31 downto 0);
		 ReadData2: out std_logic_vector(31 downto 0));
	end component;

	component InstructionRAM
    	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;

	component RAM 
	    Port(Reset:	  in std_logic;
		 Clock:	  in std_logic;	 
		 OE:      in std_logic;
		 WE:      in std_logic;
		 Address: in std_logic_vector(29 downto 0);
		 DataIn:  in std_logic_vector(31 downto 0);
		 DataOut: out std_logic_vector(31 downto 0));
	end component;
	
	component BusMux2to1
		Port(selector: in std_logic;
		     In0, In1: in std_logic_vector(31 downto 0);
		     Result: out std_logic_vector(31 downto 0) );
	end component;
	
	component ProgramCounter
	    Port(Reset: in std_logic;
		 Clock: in std_logic;
		 PCin: in std_logic_vector(31 downto 0);
		 PCout: out std_logic_vector(31 downto 0));
	end component;

	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;


-- Program Counter Output
	-- Control Output
	signal Branch  : std_logic_vector(1 downto 0);
	signal MemRead : std_logic;
	signal MemtoReg: std_logic;
	signal ALUCtrl : std_logic_vector(4 downto 0);
	signal MemWrite: std_logic;
	signal ALUSrc  : std_logic;
	signal RegWrite: std_logic;
	signal ImmGen  : std_logic_vector(1 downto 0);

	-- Muxes output
	signal mux1   : std_logic_vector(31 downto 0);
	signal mux2  : std_logic_vector(31 downto 0);
	signal mux3: std_logic_vector(31 downto 0);

	signal PCO       : std_logic_vector(31 downto 0);

	-- Adders signals
	signal Add_1	   : std_logic_vector(31 downto 0);
	signal Add_2	   : std_logic_vector(31 downto 0);
	signal c01, c02	   : std_logic;
	
	-- Intruction Memory Output
	signal DOut : std_logic_vector(31 downto 0);

	-- Registers Output
	signal ReadData1      : std_logic_vector(31 downto 0);
	signal ReadData2      : std_logic_vector(31 downto 0);

	-- Data Memory Outputs
	signal ReadData	   : std_logic_vector(31 downto 0);

	-- ALU output
	signal ALU_out: std_logic_vector(31 downto 0);
	signal Zero     : std_logic;
	signal BranchEqNot : std_logic;
	
	--ImmGen output
	signal ImmGenO   : std_logic_vector(31 downto 0);    -- ImmGen to AddMux, ALUMux 
	
	signal finesse : std_logic_vector(29 downto 0);
begin

	mux_1: BusMux2to1   port map(ALUSrc, ReadData2, ImmGenO, mux1);
	
	first_add: adder_subtracter port map(PCO, "00000000000000000000000000000100", '0', Add_1, c01);

	add2: adder_subtracter port map(PCO, ImmGenO, '0', Add_2, c02); 

	counter: ProgramCounter   port map(reset, clock, mux3, PCO);

	mux_2: BusMux2to1  port map(MemtoReg, ALU_out, ReadData, mux2);

	IMEM: instructionRAM port map(reset, clock, PCO(31 downto 2), DOut);

	Cntrl: Control 	     port map(clock, DOut(6 downto 0), DOut(14 downto 12), DOut(31 downto 25), Branch, MemRead, MemtoReg, ALUCtrl,MemWrite,ALUSrc, RegWrite, ImmGen);

	Register1: Registers      port map(DOut(19 downto 15), DOut(24 downto 20), DOut(11 downto 7), mux2, RegWrite, ReadData1, ReadData2);

	Arit: ALU         port map(ReadData1, mux1, ALUCtrl, Zero, ALU_out);

	mux_3: BusMux2to1   port map(BranchEqNot, Add_1, Add_2, mux3);
	
	finesse <= "0000"& ALU_out(27 downto 2);

	DMem: RAM	     port map(reset, clock, MemRead, MemWrite, finesse, ReadData2, ReadData);

	with Zero & Branch select
		BranchEqNot <= '0' when "-00",
					'0' when "001", -- BEQ
					'1' when "101", -- BEQ
					'1' when "010", -- BNE
					'0' when others; --anything else PC+4
	
	with ImmGen & DOut(31) select
	ImmGenO <=   "111111111111111111111" & DOut(30 downto 20) when "011",  --I_type
                       "000000000000000000000" & DOut(30 downto 20) when "010",  --I_type
		       "111111111111111111111" & DOut(30 downto 25) & DOut(11 downto 7) when "101",  --S_type
                       "000000000000000000000" & DOut(30 downto 25) & DOut(11 downto 7) when "100",  --S_type
		        "11111111111111111111" & DOut(7) & DOut(30 downto 25) & DOut(11 downto 8) & '0' when "001", --B_type
                        "00000000000000000000" & DOut(7) & DOut(30 downto 25) & DOut(11 downto 8) & '0' when "000", --B_type
			     -- "111111111111" & DOut(31 downto 12) when "111", --U_type
                             -- "000000000000" & DOut(31 downto 12) when "110", --U_type
			                   "1" & DOut(30 downto 12) & "000000000000" when "111", --U_type
                                           "0" & DOut(30 downto 12) & "000000000000" when "110", --U_type
            "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" when others;
		-- "00000000000000000000000000000000" when others;
 
end holistic;

