
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity rb_rom is
	Port ( addr	: in  std_logic_vector(31 downto 0);
		   data	: out std_logic_vector(31 downto 0)
		 );
end entity rb_rom;

architecture rb_rom_arch of rb_rom is

	type membank is array (0 to 63) of std_logic_vector(31 downto 0);

	signal rom : membank;
begin

	data <= rom(to_integer(unsigned(addr)));
	     
end rb_rom_arch;

