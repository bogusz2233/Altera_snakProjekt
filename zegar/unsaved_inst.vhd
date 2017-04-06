	component unsaved is
		port (
			clkout_clk  : out std_logic;        -- clk
			clk_in_clk  : in  std_logic := 'X'; -- clk
			reset_reset : in  std_logic := 'X'  -- reset
		);
	end component unsaved;

	u0 : component unsaved
		port map (
			clkout_clk  => CONNECTED_TO_clkout_clk,  -- clkout.clk
			clk_in_clk  => CONNECTED_TO_clk_in_clk,  -- clk_in.clk
			reset_reset => CONNECTED_TO_reset_reset  --  reset.reset
		);

