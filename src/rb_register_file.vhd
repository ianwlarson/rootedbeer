
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity rb_register_file is
	port ( 	clk		: in  std_logic;
			a0		: in  std_logic_vector(4 downto 0);
			a1		: in  std_logic_vector(4 downto 0);
			a2		: in  std_logic_vector(4 downto 0);
			a3		: in  std_logic_vector(4 downto 0);
			rd0		: out std_logic_vector(31 downto 0);
			rd1		: out std_logic_vector(31 downto 0);
			rd2		: out std_logic_vector(31 downto 0);
			reg_w   : in  std_logic_vector(31 downto 0);
			we		: in  std_logic
		 );
end entity rb_register_file;

architecture rb_register_file_arch of rb_register_file is
	type rfile is array (0 to 31) of std_logic_vector(31 downto 0);
	
	signal rf : rfile;
begin

	rf(0) <= x"00000000";

	rd0 <= rf(to_integer(unsigned(a0)));
	rd1 <= rf(to_integer(unsigned(a1)));
	rd2 <= rf(to_integer(unsigned(a2)));
	
	process (clk)
	begin
		if rising_edge(clk) and we = '1' then
			rf(to_integer(unsigned(a3))) <= reg_w;
		end if;
	end process;
	     
end rb_register_file_arch;

