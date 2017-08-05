
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity rb_clkdiv is
	Port ( i_clk	: in std_logic;
		   swpat	: in std_logic_vector(7 downto 0);
		   r		: in std_logic;
		   o_clk	: out std_logic
		 );
end entity rb_clkdiv;

architecture rb_clkdiv_arch of rb_clkdiv is
	signal acc	: unsigned(7 downto 0);
	signal l_clk : std_logic;
begin

	o_clk <= l_clk;

	process (i_clk, r)
	begin
		if r = '0' then
			acc <= to_unsigned(0, 8);
			l_clk <= '0';
		elsif rising_edge(i_clk) then
			if acc = unsigned(swpat) then
				l_clk <= not l_clk;
				acc <= to_unsigned(0, 8);
			else
				acc <= acc + 1;
			end if;
		end if;
	end process;
	     
end rb_clkdiv_arch;
