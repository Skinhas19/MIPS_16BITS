library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Banco_Registradores is
  Port (
 clk              : in STD_LOGIC;
    rs : in STD_LOGIC_VECTOR (2 downto 0);
    rt : in STD_LOGIC_VECTOR (2 downto 0);
    rd  : in STD_LOGIC_VECTOR (2 downto 0);
    dado_escrita : in STD_LOGIC_VECTOR (15 downto 0);
    habilita_escrita : in STD_LOGIC;
    dado_saida1  : out STD_LOGIC_VECTOR (15 downto 0);
    dado_saida2  : out STD_LOGIC_VECTOR (15 downto 0)
  );
end Banco_Registradores;

architecture Comportamental of Banco_Registradores is

  type tipo_reg is array (0 to 7) of STD_LOGIC_VECTOR (15 downto 0);
signal registradores : tipo_reg := (others => (others => '0'));


begin

  -- Escrita no registrador (modo sÃ­ncrono)
  process(clk)
  begin
  if rising_edge(clk) then
    if habilita_escrita = '1' then
      registradores(to_integer(unsigned(rd))) <= dado_escrita;
    end if;
    end if;
  end process;

  -- Leitura assÃ­ncrona dos registradores
  dado_saida1 <= registradores(to_integer(unsigned(rs)));
  dado_saida2 <= registradores(to_integer(unsigned(rt)));

end Comportamental;
