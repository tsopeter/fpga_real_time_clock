----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2021 06:55:58 PM
-- Design Name: 
-- Module Name: bchrom - Behavioral
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

entity bchrom is
    Port ( x : in STD_LOGIC_VECTOR (3 downto 0);
           y : out STD_LOGIC_VECTOR (6 downto 0));
end bchrom;

architecture Behavioral of bchrom is
type rom is array (0 to 2**4 - 1) of std_logic_vector (6 downto 0);

--6 5 4 3 2 1 0
constant RM : rom := (
    0 =>  "0111111",    --'0'
    1 =>  "0000110",    --'1'
    2 =>  "1011011",    --'2'
    3 =>  "1001111",    --'3'
    4 =>  "1100110",    --'4'
    5 =>  "1101101",    --'5'
    6 =>  "1111101",    --'6'
    7 =>  "0000111",    --'7'
    8 =>  "1111111",    --'8'
    9 =>  "1100111",    --'9'
    10 => "1110111",    --'A'
    11 => "1111100",    -- unassigned
    12 => "0111001",    -- unassigned
    13 => "1110011",    --'P'
    14 => "1111001",    -- unassigned
    15 => "0000000"     --'null'
);
begin
    y <= not RM(to_integer(unsigned(x)));
end Behavioral;
