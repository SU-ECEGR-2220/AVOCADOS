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
with funct7 & funct3 & opcode select
		result <= "00000000000100" when "00000000000110011", --ADD
			 "00000010000100" when "01000000000110011", --SUB
			 "00000001000100" when "00000001110110011", --AND
			 "00000001100100" when "00000001100110011", --OR
			 "00000000101100" when "00000000010110011", --SLL			 
			 "00000100101100" when "00000001010110011", --SLR
			 "00000000001101" when "00000000000010011", --ADDI
			 "00000001101101" when "00000001100010011", --ORI
			 "00000001001101" when "00000001110010011", --ANDI
			 "00110111001101" when "00000000100000011", --LW			 
			 "00001010111010" when "00000000100100011", --SW
			 "01001000000000" when "00000000001100011", --BEQ
			 "10000100000000" when "00000000011100011", --BNE
			 "00000111101111" when "00000000000110111", --LUI
			 "11111111111111" when others;

	Branch <= result(13 downto 12);
	MemRead <= result(11);
	MemtoReg <= result(10);
	ALUCtrl <= result(9 downto 5);
	MemWrite <= result(4);
	ALUSrc <= result(3);
	RegWrite <= not(clk) and result(2);
	ImmGen <= result(1 downto 0);

end Boss;

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
begin
-- Add your code here
	ProgramCounter: Process(Reset, Clock)
	begin
		if reset = '1' then
			PCout <= X"00400000";
		elsif (rising_edge(clock)) then
			PCout <= PCin;
		end if;
	end process;

end executive;
--------------------------------------------------------------------------------
