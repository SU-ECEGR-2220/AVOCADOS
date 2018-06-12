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

	signal opcode: 	 std_logic_vector(6 downto 0);
	signal funct7: 	 std_logic_vector (6 downto 0);	
	signal funct3: 	 std_logic_vector(2 downto 0);
	signal Branch: 	 std_logic_vector(1 downto 0);
	signal MemReg: 	 std_logic;
	signal MemRead:	 std_logic;
	signal ALUCtrl:  std_logic_vector (4 downto 0);
	signal MemWrite: std_logic;
	signal ALUSrc: 	 std_logic;
	signal RegWrite: std_logic;
	signal ImmGen: 	 std_logic_vector (1 downto 0);
	
	signal PCN:	std_logic_vector(31 downto 0);
	signal PCO:	std_logic_vector(31 downto 0);
	
	signal DOut: 	std_logic_vector(31 downto 0);	

	signal ImmGenO: std_logic_vector(31 downto 0);

	signal ReadData1: std_logic_vector(31 downto 0);
	signal ReadData2: std_logic_vector(31 downto 0);

	signal ALU_result: std_logic_vector(31 downto 0);

	signal ReadData: std_logic_vector(31 downto 0);

	signal mux1: std_logic_vector(31 downto 0);
	signal mux2: std_logic_vector(31 downto 0);
	--signal mux3: std_logic_vector(31 downto 0); --commented out, this is extra

	signal add1_out: std_logic_vector(31 downto 0);
	signal carry_out: std_logic;

	signal add2_out: std_logic_vector(31 downto 0);
	signal carry2_out: std_logic;
	
	signal Branch_out: std_logic;

	signal Zero: std_logic;	
	
	signal selector_mux3: std_logic;
begin
	-- Add your code here
	
	-- PC
	count: ProgramCounter port map(reset, clock, PCN, PCO);

	-- add 4 after PC
	first_add: adder_subtracter port map(PCO, X"00000004", '0', add1_out, carry_out);


	-- Instruction Memory 	
	InstructionMem: InstructionRam port map(reset, clock, PCO(29 downto 0), Dout);
	
	opcode <= DOut(6 downto 0);
	funct3 <= DOut(14 downto 12);
	funct7 <= DOut(31 downto 25);
	
	-- control
	cntrl: control port map(clock, opcode, funct3, funct7, Branch, MemRead, MemReg, ALUCtrl, MemWrite, ALUSrc, RegWrite, ImmGen);

	-- registers
	register1: Registers port map(Dout(19 downto 15), Dout(24 downto 20), Dout(11 downto 7), mux2, RegWrite, ReadData1, ReadData2); --changed

	-- ImmGen
	with ImmGen select -- changed
		ImmGeno <= Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31 downto 20) when "00",
				Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31 downto 25)&Dout(11 downto 7) when "01",
				Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(7)&Dout(30 downto 25)&Dout(11 downto 8)&'0' when "10",
				Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31)&Dout(31 downto 12) when others; 	

	-- add sum
	add2: adder_subtracter port map(PCO, ImmGenO, '0', add2_out, carry2_out);

	-- Mux between registers and ALU

	muxone: BusMux2to1 port map(ALUSrc, ReadData2, ImmGenO, mux1);

	-- ALU 
	ALULOL: ALU port map(ReadData1, mux1, ALUCtrl, Zero, ALU_result);

	-- Data Memory
	DataRam: RAM port map(reset, clock, MemRead, MemWrite, ALU_result(31 downto 2), ReadData2, ReadData);

	-- Mux after Data Memory
	muxtwo: BusMux2to1 port map(MemReg, ReadData, ALU_result, mux2);

	with zero & Branch select
		selector_mux3 <= '1' when "101",
					'1' when "110",
					'0' when others;
	
	-- mux after branch
	mux_3: BusMux2to1 port map(selector_mux3, add1_out, add2_out, PCN);	--addded
	
	
end holistic;
