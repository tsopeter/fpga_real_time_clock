----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2021 11:12:32 PM
-- Design Name: 
-- Module Name: setup_controller - Behavioral
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

entity setup_controller is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_vector (4 downto 0);
           pass : out std_logic;
           sec_out : out STD_LOGIC_VECTOR (5 downto 0);
           min_out : out STD_LOGIC_VECTOR (5 downto 0);
           hrs_out : out STD_LOGIC_VECTOR (5 downto 0);
           ams_out : out STD_LOGIC_VECTOR (5 downto 0);
           led     : out std_logic_vector(4 downto 0));
end setup_controller;

architecture Behavioral of setup_controller is
-- constants
constant hz_bit : natural := natural(ceil(log2(real(100E6))));
constant hz_max : natural := 100E6;
constant n_bits : natural := 6;
constant sec_max : natural := 60;
constant min_max : natural := 60;
constant hrs_max : natural := 12;
constant ams_max : natural := 2;

-- alias signals
alias setup : std_logic is btn(0);
alias mv_left : std_logic is btn(1);
alias mv_right : std_logic is btn(2);
alias mv_up : std_logic is btn(3);
alias mv_down : std_logic is btn(4);

-- internal signals
signal hz_max_out : std_logic;
signal sec_int    : std_logic_vector(n_bits- 1 downto 0);
signal min_int    : std_logic_vector(n_bits- 1 downto 0);
signal hrs_int    : std_logic_vector(n_bits- 1 downto 0);
signal ams_int    : std_logic_vector(n_bits- 1 downto 0);

signal reset      : std_logic;
signal pass_int   : std_logic;
signal ce_int     : std_logic_vector(3 downto 0);
signal mv_out, as_out     : std_logic_vector(1 downto 0);
signal mv_en      : std_logic;
signal pass_en, setup_en    : std_logic;
signal ctrl       : std_logic_vector(1 downto 0);
signal clk_ctrl   : std_logic_vector(1 downto 0);

signal base_val   : std_logic_vector(n_bits-1 downto 0);

-- temporary signals
signal hz_tmp : std_logic_vector(hz_bit-1 downto 0);
signal hz_out : std_logic_vector(hz_bit-1 downto 0);
signal sec_max_out, min_max_out, hrs_max_out, ams_max_out : std_logic;
signal ce_int_tmp : std_logic_vector(3 downto 0);
signal hz_max_ext : std_logic_vector(3 downto 0);
signal pass_int_ext : std_logic_vector(3 downto 0);

-- components
component passthrough_modulo_counter is
    generic(n_bits : natural := 4;
            n_max  : natural := 15);
    Port ( clk : in STD_LOGIC;
           pass : in std_logic;
           ce : in STD_LOGIC;
           reset : in STD_LOGIC;
           input : in std_logic_vector(n_bits-1 downto 0);
           max : out std_logic;
           output : out STD_LOGIC_VECTOR (n_bits-1 downto 0));
end component;

component signal_toggle is
    Port ( clk : in std_logic;
           ce : in std_logic;
           user_input : in STD_LOGIC;
           output : out STD_LOGIC);
end component;

component move_toggle is
    generic(n_bits : natural := 4;
            n_max  : natural := 15);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           ctrl : in std_logic_vector(1 downto 0);
           ce : in STD_LOGIC;
           pass : in std_logic;
           input : in std_logic_vector(n_bits-1 downto 0);
           output : out STD_LOGIC_VECTOR (n_bits-1 downto 0));
end component;
begin
-- constant signals
hz_tmp <= (others => '0');
base_val <= (others => '0');
hz_max_ext <= (others => hz_max_out);

-- temporary constant signals for testing only
reset <= '0';

-- signal toggle
SGTG : signal_toggle
port map(clk => clk, ce => hz_max_out, user_input => setup, output => pass_en);

mv_en <= hz_max_out and pass_en;
ctrl  <= mv_left & mv_right;
clk_ctrl <= mv_up & mv_down;

-- move toggle for left and right
MVTG : move_toggle
generic map(n_bits => 2, n_max => 4)
port map   (clk => clk, reset => reset, ctrl => ctrl, ce => mv_en, pass => '0', input => "00", output => mv_out);


-- multiplexer for clock enable of counters
with mv_out select
    ce_int_tmp <= "0001" when "00",
                  "0010" when "01",
                  "0100" when "10",
                  "1000" when others;
                  
pass_int <= '1' when (setup='1' and pass_en='0') else '0'; 
pass_int_ext <= (others => pass_int);
ce_int <= (ce_int_tmp and hz_max_ext) or pass_int_ext;
----------------------------------------------
-- Signals below are for clock input system --
----------------------------------------------

-- pulse clock
PLS1 : passthrough_modulo_counter
generic map(n_bits => hz_bit, n_max => hz_max)
port map   (clk => clk, pass => '0', ce => '1', reset => '0', input => hz_tmp, max => hz_max_out, output => hz_out);

SECMVTG : move_toggle
generic map(n_bits => n_bits, n_max => sec_max)
port map   (clk => clk, reset => reset, ctrl => clk_ctrl, ce => ce_int(0), pass => pass_int, input => base_val, output => sec_int);

MINMVTG : move_toggle
generic map(n_bits => n_bits, n_max => min_max)
port map   (clk => clk, reset => reset, ctrl => clk_ctrl, ce => ce_int(1), pass => pass_int, input => base_val, output => min_int);

HRSMVTG : move_toggle
generic map(n_bits => n_bits, n_max => hrs_max)
port map   (clk => clk, reset => reset, ctrl => clk_ctrl, ce => ce_int(2), pass => pass_int, input => base_val, output => hrs_int);

AMSMVTG : move_toggle
generic map(n_bits => n_bits, n_max => ams_max)
port map   (clk => clk, reset => reset, ctrl => clk_ctrl, ce => ce_int(3), pass => pass_int, input => base_val, output => ams_int);

-- outputs
sec_out <= sec_int;
min_out <= min_int;
hrs_out <= hrs_int;
ams_out <= ams_int;

pass <= pass_en;

led <= ce_int_tmp & pass_en;

end Behavioral;
