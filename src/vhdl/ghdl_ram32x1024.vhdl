use WORK.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use Std.TextIO.all;
use work.debugtools.all;

ENTITY ram32x1024 IS
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ram32x1024;

architecture behavioural of ram32x1024 is

  type ram_t is array (0 to 1023) of std_logic_vector(31 downto 0);
  signal ram : ram_t := (
    others => x"FFFFFFFF");

  signal douta_drive : std_logic_vector(31 downto 0);
  signal doutb_drive : std_logic_vector(31 downto 0);
  
begin  -- behavioural

  process(clka)
  begin
    douta_drive <= ram(to_integer(unsigned(addra(9 downto 0))));
    douta <= douta_drive;

    if(rising_edge(Clka)) then 
      if ena='1' then
        if(wea="1111") then
          ram(to_integer(unsigned(addra(9 downto 0)))) <= dina;
        end if;
      end if;
    end if;
  end process;

  process (clkb,addrb,ram)
  begin
    doutb_drive <= ram(to_integer(unsigned(addrb(9 downto 0))));
    doutb <= doutb_drive;
    if(rising_edge(Clkb)) then 
      if(web="1111") then
        ram(to_integer(unsigned(addrb))) <= dinb;
      end if;
    end if;
  end process;

end behavioural;
