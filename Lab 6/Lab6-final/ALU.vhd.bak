--------------------------------------------------------------------------------
--
-- LAB #4
--
--------------------------------------------------------------------------------

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
	signal addsub_result: std_logic_vector(31 downto 0);
	signal addsub_carryout: std_logic;
	signal shift_result: std_logic_vector(31 downto 0);
	signal and_result: std_logic_vector(31 downto 0);
	signal or_result: std_logic_vector(31 downto 0);
	signal final_result: std_logic_vector(31 downto 0);

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

begin
	-- Add ALU VHDL implementation here
	addsub: adder_subtracter port map(DataIn1, DataIn2, ALUCtrl(2), addsub_result, addsub_carryout);
	shift: shift_register port map(DataIn1, ALUCtrl(3), DataIn2(4 downto 0), shift_result);
	
	and_result <= DataIn1 and DataIn2;
	or_result <= DataIn1 or DataIn2;
	
	with ALUCtrl( 1 downto 0) select
		final_result <= addsub_result when "00",
				shift_result when "01",
				and_result when "10",
				or_result when others;

	with final_result select
		Zero <= '1' when  "00000000000000000000000000000000",
			'0' when others;

	ALUResult <= final_result;

end architecture ALU_Arch;


