----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/24/2021 02:40:31 AM
-- Design Name: 
-- Module Name: am_pm_convert - Behavioral
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

entity am_pm_convert is
    Port ( data_in : in STD_LOGIC_VECTOR (31 downto 0);
           data_out : out STD_LOGIC_VECTOR (31 downto 0));
end am_pm_convert;

architecture Behavioral of am_pm_convert is
signal ams_tmp, ams_out : std_logic_vector(3 downto 0);
begin
ams_tmp <= data_in(27 downto 24);
ams_out <= "1010" when (ams_tmp="0001") else "1101";
data_out <= data_in(31 downto 28) & ams_out & data_in(23 downto 0);
end Behavioral;
