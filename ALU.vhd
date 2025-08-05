library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
  Port ( 
    a1          : in  STD_LOGIC_VECTOR (15 downto 0);
    a2          : in  STD_LOGIC_VECTOR (15 downto 0);
    alu_control : in  STD_LOGIC_VECTOR (2 downto 0); -- 3 bits de controle
    alu_result  : out STD_LOGIC_VECTOR (15 downto 0);
    zero        : out STD_LOGIC
  );
end ALU;

architecture Behavioral of ALU is
  signal resultX : STD_LOGIC_VECTOR (15 downto 0);
begin

  process(a1, a2, alu_control)
  begin
    case alu_control is

      when "000" => -- ADD (sem sinal)
        resultX <= std_logic_vector(unsigned(a1) + unsigned(a2));

      when "001" => -- SUB (com sinal)
        resultX <= std_logic_vector(signed(a1) - signed(a2));

      when "010" => -- AND lÃ³gico
        resultX <= a1 and a2;

      when others => -- NOP / DEFAULT
        resultX <= (others => '0');

    end case;
  end process;

  alu_result <= resultX;
  zero <= '1' when resultX = std_logic_vector(to_unsigned(0, 16)) else '0';

end Behavioral;
