----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2021 11:47:31 PM
-- Design Name: 
-- Module Name: move_toggle - Behavioral
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

entity move_toggle is
    generic(n_bits : natural := 4;
            n_max  : natural := 15);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           ctrl : in std_logic_vector(1 downto 0);
           ce : in STD_LOGIC;
           pass : in std_logic;
           input : in std_logic_vector(n_bits-1 downto 0);
           output : out STD_LOGIC_VECTOR (n_bits-1 downto 0));
end move_toggle;

architecture Behavioral of move_toggle is
signal r_reg, r_next : unsigned(n_bits-1 downto 0) := (others => '0');
begin
process(clk,reset)
begin
    if(reset='1')then
        r_reg <= (others => '0');
    elsif(clk'event and clk='1')then
        if(ce='1')then
            r_reg <= r_next;
        end if;
    end if;
 end process;
 
 -- state next logic
 process(r_reg)
 begin
    if(pass='1')then
        r_next <= unsigned(input);
    else
        case ctrl is
            when "01" =>
                if(r_reg > 0)then
                    r_next <= r_reg-1;
                else
                    r_next <= to_unsigned(n_max-1, n_bits);
                end if;
            when "10" =>
                if(r_reg < n_max-1)then
                    r_next <= r_reg+1;
                else
                    r_next <= (others => '0');
                end if;
            when others => 
                r_next <= r_reg;
            end case;
    end if;
 end process;
 
 -- output logic
 output <= std_logic_vector(r_reg);
        
end Behavioral;
