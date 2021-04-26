----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2021 09:27:34 PM
-- Design Name: 
-- Module Name: fpga_clock - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fpga_clock is
    generic(sec_ctr : natural := 100E6);
    Port ( clk : in std_logic;                          -- clock input
           rst_in : in std_logic;
           btn : in std_logic_vector(4 downto 0);       -- button input
           anodes : out STD_LOGIC_VECTOR (7 downto 0);  -- anode output for 8 seven-segment display
           seg : out STD_LOGIC_VECTOR (6 downto 0);   -- seg output for seven-segment display
           led : out std_logic_vector(4 downto 0));     -- led for status
end fpga_clock;

architecture Behavioral of fpga_clock is
-- constants
constant f_board   : real := 100.0E6; -- 100 MHz
constant f_flicker : real := 62.5;    -- 62.5 Hz
constant n_digits  : natural := 8;    -- 8 seven-segment display
constant n_bits    : natural := 6;

-- internal signals
signal rst        : std_logic;
signal ce         : std_logic;
signal pass       : std_logic;

signal sec_input  : std_logic_vector(n_bits-1 downto 0);
signal min_input  : std_logic_vector(n_bits-1 downto 0);
signal hrs_input  : std_logic_vector(n_bits-1 downto 0);
signal ams_input  : std_logic_vector(n_bits-1 downto 0);

signal sec_bridge : std_logic_vector(n_bits-1 downto 0);
signal min_bridge : std_logic_vector(n_bits-1 downto 0);
signal hrs_bridge : std_logic_vector(n_bits-1 downto 0);
signal ams_bridge : std_logic_vector(n_bits-1 downto 0);

signal disp0      : std_logic_vector(31 downto 0);
signal anodes_int : std_logic_vector(7 downto 0);
signal seg_int    : std_logic_vector(6 downto 0);

signal led_int    : std_logic_vector(4 downto 0);

signal disp_blink : std_logic_vector(1 downto 0);
signal disp1, disp2      : std_logic_vector(31 downto 0);

-- components
component seven_segment_driver IS
        GENERIC(f_board   : REAL := 100.0E6; -- 100 MHz
                f_flicker : REAL := 62.5;    -- 62.5 Hz
                n_digits  : NATURAL := 8     -- 8 7-Segment Digits
                );
	PORT(clk      : IN  STD_LOGIC;
	     rst      : IN  STD_LOGIC;
	     data     : IN  STD_LOGIC_VECTOR(4*n_digits - 1 DOWNTO 0);
	     anodes   : OUT STD_LOGIC_VECTOR(n_digits - 1 DOWNTO 0);
	     cathodes : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	    );
END component;

component clock_counter is
    generic(n_speed : natural := 100E6);
    Port ( clk : in STD_LOGIC;
           rst : in std_logic;
           ce  : in std_logic;
           pass : in std_logic;
           sec_in : in STD_LOGIC_VECTOR (5 downto 0);
           min_in : in STD_LOGIC_VECTOR (5 downto 0);
           hrs_in : in STD_LOGIC_VECTOR (5 downto 0);
           ams_in : in STD_LOGIC_VECTOR (5 downto 0);
           sec_out : out STD_LOGIC_VECTOR (5 downto 0);
           min_out : out STD_LOGIC_VECTOR (5 downto 0);
           hrs_out : out STD_LOGIC_VECTOR (5 downto 0);
           ams_out : out STD_LOGIC_VECTOR (5 downto 0));
end component;

component data_convert is
    Port ( sec_in : in STD_LOGIC_VECTOR (5 downto 0);
           min_in : in STD_LOGIC_VECTOR (5 downto 0);
           hrs_in : in STD_LOGIC_VECTOR (5 downto 0);
           ams_in : in STD_LOGIC_VECTOR (5 downto 0);
           data_out : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component setup_controller is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_vector (4 downto 0);
           pass : out std_logic;
           sec_out : out STD_LOGIC_VECTOR (5 downto 0);
           min_out : out STD_LOGIC_VECTOR (5 downto 0);
           hrs_out : out STD_LOGIC_VECTOR (5 downto 0);
           ams_out : out STD_LOGIC_VECTOR (5 downto 0);
           led     : out std_logic_vector(4 downto 0));
end component;

component blinker is
    generic (f_board : natural := 100E6;
             f_blink : natural := 5);
    Port ( clk  : in std_logic;
           disp : in STD_LOGIC_VECTOR (1 downto 0);
           en   : in std_logic;
           data_in : in STD_LOGIC_VECTOR (31 downto 0);
           data_out : out STD_LOGIC_VECTOR (31 downto 0));
end component;

component am_pm_convert is
    Port ( data_in : in STD_LOGIC_VECTOR (31 downto 0);
           data_out : out STD_LOGIC_VECTOR (31 downto 0));
end component;
begin
-- constant signals
rst <= rst_in;
ce  <= '1';

-- setup component
SETUP   : setup_controller
port map(clk => clk, btn => btn, pass => pass,
         sec_out => sec_input, min_out => min_input, hrs_out => hrs_input, ams_out => ams_input, led => led_int);

-- clock component
CLKCTR0 : clock_counter
generic map(n_speed => sec_ctr)
port map(clk => clk, rst => rst, ce => ce, pass => pass,
         sec_in => sec_input, min_in => min_input, hrs_in => hrs_input, ams_in => ams_input,
         sec_out => sec_bridge, min_out => min_bridge, hrs_out => hrs_bridge, ams_out => ams_bridge);

-- display assembly
DATACVT : data_convert
port map(sec_in => sec_bridge, min_in => min_bridge, hrs_in => hrs_bridge, ams_in => ams_bridge,
         data_out => disp0);
         
-- display driver
DISPDVR : seven_segment_driver
generic map(f_board => f_board, f_flicker => f_flicker, n_digits => n_digits)
port map   (clk => clk, rst => rst, data => disp2, anodes => anodes_int, cathodes => seg_int);

-- blinker select display
BLNKR : blinker
generic map(f_board => natural(f_board), f_blink => 7)
port map   (clk => clk, disp => disp_blink, en => pass, data_in => disp1, data_out => disp2);

-- am/pm converter
AMPM  : am_pm_convert
port map(data_in => disp0, data_out => disp1);
-- decoder
with led_int select
    disp_blink <= "00" when "00010" | "00011",
                  "01" when "00100" | "00101",
                  "10" when "01000" | "01001",
                  "11" when others;
-- output logic
anodes <= anodes_int;
seg    <= seg_int;
led    <= led_int;
end Behavioral;
