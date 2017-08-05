
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity rb_top is
	port(
		clk_top		: in  std_logic;
		reset_top	: in  std_logic;
		clk_control	: in  std_logic_vector(7 downto 0);
		clk_enable	: in  std_logic;
		clk_out		: out std_logic;
		reg_addr	: in  std_logic_vector(4 downto 0);
		reg_data	: out std_logic_vector(31 downto 0)
	);
end entity rb_top;

architecture rb_top_arch of rb_top is

	component rb_clkdiv
	port(
		i_clk	: in std_logic;
		swpat	: in std_logic_vector(7 downto 0);
		r		: in std_logic;
		o_clk	: out std_logic
	);
	end component;
	
	component rb_cpu
	port (
		i_clk	: in std_logic;
		r		: in std_logic;
		raddr	: in std_logic_vector(4 downto 0);
		d_out	: out std_logic_vector(31 downto 0)
	);
	end component;
	
	
	signal local_clk : std_logic;
	
begin

	clk_out <= local_clk;

	clock_divider: rb_clkdiv port map (
		i_clk => clk_top,
		swpat => clk_control,
		r => reset_top,
		o_clk => local_clk
	);
	
	the_cpu: rb_cpu port map (
		i_clk => local_clk,
		r => reset_top,
		raddr => reg_addr,
		d_out => reg_data
	);
	
	     
end rb_top_arch;
