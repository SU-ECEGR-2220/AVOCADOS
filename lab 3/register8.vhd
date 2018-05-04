
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register8 is
	port(datain: in std_logic_vector(7 downto 0);
	     enout:  in std_logic;
	     writein: in std_logic;
	     dataout: out std_logic_vector(7 downto 0));
end entity register8;

architecture memmy of register8 is
	component bitstorage
		port(bitin: in std_logic;
		 	 enout: in std_logic;
		 	 writein: in std_logic;
		 	 bitout: out std_logic);
	end component;
begin
	-- insert your code here.
	b0: bitstorage port map (datain(0), enout, writein, dataout(0));
	b1: bitstorage port map (datain(1), enout, writein, dataout(1));
	b2: bitstorage port map (datain(2), enout, writein, dataout(2));
	b3: bitstorage port map (datain(3), enout, writein, dataout(3));
	b4: bitstorage port map (datain(4), enout, writein, dataout(4));
	b5: bitstorage port map (datain(5), enout, writein, dataout(5));
	b6: bitstorage port map (datain(6), enout, writein, dataout(6));
	b7: bitstorage port map (datain(7), enout, writein, dataout(7));

end architecture memmy;
