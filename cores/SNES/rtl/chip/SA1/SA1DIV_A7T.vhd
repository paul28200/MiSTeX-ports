LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY SA1DIV IS
	PORT
	(
		clock		: in  std_logic ;
		denom		: in  std_logic_vector (15 downto 0);
		numer		: in  std_logic_vector (15 downto 0);
		quotient		: out std_logic_vector (15 downto 0);
		remain		: out std_logic_vector (15 downto 0)
	);
END SA1DIV;


ARCHITECTURE rtl OF sa1div IS

	COMPONENT pll_sa1
	  PORT (
	  -- Clock in ports
	  -- Clock out ports
	  clkout0          : out    std_logic;
	  -- Status and control signals
	  rst             : in     std_logic;
	  locked            : out    std_logic;
	  refclk           : in     std_logic
	 );
	END COMPONENT;

	COMPONENT divider
	  GENERIC (
	  is32      : in  std_logic);
	  PORT (
      clk       : in  std_logic;
      start     : in  std_logic;
--      is32      : in  std_logic;
      done      : out std_logic := '0';
      busy      : out std_logic := '0';
      dividend  : in  signed;
      divisor   : in  signed;
      quotient  : out signed;
      remainder : out signed
   );
	END COMPONENT;

	signal CLK_12 : std_logic;
	signal RESULT	: std_logic_vector (31 downto 0);
	signal SIGNED_DENOM : std_logic_vector (15 downto 0);
	signal quotient_s, remainder_s : signed(15 downto 0);
	signal START, BUSY, DONE : std_logic;
	signal NUMER_r : std_logic_vector(numer'range);
	signal DENOM_r : std_logic_vector(denom'range);

begin

	SIGNED_DENOM <= '0' & denom(14 downto 0);

	CLK : pll_sa1
	   port map ( 
	   clkout0 => CLK_12,  -- clock x 12          
	   rst => '0',
	   locked => open,
	   refclk => clock
	 );
 
	DIV : divider
	  GENERIC MAP (is32 => '0')
	  PORT MAP (
      clk => CLK_12,
      start => START,
--      is32 => '0',
      done => DONE,
      busy => BUSY,
      dividend => signed(numer),
      divisor => signed(SIGNED_DENOM),
      quotient => quotient_s,
      remainder => remainder_s
   );

quotient <= std_logic_vector(quotient_s);
remain <= std_logic_vector(remainder_s);

process(CLK_12)
begin
if CLK_12'event and CLK_12 = '1' then
	if START = '1' then
		NUMER_r <= numer;
		DENOM_r <= denom;
	end if;
end if;
end process;

START <= '0' when BUSY = '1' else
		'0' when denom = x"0000" else
		'1' when NUMER_r /= numer or DENOM_r /= denom else
		'0';

end rtl;