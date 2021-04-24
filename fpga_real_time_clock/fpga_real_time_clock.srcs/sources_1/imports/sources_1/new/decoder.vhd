----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2021 03:05:34 PM
-- Design Name: 
-- Module Name: decoder - Behavioral
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

entity decoder is
    generic(n_digits   : natural := 8;
            disp_width : natural := 4);
    Port ( disp : in STD_LOGIC_VECTOR (disp_width-1 downto 0);
           output : out STD_LOGIC_VECTOR (n_digits-1 downto 0));
end decoder;

architecture Behavioral of decoder is

begin
process(disp)
variable tmp : unsigned(n_digits-1 downto 0) := (others => '0');
begin
    tmp := to_unsigned(2**to_integer(unsigned(disp)), n_digits);
    output <= not std_logic_vector(tmp);
end process;
end Behavioral;
