library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_datapath is
end tb_datapath;

architecture sim of tb_datapath is

    -- Componente a ser testado
    component datapath
        Port ( 
            CLK1   : in  STD_LOGIC; 
            RESET1 : in  STD_LOGIC
        );
    end component;

    -- Sinais do testbench
    signal clk_tb   : STD_LOGIC := '0';
    signal reset_tb : STD_LOGIC := '1';  -- começa em reset

    -- Clock de 10 ns (100 MHz)
    constant clk_period : time := 10 ns;

begin

    -- Instanciação do datapath
    uut: datapath
        port map (
            CLK1   => clk_tb,
            RESET1 => reset_tb
        );

    -- Geração de clock
    clock_process : process
    begin
        while now < 1 ms loop  -- simula até 1 milissegundo
            clk_tb <= '0';
            wait for clk_period / 2;
            clk_tb <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

    -- Estímulos (reset e outros sinais se necessário)
    stimulus_process : process
    begin
        -- Mantém em reset por 20 ns
        wait for 20 ns;
        reset_tb <= '0';

        -- Aqui você pode adicionar outros estímulos mais tarde

        wait; -- termina a simulação
    end process;

end sim;
