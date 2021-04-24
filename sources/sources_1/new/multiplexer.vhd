----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2021 03:28:11 PM
-- Design Name: 
-- Module Name: multiplexer - Behavioral
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

entity multiplexer is
    generic(data_width : natural := 4;
            n_digits   : natural := 8;
            n_data     : natural := 32;
            n_disp     : natural := 3);
    Port ( disp : in STD_LOGIC_vector(n_disp-1 downto 0);
           data : in STD_LOGIC_vector(n_data-1 downto 0);
           output : out STD_LOGIC_vector(data_width-1 downto 0));
end multiplexer;

architecture Behavioral of multiplexer is

begin
process(disp, data)
variable tmp : unsigned(data_width-1 downto 0) := (others => '0');
begin
    for I in 0 to n_digits-1 loop
        if(I=unsigned(disp))then
            tmp := unsigned(data(data_width * (I + 1)-1 downto data_width * I));
        end if;
    end loop;
    output <= std_logic_vector(tmp);
end process;
end Behavioral;
