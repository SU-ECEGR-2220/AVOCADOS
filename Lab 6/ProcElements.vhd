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
begin
-- Add your code here
	with opcode & funct3 select
	Branch <= "10" when "1100011000", --beg
		"01" when "1100011001", --bne 
		"00" when others;

	with opcode & funct3 select
	MemRead <= '0' when "0000011010", --lw
		 '1' when others;

	with opcode & funct3 select
	MemtoReg <= '1' when "0000011010", --lw
		 '0' when others;


	ALUCtrl <= "00000" when opcode = "0110011" AND funct3 = "000" AND funct7 = "0000000000" else --add
		 "00100" when opcode = "0110011" AND funct3 ="000" AND  funct7 = "0100000" else --sub
		 "00000" when opcode ="0010011" AND funct3 ="000" else --addi
		 "00010" when opcode ="0110011" AND funct3= "111" AND funct7 = "0000000" else --and
		 "00010" when opcode= "0010011" AND  funct3 ="111" else	   --andi
		 "00011" when opcode = "0110011" AND funct3 ="110" AND  funct7 = "0100000" else  --or
		 "00011" when opcode = "0010011" AND funct3 ="110" else   --ori
		 "00001" when opcode = "0110011" AND funct3 ="001" AND  funct7 = "0000000" else --sll
		 "00001" when opcode = "0010011" AND funct3 ="001" AND  funct7 = "0000000" else --slli
		 "01001" when opcode = "0110011" AND funct3 ="100" AND  funct7 = "0000000" else --srl
		 "01001" when opcode = "0010011" AND funct3 ="101" AND  funct7 = "0100000" else --srli
		 "01110" when opcode = "0000011" AND funct3 ="010" else     --lw
		 "10101" when opcode = "0100011" AND funct3 ="010" else	   --sw
		 "10000" when opcode = "1100011" AND funct3 ="000" else	 --beq
		 "01000" when opcode = "1100011" AND funct3 ="001" else  --bne
		 "01111" when opcode = "0110111" else	   --lui
		 "11111";

	with opcode & funct3 select
	MemWrite <= '1' when "0100011010", 	   --sw
		 '0' when others;

 	ALUSrc <= '0' when opcode = "0110011" AND funct3 = "000" AND funct7 = "0000000"	     else --add
	          '0' when opcode = "0110011" AND funct3 = "000" AND funct7 = "0100000"	     else --sub
	          '0' when opcode = "0110011" AND funct3 = "111" AND funct7 = "0000000"	     else --and
	          '0' when opcode = "0110011" AND funct3 = "110" AND funct7 = "0000000"      else --or
		  '0' when opcode = "1100011" AND funct3 = "000"     			     else --beq
		  '0' when opcode = "1100011" AND funct3 = "001"     			     else --bne
	          '1' ;

	
	RegWrite <='0' when opcode="0100011" AND funct3="010" else	   --sw	
		   '0' when opcode="1100011" AND funct3="000" else	   --beq
		   '0' when opcode="1100011" AND funct3="001" else	    --bne
		(not clk);

	
	ImmGen <= "01" when opcode= "0010011" AND  funct3 ="000" else		  --addi
		  "01" when opcode= "0010011" AND  funct3 ="111" else		  --andi
 		  "01" when opcode = "0010011" AND funct3 ="110" else  --ori
   		  "01" when opcode = "0000011" AND funct3 ="010" else              --lw
		  "10" when opcode="0100011" AND funct3="010" else		 --sw
	          "00" when opcode="1100011" AND funct3="000" else	--beq
		  "00" when opcode="1100011" AND funct3="001" else	--bne
		  "11" when opcode = "0110111" else	 --lui
		  "01" when opcode ="0010011" AND funct3 ="001" AND funct7 ="0000000" else
		   "01" when opcode ="0010011" AND funct3 ="101" AND funct7 ="0100000" else
	          "ZZ";
--	WITH opcode & funct3 SELECT Branch <= "01" when "1100011000", --BEQ
--						"10" when "1100011001", --BNE
--						"--" when others;
--	
--	WITH opcode & funct3 SELECT MemRead <= '1' when "0000011010", --LW
--						'0' when others;
--	
--	WITH opcode & funct3 SELECT MemtoReg <= '1' when "0000011010", --LW
--						'0' when others;
--
--	WITH opcode & funct3 & funct7 SELECT ALUCtrl <= "00000" when "01100110000000000", -- ADD
--							"00100" when "01100110000100000", -- SUB
--							"00010" when "01100111110000000", --AND
--							"00011" when "01100111100000000", -- OR
--							"00001" when "00100110010000000", --SLLI
--							"01001" when "00100111010000000", --SRLI
--							"01010" when "0000011010-------", --LW
--							"00000" when "0010011000-------", --ADDI
--							"00011" when "0010011110-------", --ORI
--							"00010" when "0010011111-------", --ANDI
--							"10001" when "0100011010-------", --SW
--							"10000" when "1100011000-------", --BEQ
--							"00000" when "1100011001-------", --BNE
--							"01011" when "0110111----------", --LUI
--							"11111" when others;
--	
--	WITH opcode & funct3 SELECT MemWrite <= '1' when "0100011010", -- SW
--						'0' when others;
--
--	WITH opcode & funct3 & funct7 SELECT ALUSrc <= '0' when "01100110000000000", --ADD
--							'0' when "01100110001000000", --SUB
--							'0' when "01100111110000000", --AND
--							'0' when "01100111100000000", --OR
--							'0' when "1100011000-------", --BEQ
--							'0' when "1100011001-------", --BNE
--							'1' when others;
--
--	WITH opcode & funct3 SELECT RegWrite <= '0' when "0100011010", -- SW
--						'0' when "1100011000", -- BEQ
--						'0' when "1100011001", --BNE
--						'1' when others;
--
--	WITH opcode & funct3 SELECT ImmGen <= "00" when "0010011001", --SLLI
--						"00" when "0010011101", --SRLI
--						"00" when "0000011010", --LW
--						"00" when "0010011000", --ADDI
--						"00" when "0010011110", --ORI
--						"00" when "0010011111", --ANDI
--						"01" when "0100011010", --SW
--						"10" when "1100011000", --BEQ
--						"10" when "1100011001", --BNE
--						"11" when "0110111---", --LUI
--						"--" when others;
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
