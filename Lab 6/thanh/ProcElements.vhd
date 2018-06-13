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
-- Add your code here
	WITH selector SELECT Result <= In0 when '0',
					In1 when OTHERS;
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
		result <= "000000000001ZZ" when funct7 = "0000000" and funct3 = "000" and opcode = "0110011" else --ADD
			 "000000100001ZZ" when funct7 = "0100000" and funct3 = "000" and opcode = "0110011" else --SUB
			 "000000010001ZZ" when funct7 = "0000000" and funct3 = "111" and opcode = "0110011" else --AND
			 "000000011001ZZ" when funct7 = "0000000" and funct3 = "110" and opcode = "0110011" else --OR
			 "000000001011ZZ" when funct7 = "0000000" and funct3 = "001" and opcode = "0110011" else --SLL			 
			 "000001001011ZZ" when funct7 = "0000000" and funct3 = "101" and opcode = "0110011" else --SLR
			 "00000000101101" when funct7 = "0000000" and funct3 = "001" and opcode = "0010011" else --SLLI
			 "00000100101101" when funct7 = "0000000" and funct3 = "101" and opcode = "0010011" else --SRLI
			 "00000000001101" when funct3 = "000" and opcode = "0010011" else --ADDI
			 "00000001101101" when funct3 = "110" and opcode = "0010011" else --ORI
			 "00000001001101" when funct3 = "111" and opcode = "0010011" else --ANDI
			 "00110111001101" when funct3 = "010" and opcode = "0000011" else --LW			 
			 "00001010111010" when funct3 = "010" and opcode = "0100011" else --SW
			 "01001000000000" when funct3 = "000" and opcode = "1100011" else --BEQ
			 "10000100000000" when funct3 = "001" and opcode = "1100011" else --BNE
			 "00000111101111" when opcode = "0110111" else --LUI
			 "11111111111111";	


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

	signal new_address: std_logic_vector(31 downto 0);
begin
-- Add your code here
ProgramCounter: Process(Reset, Clock)
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
