
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;

entity rb_cpu is
	Port ( i_clk	: in std_logic;
		   r		: in std_logic;
		   raddr	: in std_logic_vector(4 downto 0);
		   d_out	: out std_logic_vector(31 downto 0)
		 );
end entity rb_cpu;

architecture rb_cpu_arch of rb_cpu is

	component rb_register
	port( i_clk : in std_logic;
		  r 	: in std_logic;
		  d 	: in std_logic_vector(31 downto 0);
		  q 	: out std_logic_vector(31 downto 0)
		 );
	end component;
	
	component rb_rom
	port( addr 	: in std_logic_vector(31 downto 0);   
		  data 	: out std_logic_vector(31 downto 0)
		 );
	end component;
	
	component rb_alu
	port( op_a		: in  std_logic_vector(31 downto 0);
		  op_b		: in  std_logic_vector(31 downto 0);
		  op_s 		: in  std_logic_vector(2 downto 0);
		  shamt		: in  unsigned(4 downto 0);
		  zero		: out std_logic;
		  res		: out std_logic_vector(31 downto 0)
	);
	end component;
	
	component rb_control
	port ( cmd		: in  std_logic_vector(5 downto 0);
		   funct	: in  std_logic_vector(5 downto 0);
		   alu_zero	: in  std_logic;
		   pc_sel	: out std_logic;
		   reg_dst	: out std_logic;
		   reg_we	: out std_logic;
		   alu_sel	: out std_logic;
		   alu_control: out std_logic_vector(2 downto 0)
		 );
	end component;
	
	component rb_register_file
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
	end component;

	signal pc_sel	: std_logic;

	signal pc 		: std_logic_vector(31 downto 0);
	signal pcBranch	: std_logic_vector(31 downto 0);
	signal pcNext 	: std_logic_vector(31 downto 0);
	signal pc_new 	: std_logic_vector(31 downto 0);
	
	signal instr 	: std_logic_vector(31 downto 0);
	
	signal signed_imm : std_logic_vector(31 downto 0);
	
	signal alu_sel	:	std_logic;
	signal alu_op	: 	std_logic_vector(31 downto 0);
	signal alu_control	: std_logic_vector(2 downto 0);
	signal alu_zero	: std_logic;
	
	signal a3	: std_logic_vector(4 downto 0);
	
	signal rd0	: std_logic_vector(31 downto 0);
	signal rd1	: std_logic_vector(31 downto 0);
	signal rd2	: std_logic_vector(31 downto 0);
	signal wd3	: std_logic_vector(31 downto 0);
	
	signal reg_dst  : std_logic;
	signal reg_we	: std_logic;
begin

	pcNext <= std_logic_vector(unsigned(pc) + 1);
	
	with pc_sel select pc_new <=
		pcNext when '0',
		pcBranch when '1',
		pcNext when others;

	program_counter: rb_register port map (
		i_clk => i_clk,
		r => r,
		d => pc_new,
		q => pc
	);

	instr_memory: rb_rom port map (
		addr => pc,
		data => instr
	);
	
	with instr(15) select signed_imm <=
		x"ffff" & instr(15 downto 0) when '1',
		x"0000" & instr(15 downto 0) when '0',
		x"0000" & instr(15 downto 0) when others;
		
	pcBranch <= std_logic_vector(unsigned(pcNext) + unsigned(signed_imm));
	
	with alu_sel select alu_op <=
		rd2 when '1',
		signed_imm when '0',
		x"00000000" when others;
	
	alu: rb_alu port map (
		op_a => rd1,
		op_b => alu_op,
		op_s => alu_control,
		shamt => unsigned(instr(10 downto 6)),
		zero => alu_zero,
		res => wd3
	);
	
	controller: rb_control port map (
		cmd => instr(31 downto 26),
		funct => instr(5 downto 0),
		alu_zero => alu_zero,
		pc_sel => pc_sel,
		reg_dst => reg_dst,
		reg_we => reg_we,
		alu_sel	=> alu_sel,
		alu_control => alu_control
	);
	
	a3 <= instr(15 downto 11) when reg_dst = '1' else instr(20 downto 16);
	
	registers: rb_register_file port map (
			clk => i_clk,
			a0 => raddr,
			a1 => instr(25 downto 21),
			a2 => instr(20 downto 16),
			a3 => a3,
			rd0	=> rd0,
			rd1 => rd1,
			rd2 => rd2,
			reg_w => wd3,
			we => reg_we
	);
	     
end rb_cpu_arch;
