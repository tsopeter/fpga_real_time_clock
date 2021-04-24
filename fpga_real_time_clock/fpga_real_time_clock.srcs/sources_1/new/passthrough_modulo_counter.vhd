----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2021 09:51:44 PM
-- Design Name: 
-- Module Name: passthrough_modulo_counter - Behavioral
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

entity passthrough_modulo_counter is
    generic(n_bits : natural := 4;
            n_max  : natural := 15);
    Port ( clk : in STD_LOGIC;
           pass : in std_logic;
           ce : in STD_LOGIC;
           reset : in STD_LOGIC;
           input : in std_logic_vector(n_bits-1 downto 0);
           max : out std_logic;
           output : out STD_LOGIC_VECTOR (n_bits-1 downto 0));
end passthrough_modulo_counter;

architecture Behavioral of passthrough_modulo_counter is
signal r_reg, r_next : unsigned(n_bits-1 downto 0);
signal r_int         : unsigned(n_bits-1 downto 0);
begin
process(clk, reset)
begin
    if(reset='1') then
        r_reg <= (others => '0');
    elsif(clk'event and clk='1')then
        if(ce='1')then
            r_reg <= r_next;
        end if;
   end if;
end process;

-- state next logic
r_int <= (others => '0') when (r_reg=n_max-1) else (r_reg + 1);
r_next <= r_int when (pass='0') else unsigned(input);

-- output logic
max   <= ce when (r_reg=n_max-1) else '0';
output <= std_logic_vector(r_reg);

end Behavioral;
