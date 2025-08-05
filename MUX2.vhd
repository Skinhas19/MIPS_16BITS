library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX2 is
  Port ( 
    mux_in0 : in STD_LOGIC_VECTOR(15 downto 0);
    mux_in1 : in STD_LOGIC_VECTOR(15 downto 0);
    mux_ctl : in STD_LOGIC;
    mux_out : out STD_LOGIC_VECTOR(15 downto 0)
  );
end MUX2;

architecture Behavioral of MUX2 is
begin
  mux_out <= mux_in0 when mux_ctl = '0' else
             mux_in1;
end Behavioral;
