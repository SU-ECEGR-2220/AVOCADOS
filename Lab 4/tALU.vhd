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
		control <= "00000";			--ADDI test
		wait for 20 ns;			--expect result = 0x01235678 and zeroOut = 0 at 139ns
		
		datain_a <= X"01234567";
		datain_b <= X"11223344";
		control <= "00100";			--SUB test
		wait for 20 ns; 		--expect result = 0xF0011223  and zeroOut = 0 at 159ns

		datain_a <= X"01234567";		-- AND test
		datain_b <= X"11223344";
		control  <= "00010";
		wait for 20 ns; 		--expect result = 0x01220144  and zeroOut = 0 at 199ns
		
		datain_a <= X"01234567";		-- ANDI test
		datain_b <= X"00001111";
		control  <= "00010";
		wait for 20 ns; 		--expect result = 0x01220144  and zeroOut = 0 at 219ns
	
		datain_a <= X"01234567";	-- DataIn in hex
		datain_b <= X"11223344";
		control  <= "00011"; 		--OR test
		wait for 20 ns; 		--expect result = 0x11237767  and zeroOut = 0 at 239ns

		datain_a <= X"01234567";	-- DataIn in hex
		datain_b <= X"00001111";
		control  <= "00011"; 		--ORI test
		wait for 20 ns; 		--expect result = 0x01235577  and zeroOut = 0 at 259ns

		
		

		wait; -- will wait forever
	END PROCESS;

END;