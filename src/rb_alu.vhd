
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity rb_alu is
	Port ( op_a		: in  std_logic_vector(31 downto 0);
		   op_b		: in  std_logic_vector(31 downto 0);
		   op_s 	: in  std_logic_vector(2 downto 0);
		   shamt	: in  unsigned(4 downto 0);
		   zero		: out std_logic;
		   res		: out std_logic_vector(31 downto 0)
		 );
end entity rb_alu;

architecture rb_alu_arch of rb_alu is
	constant c_ADD	: std_logic_vector(2 downto 0) := "000";
	constant c_OR 	: std_logic_vector(2 downto 0) := "001";
	constant c_LUI	: std_logic_vector(2 downto 0) := "010";
	constant c_SRL	: std_logic_vector(2 downto 0) := "011";
	constant c_SLTU	: std_logic_vector(2 downto 0) := "100";
	constant c_SUBU	: std_logic_vector(2 downto 0) := "101";
	
	signal sltu_var : std_logic;
	
	signal l_res	: std_logic_vector(31 downto 0);
begin

	res <= l_res;

	sltu_var <= '1' when unsigned(op_a) < unsigned(op_b) else '0';

	with op_s select l_res <=
		std_logic_vector(unsigned(op_a) + unsigned(op_b)) when c_ADD,
		op_a or op_b when c_OR,
		op_b(15 downto 0) & x"0000" when c_LUI,
		std_logic_vector(shift_right(unsigned(op_b), to_integer(shamt))) when c_SRL,
		"0000000000000000000000000000000" & sltu_var when c_SLTU,
		std_logic_vector(unsigned(op_a) - unsigned(op_b)) when c_SUBU,
		x"00000000" when others;
	     
	zero <= '1' when l_res = x"00000000" else '0';
	     
end rb_alu_arch;

