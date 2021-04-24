----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/24/2021 01:43:24 AM
-- Design Name: 
-- Module Name: blinker - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.math_real.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity blinker is
    generic (f_board : natural := 100E6;
             f_blink : natural := 5);
    Port ( clk  : in std_logic;
           disp : in STD_LOGIC_VECTOR (1 downto 0);
           en   : in std_logic;
           data_in : in STD_LOGIC_VECTOR (31 downto 0);
           data_out : out STD_LOGIC_VECTOR (31 downto 0));
end blinker;

architecture Behavioral of blinker is
-- constants
constant f_refresh : natural := natural(round(real(f_board)/real(f_blink))) - 1;
constant hz_bits   : natural := natural(ceil(log2(real(f_refresh))));

-- internal signals
signal mask, mask_tmp        : std_logic_vector(31 downto 0);
signal clk_div_max : std_logic;

-- register signals
signal r_reg, r_next : std_logic;
signal ce            : std_logic;

-- temporary signals
signal clk_div_tmp : std_logic_vector(hz_bits-1 downto 0);

-- components
component modulo_counter is
    generic(n_bits : natural := 4;
            n_max  : natural := 15);
    Port ( clk : in STD_LOGIC;
           ce : in STD_LOGIC;
           reset : in STD_LOGIC;
           max : out std_logic;
           output : out STD_LOGIC_VECTOR (n_bits-1 downto 0));
end component;
begin
-- clock divider
CLKDIV : modulo_counter
generic map(n_bits => hz_bits, n_max => f_refresh)
port map   (clk => clk, ce => '1', reset => '0', max => clk_div_max, output => clk_div_tmp);

-- assign the max of clock to clock enable
ce <= clk_div_max;

-- register
process(clk)
begin
    if(clk'event and clk='1')then
        if(ce='1')then
            r_reg <= r_next;
        end if;
    end if;
end process;

-- next state logic
r_next <= not r_reg;

-- output logic
with disp select
    mask_tmp <= "00000000000000000000000011111111" when "00",
                "00000000000000001111111100000000" when "01",
                "00000000111111110000000000000000" when "10",
                "11111111000000000000000000000000" when others;

mask <= mask_tmp when (r_reg='1' and en='1') else (others => '0');
data_out <= data_in or mask;

end Behavioral;
