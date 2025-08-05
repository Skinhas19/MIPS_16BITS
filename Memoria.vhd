library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Memoria is
  Port (
    endereco     : in  STD_LOGIC_VECTOR(5 downto 0);         -- 8 bits: 256 posiÃ§Ãµes (16 bits cada)
    dado_escrita : in  STD_LOGIC_VECTOR(15 downto 0);        -- dado a ser escrito
    leitura_mem  : in  STD_LOGIC;                            -- habilita leitura
    escrita_mem  : in  STD_LOGIC;                            -- habilita escrita
    dado_lido    : out STD_LOGIC_VECTOR(15 downto 0);        -- saÃ­da do dado lido
    IORD         : in  STD_LOGIC;                            -- 0 = instruÃ§Ã£o (ROM), 1 = dados (RAM)
    clk          : in  STD_LOGIC
  );
end Memoria;

architecture Comportamental of Memoria is

  -- MemÃ³ria com 256 posiÃ§Ãµes de 16 bits
  type RAM_16 is array(0 to 64) of STD_LOGIC_VECTOR(15 downto 0);

  -- MemÃ³ria de instruÃ§Ãµes (ROM) e de dados (RAM)
  signal memoria_instrucao : RAM_16 := (
    0=>B"0001_001_111_000000",
    1=>B"0001_111_000_000001",
    2 =>B"0000_111_000_001_000",
    3=>B"0000_001_000_010_001",
    4=>B"0000_000_001_011_010", -- Exemplo de instruÃ§Ãµes
    5=>B"0010_111_000_000010",
    6=>B"0100_000000001011",
    11=>B"0011_111_001_000000",
    12=>B"0101_111_000_000001",
    13=>B"0110_000_111_000001",
    others => (others => '0')
  );
  signal memoria_dados : RAM_16 := (
  0=>x"0005",
  6=>x"0002",
  others => (others => '0')
);


begin

  -- Escrita (RAM de dados)
  process(clk)
  begin
    if rising_edge(clk) then
      if escrita_mem = '1' and IORD = '1' then
        memoria_dados(to_integer(unsigned(endereco))) <= dado_escrita;
      end if;
    end if;
  end process;

  -- Leitura (ROM ou RAM)
  process(leitura_mem, endereco, IORD, memoria_instrucao, memoria_dados)
  begin
    if leitura_mem = '1' then
      if IORD = '0' then
        -- Leitura da memÃ³ria de instruÃ§Ãµes
        dado_lido <= memoria_instrucao(to_integer(unsigned(endereco)));
      else
        -- Leitura da memÃ³ria de dados
        dado_lido <= memoria_dados(to_integer(unsigned(endereco)));
      end if;
    else
      dado_lido <= (others => '0');
    end if;
  end process;

end Comportamental;
