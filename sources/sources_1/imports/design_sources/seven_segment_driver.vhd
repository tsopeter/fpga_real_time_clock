LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.MATH_REAL.ALL;

ENTITY seven_segment_driver IS
        GENERIC(f_board   : REAL := 100.0E6; -- 100 MHz
                f_flicker : REAL := 62.5;    -- 62.5 Hz
                n_digits  : NATURAL := 8     -- 8 7-Segment Digits
                );
	PORT(clk      : IN  STD_LOGIC;
	     rst      : IN  STD_LOGIC;
	     data     : IN  STD_LOGIC_VECTOR(4*n_digits - 1 DOWNTO 0);
	     anodes   : OUT STD_LOGIC_VECTOR(n_digits - 1 DOWNTO 0);
	     cathodes : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	    );
END seven_segment_driver;

ARCHITECTURE behavior OF seven_segment_driver IS
-- general constants
constant seg_width    : natural := natural(7);

-- frequency constants
constant f_refresh    : natural := natural(real(n_digits) * f_flicker);

-- count constants
constant count_max1   : natural := natural(f_board/real(f_refresh));
constant count_max2   : natural := natural(n_digits-1);

-- bit constants
constant data_width   : natural := natural(4);
constant n_bits       : natural := natural(ceil(log2(real(n_digits))));
constant count1_width : natural := natural(ceil(log2(real(count_max1))));

-- internal signals
signal count_out      : std_logic_vector(n_bits-1 downto 0);
signal disp           : std_logic_vector(n_bits-1 downto 0);
signal max            : std_logic;
signal anode_decode   : std_logic_vector(n_digits-1 downto 0);
signal x              : std_logic_vector(data_width-1 downto 0);
signal y              : std_logic_vector(seg_width-1 downto 0);

-- temporary signals (discard)
signal tmp_gnd        : std_logic;
signal count_tmp      : std_logic_vector(count1_width-1 downto 0);

-- components
component modulo_counter is
    generic(n_bits : natural := 4;
            n_max  : natural := 15);
    Port ( clk : in STD_LOGIC;
           ce : in STD_LOGIC;
           reset : in STD_LOGIC;
           max : out std_logic;
           output : out STD_LOGIC_VECTOR (n_bits-1 downto 0));
end component;

component bchrom is
    Port ( x : in STD_LOGIC_VECTOR (3 downto 0);
           y : out STD_LOGIC_VECTOR (6 downto 0));
end component;

component decoder is
    generic(n_digits   : natural := 8;
            disp_width : natural := 4);
    Port ( disp : in STD_LOGIC_VECTOR (disp_width-1 downto 0);
           output : out STD_LOGIC_VECTOR (n_digits-1 downto 0));
end component;

component multiplexer is
    generic(data_width : natural := 4;
            n_digits   : natural := 8;
            n_data     : natural := 32;
            n_disp     : natural := 3);
    Port ( disp : in STD_LOGIC_vector(n_disp-1 downto 0);
           data : in STD_LOGIC_vector(n_data-1 downto 0);
           output : out STD_LOGIC_vector(data_width-1 downto 0));
end component;

BEGIN
-- counter 0
CTR0 : modulo_counter
generic map(n_bits => count1_width, n_max => count_max1)
port map   (clk => clk, ce => '1', reset => rst, max => max, output => count_tmp);

-- counter 1
CTR1 : modulo_counter
generic map(n_bits => n_bits, n_max => count_max2)
port map   (clk => clk, ce => max, reset => rst, max => tmp_gnd, output => count_out);

-- to display signal
disp <= count_out;

-- decoder 0
DCR0 : decoder
generic map(n_digits => n_digits, disp_width => n_bits)
port map   (disp => disp, output => anode_decode);

-- multiplexer 0
MPX0 : multiplexer
generic map(data_width => data_width, n_digits => n_digits, n_data => natural(4 * n_digits), n_disp => n_bits)
port map   (disp => disp, data => data, output => x);

-- rom 0
ROM0 : bchrom
port map(x => x, y => y);

-- output logic
anodes <= anode_decode;
cathodes <= y;

END behavior;
