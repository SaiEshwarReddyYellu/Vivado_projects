

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.math_real.all;
use IEEE.NUMERIC_STD.ALL;


entity uart_rx is
--  Port ( );
    generic(clk_freq : integer := 50_000_000;
            baud_rate : integer := 115200;               --[clk/baud_rate := 50_000_000/115200   = 434.02]
            sam_rate : integer := 16;
            data_width : integer := 8);
   
    port(   rst: in std_logic;
            rx: in std_logic;
            clk: in std_logic;
            data_out: out std_logic_vector(7 downto 0);
            data_ready : out std_logic);
end uart_rx;

architecture Behavioral of uart_rx is

--constant rx_baud : integer := integer((( clk_freq)/(baud_rate * sam_rate)));
--constant rx_baud_width : integer := integer(log2(real(rx_baud)));

--signal rx_baud_cnt : unsigned(rx_baud_width-1 downto 0) := (others => '0');
--signal rx_baud_sig : std_logic := '0';

--type state_type is (start,data,stop);
--signal state : state_type := start;

--signal rx_bit : std_logic := '1';
--signal rx_buf : std_logic_vector(7 downto 0) := (others => '0');
--signal shift_reg : std_logic_vector(1 downto 0) := (others => '1');

--signal rx_fil : unsigned(1 downto 0) := (others => '0');
--signal rx_cnt : unsigned(2 downto 0) := (others => '0');

--signal data_ready_reg : std_logic := '0';
--signal bit_spacing : unsigned(3 downto 0) := (others => '0');
--signal uart_rx_baud_sig : std_logic := '0';

type state_type is (idle,wait_bit,sample_bit,store_bit);
signal state : state_type := idle;

constant baud_cnt_depth : integer := (integer(ceil(REAL(CLK_FREQ)/REAL(baud_rate))) - 2);       --434.27:= 435-2
signal sam_cnt : integer range 0 to baud_cnt_depth := 0;
signal bit_cnt : integer range 0 to 8 := 0;
signal rx_data : std_logic_vector (7 downto 0) := (others => '0');
signal samp_vect : std_logic_vector (31 downto 0) := (others => '0');
signal sys_clk : std_logic;

component clk_wiz_0 is
port(   clk_in1 : in std_logic;
        
        clk_out1 : out std_logic);

end component clk_wiz_0;

begin

data_out <= rx_data;                                  -- "start" "data" "stop"

clk_inst:clk_wiz_0

    port map(
           clk_in1 =>  clk,
           clk_out1 => sys_clk                  --sys_clk := 50_000_000(50 MHZ)
            );
uart_rx: process (sys_clk)
begin
    if rising_edge(sys_clk) then
        if rst = '1' then
            state <= idle;
        end if;
        
        case state is 
            when idle => 
            
                         if rx = '0' then
                            sam_cnt <= sam_cnt + 1;
                                if sam_cnt >= 232 then
                                    sam_cnt <= 0;
                                    state <= wait_bit;
                                end if;
                            else
                                state <= idle;
                                sam_cnt <= 0;
                                bit_cnt <= 0;
                                data_ready <= '0';
                                rx_data <= (others => '0');
                                samp_vect <= (others => '0');
                         end if;
                         
            when wait_bit =>
                        sam_cnt <= sam_cnt + 1;
                        if sam_cnt >= 400 then
                            sam_cnt <= 0;
                            state <= sample_bit;
                        end if;
                        
            when sample_bit =>
                        sam_cnt <= sam_cnt + 1;
                        samp_vect <= samp_vect(30 downto 0) & rx;
                        if sam_cnt >= 31 then
                            state <= store_bit;
                            sam_cnt <= 0;
                            bit_cnt <= bit_cnt + 1;
                        end if;
            
            when store_bit =>
                        if samp_vect = x"ffffffff" then
                            rx_data <= '1' & rx_data(7 downto 1);
                          elsif samp_vect = x"00000000" then
                            rx_data <= '0' & rx_data(7 downto 1);
                        end if;
                        
                        if bit_cnt = 9 then
                             state <= idle;
                             data_ready <= '1';
                            else
                             sam_cnt <= 0;
                             state <= wait_bit; 
                        end if;
            when others =>
                    state <= idle;
        end case;
    end if;
end process uart_rx;

end Behavioral;

