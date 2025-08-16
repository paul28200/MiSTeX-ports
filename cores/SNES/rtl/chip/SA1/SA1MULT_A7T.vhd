LIBRARY ieee;
USE ieee.std_logic_1164.all;
Library UNISIM;
use UNISIM.vcomponents.all;
Library UNIMACRO;
use UNIMACRO.vcomponents.all;

ENTITY SA1MULT IS
	PORT
	(
		clock		: IN STD_LOGIC;
		ena			: IN STD_LOGIC;
		dataa		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		datab		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END SA1MULT;


ARCHITECTURE IP OF SA1MULT IS

BEGIN

   MULT : MULT_MACRO
   generic map (
      DEVICE => "7SERIES",    -- Target Device: "VIRTEX5", "7SERIES", "SPARTAN6" 
      LATENCY => 4,           -- Desired clock cycle latency, 0-4
      WIDTH_A => 16,          -- Multiplier A-input bus width, 1-25 
      WIDTH_B => 16)          -- Multiplier B-input bus width, 1-18
   port map (
      P => result,     -- Multiplier ouput bus, width determined by WIDTH_P generic 
      A => dataa,     -- Multiplier input A bus, width determined by WIDTH_A generic 
      B => datab,     -- Multiplier input B bus, width determined by WIDTH_B generic 
      CE => ena,   -- 1-bit active high input clock enable
      CLK => clock, -- 1-bit positive edge clock input
      RST => '0'  -- 1-bit input active high reset
   );

END IP;