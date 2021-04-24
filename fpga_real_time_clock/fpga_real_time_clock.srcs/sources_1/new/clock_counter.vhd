----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2021 09:38:28 PM
-- Design Name: 
-- Module Name: clock_counter - Behavioral
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

entity clock_counter is
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
end clock_counter;

architecture Behavioral of clock_counter is
-- constants
constant hz_bits : natural := natural(ceil(log2(real(100E6))));
constant n_bits  : natural := 6;
constant hz_max  : natural := 100E6;
constant sec_max : natural := 60;
constant min_max : natural := 60;
constant hrs_max : natural := 12;
constant ams_max : natural := 2;

-- internal signals
signal hz_out      : std_logic;
signal sec_max_out : std_logic;
signal min_max_out : std_logic;
signal hrs_max_out : std_logic;
signal ams_max_out : std_logic;

signal sec_int     : std_logic_vector(n_bits-1 downto 0);
signal min_int     : std_logic_vector(n_bits-1 downto 0);
signal hrs_int     : std_logic_vector(n_bits-1 downto 0);
signal ams_int     : std_logic_vector(n_bits-1 downto 0);

signal sec_en, min_en, hrs_en, ams_en : std_logic;

-- temporary signals
signal hz_dispose  : std_logic_vector(hz_bits-1 downto 0);
signal hz_tmp      : std_logic_vector(hz_bits-1 downto 0) := (others => '0');

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
-- temporary signals
hz_tmp <= (others => '0');

-- enable signals
sec_en <= hz_out or pass;
min_en <= sec_max_out or pass;
hrs_en <= min_max_out or pass;
ams_en <= hrs_max_out or pass;

-- pulse clock circuit
PLS0 : passthrough_modulo_counter
generic map(n_bits => hz_bits, n_max => hz_max)
port map   (clk => clk, pass => '0', ce => ce, reset => rst, input => hz_tmp,  max => hz_out, output => hz_dispose);

-- second counter
SEC0 : passthrough_modulo_counter
generic map(n_bits => n_bits, n_max => sec_max)
port map   (clk => clk, pass => pass, ce => sec_en, reset => rst, input => sec_in, max => sec_max_out, output => sec_int);

-- minute counter
MIN0 : passthrough_modulo_counter
generic map(n_bits => n_bits, n_max => min_max)
port map   (clk => clk,pass => pass, ce => min_en, reset => rst, input => min_in, max => min_max_out, output => min_int);

-- hours counter
HRS0 : passthrough_modulo_counter 
generic map(n_bits => n_bits, n_max => hrs_max)
port map   (clk => clk, pass => pass, ce => hrs_en, reset => rst, input => hrs_in, max => hrs_max_out, output => hrs_int);

-- am/pm counter
AMP0 : passthrough_modulo_counter
generic map(n_bits => n_bits, n_max => ams_max)
port map   (clk => clk, pass => pass, ce => ams_en, reset => rst, input => ams_in, max => ams_max_out, output => ams_int);

-- output logic
sec_out <= sec_int;
min_out <= min_int;
hrs_out <= hrs_int;
ams_out <= ams_int;

end Behavioral;
