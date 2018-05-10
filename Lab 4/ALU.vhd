--------------------------------------------------------------------------------
--
-- LAB #4
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity ALU is
	Port(	DataIn1: in std_logic_vector(31 downto 0);
		DataIn2: in std_logic_vector(31 downto 0);
		ALUCtrl: in std_logic_vector(4 downto 0);
		Zero: out std_logic;
		ALUResult: out std_logic_vector(31 downto 0) );
end entity ALU;

architecture ALU_Arch of ALU is
	-- ALU components	
	component adder_subtracter
		port(	datain_a: in std_logic_vector(31 downto 0);
			datain_b: in std_logic_vector(31 downto 0);
			add_sub: in std_logic;
			dataout: out std_logic_vector(31 downto 0);
			co: out std_logic);
	end component adder_subtracter;

	component shift_register
		port(	datain: in std_logic_vector(31 downto 0);
		   	dir: in std_logic;
			shamt:	in std_logic_vector(4 downto 0);
			dataout: out std_logic_vector(31 downto 0));
	end component shift_register;

	signal add_sub1: std_logic(31 downto 0);
	signal add_sub_co: std_logic;
	signal shift_out: std_logic(31 downto 0);
	signal AND_OUT: STD_LOGIC;
	SIGNAL OR_OUT: STD_LOGIC;

begin
	-- Add ALU VHDL implementation here

	ADD_SUB: adder_subtractor PORT MAP (DataIn1, DataIn2, ALUCtrl(2), add_sub1, add_sub_co);
	shifter: shift_register port map(DataIn1, ALUCtrl(3), DataIn2(), shift_out);

	
	AND_OUT <= DataIn1 and DataIn2;
	OR_OUT <= DataIn1 or DataIn2;

	with ALUCtrl(1 down to 0) select
		ALUResult <= add_sub1 when "00",
			     shift_out when "01",
			     AND_OUT when "10",
			     OR_OUT when others;
	with ALUResult select
		Zero <= '1' when "000000000000000000000000000000000"
			'0' when others;
	

end architecture ALU_Arch;


