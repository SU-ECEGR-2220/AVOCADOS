--------------------------------------------------------------------------------
--
-- LAB #5 - Memory and Register Bank
--
--------------------------------------------------------------------------------

Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity bitstorage is
	port(bitin: in std_logic;
		 enout: in std_logic;
		 writein: in std_logic;
		 bitout: out std_logic);
end entity bitstorage;

architecture memlike of bitstorage is
	signal q: std_logic := '0';
begin
	process(writein) is
	begin
		if (rising_edge(writein)) then
			q <= bitin;
		end if;
	end process;
	
	-- Note that data is output only when enout = 0	
	bitout <= q when enout = '0' else 'Z';
end architecture memlike;

--------------------------------------------------------------------------------
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

--------------------------------------------------------------------------------
Library ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity register32 is
	port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
end entity register32;

architecture biggermem of register32 is
	component register8
		port(datain: in std_logic_vector(7 downto 0);
		     enout:  in std_logic;
		     writein: in std_logic;
		     dataout: out std_logic_vector(7 downto 0));
	end component;

	signal enout_1: std_logic;
	signal enout_2: std_logic;
	signal writein_1: std_logic;
	signal writein_2: std_logic;
begin
	-- insert code here.
	
	enout_1 <= enout32 and enout16 and enout8;
	writein_1 <= writein32 or writein16 or writein8;

	enout_2 <= enout32 and enout16;
	writein_2 <= writein32 or writein16;


	register0: register8 port map (datain(7 downto 0), enout_1, writein_1, dataout(7 downto 0));
	register1: register8 port map (datain(15 downto 8), enout_2, writein_2, dataout(15 downto 8));
	register2: register8 port map (datain(23 downto 16), enout32, writein32, dataout(23 downto 16));
	register3: register8 port map (datain(31 downto 24), enout32, writein32, dataout(31 downto 24));

end architecture biggermem;
--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity RAM is
    Port(Reset:	  in std_logic;
	 Clock:	  in std_logic;	 
	 OE:      in std_logic;
	 WE:      in std_logic;
	 Address: in std_logic_vector(29 downto 0);
	 DataIn:  in std_logic_vector(31 downto 0);
	 DataOut: out std_logic_vector(31 downto 0));
end entity RAM;

architecture staticRAM of RAM is

   type ram_type is array (0 to 127) of std_logic_vector(31 downto 0);
   signal i_ram : ram_type;

begin

  RamProc: process(Clock, Reset, OE, WE, Address) is

  begin
    if Reset = '1' then
      for i in 0 to 127 loop   
          i_ram(i) <= X"00000000";
      end loop;
    end if;

    if falling_edge(Clock) then
	-- Add code to write data to RAM
	-- Use to_integer(unsigned(Address)) to index the i_ram array
	if (WE = '1') then
		if (to_integer(unsigned(Address)) < 128) then
			i_ram(to_integer(unsigned(Address))) <= DataIn;
		end if;
	end if;	
    end if;

	-- Rest of the RAM implementation
	if rising_edge(Clock) then
	if (OE = '0') then
		if (to_integer(unsigned(Address)) < 128) then
			DataOut <= i_ram(to_integer(unsigned(Address)));
		else
			DataOut <= "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"; 
		end if;
	end if;
	end if;
  end process RamProc;

end staticRAM;	


--------------------------------------------------------------------------------
LIBRARY ieee;
Use ieee.std_logic_1164.all;
Use ieee.numeric_std.all;
Use ieee.std_logic_unsigned.all;

entity Registers is
    Port(ReadReg1: in std_logic_vector(4 downto 0); 
         ReadReg2: in std_logic_vector(4 downto 0); 
         WriteReg: in std_logic_vector(4 downto 0);
	 WriteData: in std_logic_vector(31 downto 0);
	 WriteCmd: in std_logic;
	 ReadData1: out std_logic_vector(31 downto 0);
	 ReadData2: out std_logic_vector(31 downto 0));
end entity Registers;

architecture remember of Registers is
	component register32
  	    port(datain: in std_logic_vector(31 downto 0);
		 enout32,enout16,enout8: in std_logic;
		 writein32, writein16, writein8: in std_logic;
		 dataout: out std_logic_vector(31 downto 0));
	end component;

	signal A0, A1, A2, A3, A4, A5, A6, A7, X0: std_logic_vector (31 downto 0);
	signal WRITETHIS: std_logic_vector (7 downto 0);
begin
    -- Add your code here for the Register Bank implementation
WITH WriteCmd & WriteReg SELECT WRITETHIS <= "00000001" when "101010",
						"00000010" when "101011",
						"00000100" when "101100",
						"00001000" when "101101",
						"00010000" when "101110",
						"00100000" when "101111",
						"01000000" when "110000",
						"10000000" when "110001",
						"00000000" when OTHERS; 

	X0 <= (others => '0');

 	ALMOST: register32 PORT MAP(WriteData, '0', '1', '1', WRITETHIS(0), '0', '0', A0); 
	DONE: register32 PORT MAP(WriteData, '0', '1', '1', WRITETHIS(1), '0', '0', A1); 
	WTIH1: register32 PORT MAP(WriteData, '0', '1', '1', WRITETHIS(2), '0', '0', A2); 
	THIS: register32 PORT MAP(WriteData, '0', '1', '1', WRITETHIS(3), '0', '0', A3); 
	LAB: register32 PORT MAP(WriteData, '0', '1', '1', WRITETHIS(4), '0', '0', A4); 
	IM: register32 PORT MAP(WriteData, '0', '1', '1', WRITETHIS(5), '0', '0', A5); 
	SO: register32 PORT MAP(WriteData, '0', '1', '1', WRITETHIS(6), '0', '0', A6); 
	HAPPY: register32 PORT MAP(WriteData, '0', '1', '1', WRITETHIS(7), '0', '0', A7); 

	WITH ReadReg1 SELECT ReadData1 <= A0 when "01010",
					A1 when "01011",
					A2 when "01100",
					A3 when "01101",
					A4 when "01110",
					A5 when "01111",
					A6 when "10000",
					A7 when "10001",
					X0 when others;

	WITH ReadReg1 SELECT ReadData2 <= A0 when "01010",
					A1 when "01011",
					A2 when "01100",
					A3 when "01101",
					A4 when "01110",
					A5 when "01111",
					A6 when "10000",
					A7 when "10001",
					X0 when others;

					
end remember;

----------------------------------------------------------------------------------------------------------------------------------------------------------------
