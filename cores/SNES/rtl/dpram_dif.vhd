library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity dpram_dif is
    generic (
		addr_width_a  : integer := 8;
		data_width_a  : integer := 8;
		addr_width_b  : integer := 7;
		data_width_b  : integer := 16	-- data_width_b > data_width_a
    );
    port (
		clock			: in  STD_LOGIC;

		address_a	: in  STD_LOGIC_VECTOR (addr_width_a-1 DOWNTO 0);
		data_a		: in  STD_LOGIC_VECTOR (data_width_a-1 DOWNTO 0) := (others => '0');
		enable_a		: in  STD_LOGIC := '1';
		wren_a		: in  STD_LOGIC := '0';
		q_a			: out STD_LOGIC_VECTOR (data_width_a-1 DOWNTO 0);
		cs_a        : in  std_logic := '1';

		address_b	: in  STD_LOGIC_VECTOR (addr_width_b-1 DOWNTO 0) := (others => '0');
		data_b		: in  STD_LOGIC_VECTOR (data_width_b-1 DOWNTO 0) := (others => '0');
		enable_b		: in  STD_LOGIC := '1';
		wren_b		: in  STD_LOGIC := '0';
		q_b			: out STD_LOGIC_VECTOR (data_width_b-1 DOWNTO 0);
		cs_b        : in  std_logic := '1'
	);
end entity;

architecture rtl of dpram_dif is

	constant DEPTH_A  :  positive := 2**addr_width_a;
	constant DEPTH_B  :  positive := 2**addr_width_b;

    -- Functions
    function max(a, b : integer) return integer is
    begin
        if a > b then
            return a;
        else
            return b;
        end if;
    end function;

    function min(a, b : integer) return integer is
    begin
        if a < b then
            return a;
        else
            return b;
        end if;
    end function;

	constant maxSIZE   : integer := max(DEPTH_A, DEPTH_B);
	constant maxDWIDTH  : integer := max(data_width_a, data_width_b);
	constant minAWIDTH  : integer := min(addr_width_a, addr_width_b);
	constant minDWIDTH  : integer := min(data_width_a, data_width_b);
	constant RATIO     : integer := maxDWIDTH / minDWIDTH;

	type data_t is array (0 to RATIO-1) of std_logic_vector(minDWIDTH-1 downto 0);
	signal q_mpx_a : data_t;
	
	type enable_t is array (0 to RATIO-1) of std_logic;
	signal enable_sel_a : enable_t;

begin

--process(address_a, enable_a)
--begin
--	for ii in 0 to RATIO-1 loop
--		if to_integer(unsigned(address_a(RATIO-1 downto 0))) = ii then
--			enable_sel_a(ii) <= enable_a;
--		else
--			enable_sel_a(ii) <= '0';
--		end if;
--	end loop;
--end process;


dpram_gen : for ii in 0 to RATIO-1 generate
	u_dpram0 : entity work.dpram
		generic map (
			addr_width    => minAWIDTH,
			data_width    => minDWIDTH
		)
		port map (
			clock      => clock,
	
			address_a  => address_a(addr_width_a-1 downto RATIO-1),
			data_a     => data_a,
			enable_a   => enable_sel_a(ii),
			wren_a     => wren_a and enable_sel_a(ii),
			q_a        => q_mpx_a(ii),
			cs_a       => cs_a and enable_sel_a(ii),
	
			address_b  => address_b,
			data_b     => data_b(minDWIDTH*(ii+1)-1 downto minDWIDTH*ii),
			enable_b   => enable_b,
			wren_b     => wren_b,
			q_b        => q_b(minDWIDTH*(ii+1)-1 downto minDWIDTH*ii),
			cs_b       => cs_b
		);
end generate;

--q_a <= q_mpx_a(to_integer(unsigned(address_a(RATIO-1 downto 0))));
with address_a(0) select q_a <=
	q_mpx_a(1) when '1', q_mpx_a(0) when others;
with address_a(0) select enable_sel_a(1) <=
	enable_a when '1', '0' when others;
with address_a(0) select enable_sel_a(0) <=
	enable_a when '0', '0' when others;

end architecture;
