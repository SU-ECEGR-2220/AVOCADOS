 --------------------------------------------------------------------------------
--
-- LAB #6 - Processor Elements
--
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BusMux2to1 is
	Port(	selector: in std_logic;
			In0, In1: in std_logic_vector(31 downto 0);
			Result: out std_logic_vector(31 downto 0) );
end entity BusMux2to1;

architecture selection of BusMux2to1 is
begin
	with selector select
		Result <= In0 when '0',
			In1 when others;
end architecture selection;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Control is
      Port(clk : in  STD_LOGIC;
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
end Control;

architecture Boss of Control is

signal result: std_logic_vector(13 downto 0);

begin
-- Add your code here
	with funct7 & funct3 & opcode select
		result <= "001000000001--" when "00000000000110011", --ADD
			 "001000100001--" when "01000000000110011", --SUB
			 "001000010001--" when "00000001110110011", --AND
			 "001000011001--" when "00000001100110011", --OR
			 "001000001011--" when "00000000010110011", --SLL
			 "001001001011--" when "00000001010110011", --SLR
			 "00000000001101" when "-------0000010011", --ADDI
			 "00000001101101" when "00000001100010011", --ORI
			 "00000001001101" when "00000001110010011", --ANDI
			 "00110111001101" when "00000000100000011", --LW
			 "00001010111010" when "-------0100100011", --SW
			 "01001000000000" when "-------0001100011", --BEQ
			 "10000100000000" when "-------0011100011", --BNE
			 "00000111101111" when others; --LUI	

	Branch <= result(13 downto 12);
	MemRead <= result(11);
	MemtoReg <= result(10);
	ALUCtrl <= result(9 downto 5);
	MemWrite <= result(4);
	ALUSrc <= result(3);
	RegWrite <= result(2);
	ImmGen <= result(1 downto 0);


end architecture Boss;

--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ProgramCounter is
    Port(Reset: in std_logic;
	 Clock: in std_logic;
	 PCin: in std_logic_vector(31 downto 0);
	 PCout: out std_logic_vector(31 downto 0));
end entity ProgramCounter;

architecture executive of ProgramCounter is

signal new_address: std_logic_vector (31 downto 0);

begin
-- Add your code here
process(Clock, Reset)
	begin
	if (Reset = '1') then
		new_address <= "00000000010000000000000000000000";
	end if;
	if (falling_edge(Clock)) then
		new_address <= PCin;
	end if;
	if (rising_edge(Clock)) then
		PCOut <= new_address;
	end if;
end process;
end executive;
--------------------------------------------------------------------------------
