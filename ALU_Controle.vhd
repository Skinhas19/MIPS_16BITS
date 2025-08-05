-- Biblioteca padrÃ£o IEEE para tipos lÃ³gicos
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entidade do bloco ALU_Control para 16 bits
-- Recebe sinais de controle e gera o sinal de operaÃ§Ã£o para a ALU
entity ALU_Controle is
  Port (
    alu_op   : in  STD_LOGIC_VECTOR(1 downto 0); -- Sinal vindo da unidade de controle principal
    funct    : in  STD_LOGIC_VECTOR(2 downto 0); -- Campo de funÃ§Ã£o da instruÃ§Ã£o (3 bits do funct em 16 bits)
    alu_ctrl : out STD_LOGIC_VECTOR(2 downto 0)  -- Sinal de controle final para a ALU
  );
end ALU_Controle;

-- Arquitetura comportamental do bloco
architecture Comportamental of ALU_Controle is
begin
  -- Processo sensÃ­vel a mudanÃ§as em alu_op ou funct
  process(alu_op, funct)
  begin
    -- DecodificaÃ§Ã£o do sinal alu_op
    case alu_op is
      when "00" => -- OperaÃ§Ãµes de Load/Store (LW/SW), sempre faz ADD
        alu_ctrl <= "000"; -- CÃ³digo para ADD

      when "01" => -- OperaÃ§Ã£o de BEQ (branch if equal), faz SUB
        alu_ctrl <= "001"; -- CÃ³digo para SUB

      when "10" => -- InstruÃ§Ãµes do tipo R, depende do campo funct
        case funct is
          when "000" => alu_ctrl <= "000"; -- ADD
          when "001" => alu_ctrl <= "001"; -- SUB
          when "010" => alu_ctrl <= "010"; -- AND
          when others => alu_ctrl <= "111"; -- OperaÃ§Ã£o invÃ¡lida ou NOP
        end case;

      when others =>
        alu_ctrl <= "111"; -- OperaÃ§Ã£o invÃ¡lida ou NOP
    end case;
  end process;
end Comportamental;
