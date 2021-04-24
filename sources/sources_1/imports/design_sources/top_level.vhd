LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.MATH_REAL.ALL;

ENTITY top_level IS
	PORT(CLK100MHZ : IN  STD_LOGIC;
	     BTNC      : IN  STD_LOGIC;
	     SW        : IN  STD_LOGIC_VECTOR(15 DOWNTO 0);
	     AN        : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	     CA        : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	    );
END top_level;

ARCHITECTURE behavior OF top_level IS	

    COMPONENT seven_segment_driver
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
    END COMPONENT;
    
    CONSTANT f_board   : REAL := 100.0E6; -- 100 MHz
    CONSTANT f_flicker : REAL := 62.5;    -- 62.5 Hz
    CONSTANT n_digits  : NATURAL := 8;    -- 8 7Segment Digits
	
    SIGNAL clk      : STD_LOGIC;
    SIGNAL rst      : STD_LOGIC;
    SIGNAL data     : STD_LOGIC_VECTOR(4*n_digits - 1 DOWNTO 0);
    SIGNAL anodes   : STD_LOGIC_VECTOR(n_digits - 1 DOWNTO 0);
    SIGNAL cathodes : STD_LOGIC_VECTOR(6 DOWNTO 0);

BEGIN

    clk <= CLK100MHZ;
    rst <= BTNC;
    data <= SW & SW;
    AN <= anodes;
    CA <= cathodes;

    i0 : seven_segment_driver
         GENERIC MAP (f_board => f_board,
                      f_flicker => f_flicker,
                      n_digits => n_digits
                     )
         PORT MAP (clk => clk,
                   rst => rst,
                   data => data,
                   anodes => anodes,
                   cathodes => cathodes
                  );
END behavior;