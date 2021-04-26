----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2021 04:12:23 PM
-- Design Name: 
-- Module Name: fpga_clock_sim - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fpga_clock_sim is
--  Port ( );
end fpga_clock_sim;

architecture Behavioral of fpga_clock_sim is
component fpga_clock is
    generic(sec_ctr : natural := 100E6);
    Port ( clk : in std_logic;                          -- clock input
           rst_in : in std_logic;
           btn : in std_logic_vector(4 downto 0);       -- button input
           anodes : out STD_LOGIC_VECTOR (7 downto 0);  -- anode output for 8 seven-segment display
           seg : out STD_LOGIC_VECTOR (6 downto 0);   -- seg output for seven-segment display
           led : out std_logic_vector(4 downto 0));     -- led for status
end component;
constant clk_period : time := 10 ns;
signal rst : std_logic;
signal clk : std_logic;
signal btn, led : std_logic_vector(4 downto 0);
signal an : std_logic_vector(7 downto 0);
signal seg : std_logic_vector(6 downto 0);
begin

process
begin
    rst <= '1';
    wait for 5 ns;
    rst <= '0';
    wait for 100 sec;
end process;

btn <= (others => '0');

UUT: fpga_clock
generic map(sec_ctr => 100E6)
port map   (clk => clk, rst_in => rst, btn => btn, anodes => an, seg => seg, led => led);

process
begin
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
end process;

end Behavioral;
