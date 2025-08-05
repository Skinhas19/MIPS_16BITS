library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity datapath is
    Port ( CLK1 : in  STD_LOGIC;
        RESET1 : in STD_LOGIC
    );
end datapath;
architecture Behavioral of datapath is
component controller
port(
        clk           : in  STD_LOGIC;
        reset         : in STD_LOGIC;
        opcode        : in  STD_LOGIC_VECTOR(3 downto 0); -- opcode da instrução (bits 15 downto 12, por exemplo)
        data         : out STD_LOGIC_VECTOR(1 downto 0);
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
        reg_dst : out STD_LOGIC;
        regA          : out STD_LOGIC;
        regB          : out STD_LOGIC;
        mdr_write : out STD_LOGIC;
        alu_out_enable : out STD_LOGIC
        
 );
end component;
component REG
    Port (
        clk      : in  STD_LOGIC; -- Clock
        enable : in STD_LOGIC;                         -- Habilita escrita
        data_in  : in  STD_LOGIC_VECTOR(15 downto 0);     -- Dado de entrada
        data_out : out STD_LOGIC_VECTOR(15 downto 0)      -- Dado de sa?da
    );
end component;


component ALU_Controle
 Port (
        alu_op   : in  STD_LOGIC_VECTOR(1 downto 0); -- Sinal vindo da unidade de controle principal
        funct    : in  STD_LOGIC_VECTOR(2 downto 0); -- Campo de fun??o da instru??o (3 bits do funct em 16 bits)
        alu_ctrl : out STD_LOGIC_VECTOR(2 downto 0)  -- Sinal de controle final para a ALU
    );

end component;

component ALU
 Port ( 
    a1          : in  STD_LOGIC_VECTOR (15 downto 0);
    a2          : in  STD_LOGIC_VECTOR (15 downto 0);
    alu_control : in  STD_LOGIC_VECTOR (2 downto 0); -- 3 bits de controle
    alu_result  : out STD_LOGIC_VECTOR (15 downto 0);
    zero        : out STD_LOGIC
  );
end component;

component Banco_Registradores
Port (
    clk:in std_logic;
    rs : in STD_LOGIC_VECTOR (2 downto 0);
    rt : in STD_LOGIC_VECTOR (2 downto 0);
    rd  : in STD_LOGIC_VECTOR (2 downto 0);
    dado_escrita : in STD_LOGIC_VECTOR (15 downto 0);
    habilita_escrita : in STD_LOGIC;
    dado_saida1  : out STD_LOGIC_VECTOR (15 downto 0);
    dado_saida2  : out STD_LOGIC_VECTOR (15 downto 0)
  );

end component;

component Memoria
Port (
    endereco     : in  STD_LOGIC_VECTOR(5 downto 0);         -- 8 bits: 256 posi??es (16 bits cada)
    dado_escrita : in  STD_LOGIC_VECTOR(15 downto 0);        -- dado a ser escrito
    leitura_mem  : in  STD_LOGIC;                            -- habilita leitura
    escrita_mem  : in  STD_LOGIC;                            -- habilita escrita
    dado_lido    : out STD_LOGIC_VECTOR(15 downto 0);        -- sa?da do dado lido
    IORD         : in  STD_LOGIC;                            -- 0 = instru??o (ROM), 1 = dados (RAM)
    clk          : in  STD_LOGIC
  );
end component;

component MUX_3
Port (
    mux_in0 : in STD_LOGIC_VECTOR(15 downto 0);
    mux_in1 : in STD_LOGIC_VECTOR(15 downto 0);
    mux_in2 : in STD_LOGIC_VECTOR(15 downto 0);
    mux_ctl : in STD_LOGIC_VECTOR(1 downto 0);
    mux_out : out STD_LOGIC_VECTOR(15 downto 0)
  );
end component;

component MUX2
Port ( 
    mux_in0 : in STD_LOGIC_VECTOR(15 downto 0);
    mux_in1 : in STD_LOGIC_VECTOR(15 downto 0);
    mux_ctl : in STD_LOGIC;
    mux_out : out STD_LOGIC_VECTOR(15 downto 0)
  );
end component;

component MUX4
Port ( 
    mux_in0 : in STD_LOGIC_VECTOR(15 downto 0);
    mux_in1 : in STD_LOGIC_VECTOR(15 downto 0);
    mux_in2 : in STD_LOGIC_VECTOR(15 downto 0);
    mux_in3 : in STD_LOGIC_VECTOR(15 downto 0);
    mux_ctl : in STD_LOGIC_VECTOR(1 downto 0);
    mux_out : out STD_LOGIC_VECTOR(15 downto 0)
  );

end component;

component add1
 Port (
        a : in  STD_LOGIC_VECTOR (15 downto 0);
        b : out STD_LOGIC_VECTOR (15 downto 0)
    );
end component;

component SignExtend
    Port (
            a : in  STD_LOGIC_VECTOR (5 downto 0);
            b : out STD_LOGIC_VECTOR (15 downto 0)
        );
    end component;

component Reg_dst is
  Port (
    mux_in0 : in  STD_LOGIC_VECTOR(2 downto 0);
    mux_in1 : in  STD_LOGIC_VECTOR(2 downto 0);
    mux_ctl : in  STD_LOGIC;
    mux_out : out STD_LOGIC_VECTOR(2 downto 0)
  );
end component;    
    
    signal sig_dado_mem,saida_b,pc_out, pc_in, alu_result1, alu_out, a_out, b_out, mdr_out, mem_out,alu_src_a,alu_src_b, sign_ext, plus1, mux_mem_out,mux_memtoreg_out, jump_address,saida_a, instruction : STD_LOGIC_VECTOR(15 downto 0);

    signal  alu_control1,reg_dst_out : STD_LOGIC_VECTOR(2 downto 0);
    
    signal sig_data,mux_alu_src_b,sig_alu_op : STD_LOGIC_VECTOR(1 downto 0);
   
    signal sig_pc_source,mux_memtoreg, mux_regdst,sigA,sigB,mux_pc_ctl, mux_alu_src_a,sig_alu_out,sig_mdr,pc_enable,sig_zero,sig_mem_read, sig_mem_write, sig_ir_write, sig_reg_write,sig_pc_write_cond,sig_pc_write : STD_LOGIC;
    
begin
    
    unit_control: controller port map(
    clk=>CLK1,
    reset=>RESET1,
    opcode=>instruction(15 downto 12),
    data=>sig_data,   
    ir_write=>sig_ir_write,     
        pc_write=>sig_pc_write,      
        mem_read=>sig_mem_read,      
        mem_write=>sig_mem_write,    
        reg_write=>sig_reg_write,     
        alu_op=>sig_alu_op,        
        alu_src_a=>mux_alu_src_a,     
        alu_src_b=>mux_alu_src_b,    
        pc_src=>sig_pc_source,        
        memtoreg=>mux_memtoreg,    
        iord=>mux_pc_ctl,         
        pc_write_cond=>sig_pc_write_cond,
        reg_dst=>mux_regdst,
        regA=>sigA,
        regB=>sigB,
        mdr_write=>sig_mdr,
    alu_out_enable=>sig_alu_out
    );
    
    pc_enable <= (sig_zero and sig_pc_write_cond) or sig_pc_write;
    -- PC
    PC: REG port map(
        clk => CLK1,
        enable => pc_enable, -- controlado pela UC
        data_in => pc_in,
        data_out => pc_out
    );

    -- Mux IorD
    mux_IorD: MUX2 port map(
        mux_in0 => pc_out,
        mux_in1 => alu_out,
        mux_ctl => mux_pc_ctl,
        mux_out => mux_mem_out
    );

    -- Memória
    mem: Memoria port map(
        endereco => mux_mem_out(5 downto 0),
        dado_escrita=>sig_dado_mem,
        leitura_mem => sig_mem_read,
        escrita_mem => sig_mem_write,
        dado_lido => mem_out,
        IORD => mux_pc_ctl,
        clk => CLK1
    );

    -- Instruction Register
    ir1: REG port map(
        clk => CLK1,
        enable => sig_ir_write,
        data_in => mem_out,
        data_out => instruction
    );
    --Write Data
    writedata:MUX_3 port map(
    mux_in0 =>saida_b,
    mux_in1=>alu_result1,
    mux_in2 => saida_a,
    mux_ctl=>sig_data,
    mux_out=>sig_dado_mem
    );

    -- MDR
    mdr1: REG port map(
        clk => CLK1,
        enable=>sig_mdr,
        data_in => mem_out,
        data_out => mdr_out
    );

    -- Banco de Registradores
    reg_file: Banco_Registradores port map(
        clk=>CLK1,
        rs => instruction(11 downto 9),
        rt => instruction(8 downto 6),
        rd => reg_dst_out,
        dado_escrita => mux_memtoreg_out,
        habilita_escrita => sig_reg_write,
        dado_saida1 => a_out,
        dado_saida2 => b_out
    );
    
    -- Registrador A
    reg_A: REG port map(
        clk => CLK1,
        enable=>sigA,
        data_in => a_out,
        data_out => saida_a
    );
    
    -- Registrador B
    reg_B: REG port map(
        clk => CLK1,
        enable=>sigB,
        data_in => b_out,
        data_out => saida_b
    );

    -- Sign Extend
    ext: SignExtend port map(
        a => instruction(5 downto 0),
        b => sign_ext
    );

    -- add_1
    add_1: add1 port map(
        a => sign_ext,
        b => plus1
    );

    -- Mux ALUSrcA
    mux_a: MUX2 port map(
        mux_in0 => pc_out,
        mux_in1 => saida_a,
        mux_ctl => mux_alu_src_a,
        mux_out => alu_src_a
    );

    -- Mux ALUSrcB
    mux_b: MUX4 port map(
        mux_in0 => saida_b,
        mux_in1 => "0000000000000001",
        mux_in2 => sign_ext,
        mux_in3 => plus1,
        mux_ctl => mux_alu_src_b,
        mux_out => alu_src_b
    );

    -- ALU
    ula: ALU port map(
        a1 => alu_src_a,
        a2 => alu_src_b,
        alu_control => alu_control1,
        alu_result => alu_result1,
        zero => sig_zero
    );

    -- ALUOut
    alu_out_reg: REG port map(
        clk => CLK1,
        data_in => alu_result1,
        data_out => alu_out,
        enable=>sig_alu_out
    );

    -- Mux RegDst
    muxregdst: Reg_dst port map(
        mux_in0 => instruction(8 downto 6),
        mux_in1 => instruction(5 downto 3),
        mux_ctl => mux_regdst,
        mux_out => reg_dst_out
    );

    -- Mux MemToReg
    muxmemtoreg: MUX2 port map(
        mux_in0 => alu_out,
        mux_in1 => mdr_out,
        mux_ctl => mux_memtoreg,
        mux_out => mux_memtoreg_out
    );

    -- Jump Address
    jump_address <= "0000000000" & instruction(5 downto 0);

    -- Mux PC Source (com 2 entradas: ALU result, Jump)
    muxpc: MUX2 port map(
        mux_in0 => alu_result1,
        mux_in1=> jump_address,
        mux_ctl => sig_pc_source,
        mux_out => pc_in
    );

    -- ALU Control
    alu_ctrl: ALU_Controle port map(
        alu_op => sig_alu_op,
        funct => instruction(2 downto 0),
        alu_ctrl => alu_control1
    );


end Behavioral;
