
-- Kappa

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;


entity rb_register is
	Port ( i_clk	: in std_logic;
		   r		: in std_logic;
		   d		: in std_logic_vector(31 downto 0);
		   q		: out std_logic_vector(31 downto 0)
		 );
end entity rb_register;

architecture rb_register_arch of rb_register is

begin

	process (i_clk, r)
	begin
		if r = '0' then
			q <= x"00000000";
		elsif rising_edge(i_clk) then
			q <= d;
		end if;
	end process;
	     
end rb_register_arch;

library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity rb_register_we is
	Port ( i_clk	: in std_logic; -- Input clock
		   r		: in std_logic;	-- asynch reset
		   we		: in std_logic; -- write enable
		   d		: in std_logic_vector(31 downto 0); -- input
		   q		: out std_logic_vector(31 downto 0) -- output
		 );
end entity rb_register_we;

architecture rb_register_we_arch of rb_register_we is

begin

	process (i_clk, r)
	begin
		if r = '0' then
			q <= x"00000000";
		elsif rising_edge(i_clk) and we = '1' then
			q <= d;
		end if;
	end process;
	     
end rb_register_we_arch;
	     	
-- End of file
