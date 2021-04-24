----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2021 09:58:56 PM
-- Design Name: 
-- Module Name: data_convert - Behavioral
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

entity data_convert is
    Port ( sec_in : in STD_LOGIC_VECTOR (5 downto 0);
           min_in : in STD_LOGIC_VECTOR (5 downto 0);
           hrs_in : in STD_LOGIC_VECTOR (5 downto 0);
           ams_in : in STD_LOGIC_VECTOR (5 downto 0);
           data_out : out STD_LOGIC_VECTOR (31 downto 0));
end data_convert;

architecture Behavioral of data_convert is
-- constants
constant data_width : natural := 4;

-- internal signals
signal sec0, sec1     : unsigned(5 downto 0);
signal min0, min1     : unsigned(5 downto 0);
signal hrs0, hrs1     : unsigned(5 downto 0);
signal ams0, ams1     : unsigned(5 downto 0);
signal data_int       : unsigned(31 downto 0);
begin
-- seconds converter
sec0 <= unsigned(sec_in) mod 10;
sec1 <= (unsigned(sec_in) - sec0) / 10;

-- minutes converter
min0 <= unsigned(min_in) mod 10;
min1 <= (unsigned(min_in) - min0) / 10;

-- hours conveter
hrs0 <= (unsigned(hrs_in) + 1) mod 10;
hrs1 <= (unsigned(hrs_in) + 1 - hrs0) / 10;

-- ams converter
ams0 <= unsigned(ams_in);
ams1 <= (others => '0');

-- combining the data
data_int <= ams1(data_width-1 downto 0) & ams0(data_width-1 downto 0) & hrs1(data_width-1 downto 0)
          & hrs0(data_width-1 downto 0) & min1(data_width-1 downto 0) & min0(data_width-1 downto 0)
          & sec1(data_width-1 downto 0) & sec0(data_width-1 downto 0);

-- output
data_out <= std_logic_vector(data_int);

end Behavioral;
