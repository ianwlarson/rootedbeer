
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;
use IEEE.std_logic_textio.all;

entity rb_rom is
	Port ( addr	: in  std_logic_vector(31 downto 0);
		   data	: out std_logic_vector(31 downto 0)
		 );
end entity rb_rom;

architecture rb_rom_arch of rb_rom is

	subtype word_t is std_logic_vector(31 downto 0);
	type ram_t is array (0 to 63) of word_t;
	
	impure function ocram_ReadMemFile(FileName : STRING) return ram_t is
	  file FileHandle       : TEXT open READ_MODE is FileName;
	  variable CurrentLine  : LINE;
	  variable TempWord     : STD_LOGIC_VECTOR(31 downto 0);
	  variable Result       : ram_t    := (others => (others => '0'));

	begin
	  for i in 0 to 63 loop
		exit when endfile(FileHandle);

		readline(FileHandle, CurrentLine);
		hread(CurrentLine, TempWord);
		Result(i)    := TempWord;
	  end loop;

	  return Result;
	end function;

	signal rom : ram_t := ocram_ReadMemFile("program.hex");
begin

	data <= rom(to_integer(unsigned(addr)));
	     
end rb_rom_arch;


