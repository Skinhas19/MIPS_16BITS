library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; -- Importa operações aritméticas

entity add1 is
    Port (
        a : in  STD_LOGIC_VECTOR (15 downto 0);
        b : out STD_LOGIC_VECTOR (15 downto 0)
    );
end add1;

architecture Behavioral of add1 is
begin
    process(a)
    begin
        b <= std_logic_vector(unsigned(a) + 1); -- Soma 1 ao valor de a
    end process;
end Behavioral;
