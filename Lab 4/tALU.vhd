--------------------------------------------------------------------------------
--
-- Test Bench for LAB #4
--
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testALU_vhd IS
END testALU_vhd;

ARCHITECTURE behavior OF testALU_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT ALU
		Port(	DataIn1: in std_logic_vector(31 downto 0);
			DataIn2: in std_logic_vector(31 downto 0);
			ALUCtrl: in std_logic_vector(4 downto 0);
			Zero: out std_logic;
			ALUResult: out std_logic_vector(31 downto 0) );
	end COMPONENT ALU;

	--Inputs
	SIGNAL datain_a : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL datain_b : std_logic_vector(31 downto 0) := (others=>'0');
	SIGNAL control	: std_logic_vector(4 downto 0)	:= (others=>'0');

	--Outputs
	SIGNAL result   :  std_logic_vector(31 downto 0);
	SIGNAL zeroOut  :  std_logic;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: ALU PORT MAP(
		DataIn1 => datain_a,
		DataIn2 => datain_b,
		ALUCtrl => control,
		Zero => zeroOut,
		ALUResult => result
	);
	

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- Start testing the ALU
		datain_a <= X"01234567";	-- DataIn in hex
		datain_b <= X"11223344";
		control  <= "00000";		-- Control in binary (ADD and ADDI test)
		wait for 20 ns; 			-- result = 0x124578AB  and zeroOut = 0

		-- Add test cases here to drive the ALU implementation
		datain_a <= X"01234567";
		datain_b <= X"00001111";
		control <= "00000";		-- Control in binary (ADDI test)
		wait for 20 ns;			-- expect result = 0x01235678 and zeroOut = 0 at 139ns
		
		datain_a <= X"01234567";
		datain_b <= X"11223344";
		control <= "00100";		-- Control in binary (SUB test)
		wait for 20 ns; 		-- expect result = 0xF0011223  and zeroOut = 0 at 159ns

		datain_a <= X"01234567";	
		datain_b <= X"11223344";
		control  <= "00010";		-- Control in binary (AND test)
		wait for 20 ns; 		-- expect result = 0x01220144  and zeroOut = 0 at 179ns
		
		datain_a <= X"01234567";	
		datain_b <= X"00001111";
		control  <= "00010";		-- Control in binary (ANDI test)
		wait for 20 ns; 		-- expect result = 0x01220144  and zeroOut = 0 at 179ns
	
		datain_a <= X"01234567";	-- DataIn in hex
		datain_b <= X"11223344";
		control  <= "00011"; 		-- Control in binary (OR test)
		wait for 20 ns; 		-- expect result = 0x11237767  and zeroOut = 0 at 219ns

		datain_a <= X"01234567";	-- DataIn in hex
		datain_b <= X"00001111";
		control  <= "00011"; 		-- Control in binary (ORI test)
		wait for 20 ns; 		-- expect result = 0x01235577  and zeroOut = 0 at 239ns

		datain_a <= X"01234567";	-- DataIn in hex
		datain_b <= X"00000040";	-- in binary: 0000 0000 0000 0000 0000 0"000 01"00 0000
		control  <= "00001";		-- SLL TEST (SHIFT LEFT by 1)
		wait for 20 ns; 		-- expect result = 0x02468ACE  and zeroOut = 0 at 259ns
		
		datain_a <= X"01234567";	-- DataIn in hex
		datain_b <= X"00000080";	-- in binary: 0000 0000 0000 0000 0000 0"000 10"00 0000
		control  <= "01001";		-- SRL test (SHIFT RIGHT by 2)
		wait for 20 ns; 		-- expect result = 0x0048D159  and zeroOut = 0 at 279ns
		

		wait; -- will wait forever
	END PROCESS;

END;