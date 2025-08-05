library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SignExtend is
    Port ( 
        a : in  STD_LOGIC_VECTOR (5 downto 0);
        b : out STD_LOGIC_VECTOR (15 downto 0)
    );
end SignExtend;

architecture Behavioral of SignExtend is
begin
    process(a)
    begin
        -- Propaga o bit de sinal (a(5)) nos 10 bits mais significativos
       
            b <= (15 downto 6 => '0') & a;
       
    
    end process;
end Behavioral;
