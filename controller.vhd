library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controller is
    Port (
        clk           : in  STD_LOGIC;
        reset         : in  STD_LOGIC;
        opcode        : in  STD_LOGIC_VECTOR(3 downto 0);
        data          : out STD_LOGIC_VECTOR(1 downto 0);
        ir_write      : out STD_LOGIC;
        pc_write      : out STD_LOGIC;
        mem_read      : out STD_LOGIC;
        mem_write     : out STD_LOGIC;
        reg_write     : out STD_LOGIC;
        alu_op        : out STD_LOGIC_VECTOR(1 downto 0);
        alu_src_a     : out STD_LOGIC;
        alu_src_b     : out STD_LOGIC_VECTOR(1 downto 0);
        pc_src        : out STD_LOGIC;
        memtoreg      : out STD_LOGIC;
        iord          : out STD_LOGIC;
        pc_write_cond : out STD_LOGIC;
        reg_dst       : out STD_LOGIC;
        regA          : out STD_LOGIC;
        regB          : out STD_LOGIC;
        mdr_write     : out STD_LOGIC;
        alu_out_enable: out STD_LOGIC
    );
end controller;

architecture Behavioral of controller is
    type state_type is (
        FETCH, DECODE, EXECUTE_R, MEM_ADDR, MEMREAD, MEMWRITE,
        WB_RTYPE, WB_LW, BRANCH, JUMP,MEMWRITE2,MEM_ADDR2,EXECUTE_R1,STORE2
    );
    signal state, next_state : state_type;
begin

    -- Transi??o de estado
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                state <= FETCH;
            else
                state <= next_state;
            end if;
        end if;
    end process;

    -- L?gica de controle
    process(state, opcode)
    begin
        -- Valores padr?o
        ir_write        <= '0';
        pc_write        <= '0';
        mem_read        <= '0';
        mem_write       <= '0';
        reg_write       <= '0';
        alu_op          <= "00";
        alu_src_a       <= '0';
        alu_src_b       <= "00";
        pc_src          <= '0';
        memtoreg        <= '0';
        iord            <= '0';
        pc_write_cond   <= '0';
        reg_dst         <= 'X';
        regA            <= '0';
        regB            <= '0';
        mdr_write       <= '0';
        alu_out_enable  <= '0';
        data<="00";
        next_state      <= FETCH;

        case state is
            when FETCH =>
                mem_read   <= '1';
                ir_write   <= '1';
                iord       <= '0';
                
                next_state <= DECODE;

            when DECODE =>
                regA            <= '1';
                regB            <= '1';
                alu_src_a  <= '0';
                alu_src_b  <= "01";
                alu_op     <= "00";
                pc_write   <= '1';
                pc_src     <= '0';
                case opcode is
                    when "0000" => next_state <= EXECUTE_R;
                    when "0001" => next_state <= MEM_ADDR;  -- lw
                    when "0010" => next_state <= MEM_ADDR;  -- sw
                    when "0011" => next_state <= BRANCH;
                    when "0100" => next_state <= JUMP;
                    when "0101"=> next_state<=MEM_ADDR2;
                    when "0110"=>next_state<=MEM_ADDR;
                    when others => next_state <= FETCH;
                end case;

            when EXECUTE_R =>
                alu_src_a       <= '1';
                alu_src_b       <= "00";
                alu_op          <= "10";
                alu_out_enable  <= '1';
                next_state <= WB_RTYPE;
            when EXECUTE_R1=>
                alu_src_a       <= '1';
                alu_src_b       <= "00";
                alu_op          <= "00";
                alu_out_enable  <= '0';
                data<="01";
                mem_write  <= '1';
                iord       <= '1';
              next_state <= FETCH;

            when WB_RTYPE =>
                reg_write  <= '1';
                memtoreg   <= '0';
                reg_dst    <= '1';
                next_state <= FETCH;

            when MEM_ADDR =>
                alu_src_a       <= '1';
                alu_src_b       <= "10";
                alu_op          <= "00";
                alu_out_enable  <= '1';
                if opcode = "0001" then
                    next_state <= MEMREAD;
                else
                    next_state <= MEMWRITE;
                end if;
                
            when MEM_ADDR2 =>
                alu_src_a       <= '1';
                alu_src_b       <= "10";
                alu_op          <= "00";
                alu_out_enable  <= '1';
                next_state <= EXECUTE_R1;   
                  
            when MEMREAD =>
                mem_read    <= '1';
                iord        <= '1';
                mdr_write   <= '1';
                next_state  <= WB_LW;

            when WB_LW =>
                reg_write  <= '1';
                memtoreg   <= '1';
                reg_dst    <= '0';
                next_state <= FETCH;

            when MEMWRITE =>
                data<="00";
                mem_write  <= '1';
                iord       <= '1';
                if opcode="0110" then
                next_state<=STORE2;
                else
                next_state <= FETCH;
                end if;
              when STORE2=>
              alu_src_a       <= '1';
                alu_src_b       <= "11";
                alu_op          <= "00";
                alu_out_enable  <= '1';
                
                next_state<=MEMWRITE2;
                when MEMWRITE2=>
                data<="10";
                mem_write  <= '1';
                iord       <= '1';
                next_state<=FETCH;
               
            when BRANCH =>
            alu_src_a       <= '1';
            alu_src_b       <= "00";
            alu_op          <= "01";
            alu_out_enable  <= '1';
            pc_src <= '1';
            pc_write_cond <= '1';
            next_state    <= FETCH;
  
            
            when JUMP =>
                pc_src     <= '1';
                pc_write   <= '1';
                next_state <= FETCH;

            

            when others =>
                next_state <= FETCH;
        end case;
    end process;

end Behavioral;
