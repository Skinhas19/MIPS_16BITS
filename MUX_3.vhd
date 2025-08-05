library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX_3 is
  Port (
    mux_in0 : in STD_LOGIC_VECTOR(15 downto 0);
    mux_in1 : in STD_LOGIC_VECTOR(15 downto 0);
    mux_in2 : in STD_LOGIC_VECTOR(15 downto 0);
    mux_ctl : in STD_LOGIC_VECTOR(1 downto 0);
    mux_out : out STD_LOGIC_VECTOR(15 downto 0)
    );
end MUX_3;

architecture Comportamental of MUX_3 is
begin
  process(mux_in0, mux_in1, mux_in2, mux_ctl)
  begin
    case mux_ctl is
      when "00" =>
        mux_out <= mux_in0;
      when "01" =>
        mux_out <= mux_in1;
      when "10" =>
        mux_out <= mux_in2;
      when others =>
        mux_out <= (others => 'X');  -- default
    end case;
  end process;
end Comportamental;
