library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity REG is
    Port (
        clk      : in  STD_LOGIC;
        enable : in STD_LOGIC;                         -- Clock
        data_in  : in  STD_LOGIC_VECTOR(15 downto 0);     -- Dado de entrada
        data_out : out STD_LOGIC_VECTOR(15 downto 0)      -- Dado de sa?da
    );
end REG;

architecture Behavioral of REG is
    signal reg : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');           -- Registrador interno
begin
    process(clk)
    begin
        if rising_edge(clk) then
        if enable='1' then
            reg <= data_in;
        end if;
        end if;
    end process;

    data_out <= reg;
end Behavioral;
