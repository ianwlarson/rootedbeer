
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity rb_control is
	Port ( cmd		: in  std_logic_vector(5 downto 0);
		   funct	: in  std_logic_vector(5 downto 0);
		   alu_zero	: in  std_logic;
		   pc_sel	: out std_logic;
		   reg_dst	: out std_logic;
		   reg_we	: out std_logic;
		   alu_sel	: out std_logic;
		   alu_control: out std_logic_vector(2 downto 0)
		 );
end entity rb_control;

architecture rb_control_arch of rb_control is
	constant c_SPEC	: std_logic_vector(5 downto 0) := "000000";
	constant c_ADDIU: std_logic_vector(5 downto 0) := "001001";
	constant c_BEQ	: std_logic_vector(5 downto 0) := "000100";
	constant c_LUI	: std_logic_vector(5 downto 0) := "001111";
	constant c_BNE	: std_logic_vector(5 downto 0) := "000101";
	
	constant f_ADDU : std_logic_vector(5 downto 0) := "100001";
	constant f_OR	: std_logic_vector(5 downto 0) := "100101";
	constant f_SRL	: std_logic_vector(5 downto 0) := "000010";
	constant f_SLTU	: std_logic_vector(5 downto 0) := "101011";
	constant f_SUBU	: std_logic_vector(5 downto 0) := "100011";
	constant f_ANY 	: std_logic_vector(5 downto 0) := "------";
	
	signal branch	: std_logic;
	signal condZero : std_logic;
	
	signal l_res	: std_logic_vector(31 downto 0);
	
	signal config	: std_logic_vector(7 downto 0);
	
	signal conf_sel 	: std_logic_vector(11 downto 0);
begin

	conf_sel <= cmd & funct;
	
	pc_sel <= branch and (alu_zero and condZero);
	
	branch <= config(7);
	condZero <= config(6);
	reg_dst <= config(5);
	reg_we <= config(4);
	alu_sel <= config(3);
	alu_control <= config(2 downto 0);

	with conf_sel select config <=
		"00110000" when c_SPEC & f_ADDU,
		"00110001" when c_SPEC & f_OR,
		"00011000" when c_ADDIU & f_ANY,
		"11000000" when c_BEQ & f_ANY,
		"00011010" when c_LUI & f_ANY,
		"00110011" when c_SPEC & f_SRL,
		"00110100" when c_SPEC & f_SLTU,
		"10000000" when c_BNE & f_ANY,
		"00110101" when c_SPEC & f_SUBU,
		"00000000" when others;
	     
	     
end rb_control_arch;

