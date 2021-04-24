----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2021 11:36:18 PM
-- Design Name: 
-- Module Name: signal_toggle - Behavioral
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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity signal_toggle is
    Port ( clk : in std_logic;
           ce : in std_logic;
           user_input : in STD_LOGIC;
           output : out STD_LOGIC);
end signal_toggle;

architecture Behavioral of signal_toggle is
signal r_reg, r_next : std_logic := '0';
begin
process(clk)
begin
    if(clk'event and clk='1')then
        if(user_input='1' and ce='1')then
            r_reg <= r_next;
        end if;
    end if;
end process;

-- next state logic
r_next <= not r_reg;

-- output logic
output <= r_reg;
end Behavioral;
