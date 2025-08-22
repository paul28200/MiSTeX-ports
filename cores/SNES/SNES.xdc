
#create_generated_clock -name GSU_CACHE_CLK -source [get_pins -compatibility_mode {*|pll|pll_inst|altera_pll_i|*[2].*|divclk}] \
#							  -invert [get_pins {emu|main|GSUMap|GSU|CACHE|altsyncram_component|auto_generated|*|clk0}]

#create_generated_clock -name CX4_MEM_CLK -source [get_pins -compatibility_mode {*|pll|pll_inst|altera_pll_i|*[2].*|divclk}] \
#							  -invert [get_pins {emu|main|CX4Map|CX4|DATA_RAM|altsyncram_component|auto_generated|*|clk0 \
#														emu|main|CX4Map|CX4|DATA_ROM|spram_sz|altsyncram_component|auto_generated|altsyncram1|*|clk0 }]

#get_cells emu/main/GSUMap/GSU/CACHE/*

################################################################################
# Multi-cycle path constraints

#set_multicycle_path 5 -from [get_clocks clkout2] -to [get_clocks clkout2] -setup
#set_multicycle_path 4 -from [get_clocks clkout2] -to [get_clocks clkout2] -hold

#set_multicycle_path -from [get_cells emu/main*/SNES/CPU/P65C816/*] to [get_cells emu/main*/SNES/CPU/P65C816/*] 4
#set_multicycle_path -from [get_cells emu/main*/SNES/SMP/*] -to [get_cells emu/main*/SNES/SMP/*] 4

#set_multicycle_path -from {emunst/sdram_i/*} -to [get_clocks {*/pll_i/outclk_2] -start -setup 2
#set_multicycle_path -rise_from [get_cells {emu/sdram*/*}] -rise_to [get_pins emu/pll_i/outclk_2] 2
#set_multicycle_path -from {emunst/sdram_i/*} -to [get_clocks {*/pll_i/outclk_2] -start -hold 1
#set_multicycle_path -fall_from [get_cells {emu/sdram_i*}] -fall_to [get_pins emu/pll_i/outclk_2] 1

#set_multicycle_path -from [get_clocks {*/pll_i/outclk_2] -to {emunst/sdram_i/*} -setup 2
#set_multicycle_path -rise_from [get_pins emu/pll_i/outclk_2] -rise_to [get_cells {emu/sdram_i*}] 2
#set_multicycle_path -from [get_clocks {*/pll_i/outclk_2] -to {emunst/sdram_i/*} -hold 1
#set_multicycle_path -fall_from [get_pins emu/pll_i/outclk_2] -fall_to [get_cells {emu/sdram_i*}] 1

set_clock_groups -asynchronous -group [get_clocks { GSU_CACHE_CLK CX4_MEM_CLK }] 


################################################################################
# Max delay constraints

set_max_delay -from [get_cells { emu/hps_io/ioctl* }] 23.0
set_max_delay -to   [get_cells { emu/sdram*/a[*] \
													 emu/sdram*/ram_req* \
													 emu/sdram*/we* \
													 emu/sdram*/state_reg[*] \
													 emu/sdram*/old_* \
													 emu/sdram*/busy* \
													 emu/sdram*/SDRAM_nCAS_reg \
													 emu/sdram*/SDRAM_A_reg[*] \
													 emu/sdram*/SDRAM_BA_reg[*] \
													 emu/sdram*/addr[*][*] \
													 emu/sdram*/din[*][*] \
													 emu/sdram*/rfs* \
													 emu/sdram*/write[*] \
													 emu/sdram*/read[*] }] 23.0

set_max_delay -from   [get_cells { emu/sdram*/last_data* }] 23.0

set_max_delay -from [get_cells { emu/sdram*/* }] 23.0
#set_max_delay		-to   [get_cells { emu/main*/* \
#													 emu/bsram*/* \
#													 emu/wram*/* \
#													 emu/vram*/* \
#													 emu/aram*/* }] 23.0


#set_max_delay -from [get_clocks clkout0] -to [get_clocks clkout2] 23.0
#set_max_delay -from [get_clocks clkout0] -to [get_clocks mclk] -through [get_cells emu/sdram*/*] 23.0
#set_max_delay -from [get_clocks clkout2] -to [get_clocks clkout0] 23.0
#set_max_delay -from [get_clocks mclk] -to [get_clocks clkout0] -through [get_cells emu/sdram*/*] 23.0







################################################################################
# False path constraints

#set_false_path -to [get_cells {emu/sdram*/ds* emu/sdram*/ata*[*]}]
set_false_path -from [get_cells {emu/en216p*}]
set_false_path -from [get_cells {emu/rom_type* emu/rom_mask* emu/ram_mask* emu/PAL* emu/spc_mode*}]
set_false_path -from [get_cells {emu/hps_io*/status_reg*}]
set_false_path -to [get_cells {emu/hps_io*/status_req*}]


#set_false_path -from [get_nets emu/main*/SNES/PPU/FIELD*]
#set_false_path -from [get_nets emu/main*/SNES/PPU/OVERSCAN]
set_false_path -to [get_cells emu/HBLANK_reg]
set_false_path -to [get_cells emu/VBLANK_reg]
set_false_path -to [get_cells emu/HSYNC_reg]
set_false_path -to [get_cells emu/VSYNC_reg]
set_false_path -to [get_cells emu/DOTCLK_reg]
set_false_path -to [get_cells emu/R_reg*]
set_false_path -to [get_cells emu/G_reg*]
set_false_path -to [get_cells emu/B_reg*]
set_false_path -to [get_cells emu/int_interlace_reg]
set_false_path -to [get_cells emu/sdram*/word[*]]
#set_false_path -from [emu/main*/SNES/PPU/VDE*]

set_false_path -to [get_ports LRCK]
set_false_path -to [get_ports SDAT]
set_false_path -to [get_ports BCK]

set_max_delay -from  [get_clocks clkout2] -to [get_clocks clkout2] 23.0
