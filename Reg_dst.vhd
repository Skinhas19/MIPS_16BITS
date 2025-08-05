library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg_dst is
  Port (
    mux_in0 : in  STD_LOGIC_VECTOR(2 downto 0);
    mux_in1 : in  STD_LOGIC_VECTOR(2 downto 0);
    mux_ctl : in  STD_LOGIC;
    mux_out : out STD_LOGIC_VECTOR(2 downto 0)
  );
end Reg_dst;

architecture Behavioral of Reg_dst is
begin
  mux_out <= mux_in0 when mux_ctl = '0' else mux_in1;
end Behavioral;
