
#create_generated_clock -name GSU_CACHE_CLK -source [get_pins -compatibility_mode {*|pll|pll_inst|altera_pll_i|*[2].*|divclk}] \
#							  -invert [get_pins {emu|main|GSUMap|GSU|CACHE|altsyncram_component|auto_generated|*|clk0}]

#create_generated_clock -name CX4_MEM_CLK -source [get_pins -compatibility_mode {*|pll|pll_inst|altera_pll_i|*[2].*|divclk}] \
#							  -invert [get_pins {emu|main|CX4Map|CX4|DATA_RAM|altsyncram_component|auto_generated|*|clk0 \
#														emu|main|CX4Map|CX4|DATA_ROM|spram_sz|altsyncram_component|auto_generated|altsyncram1|*|clk0 }]


################################################################################
# Multi-cycle path constraints

#set_multicycle_path -from [get_cells EMU_i/main*/SNES/CPU/P65C816/*] to [get_cells EMU_i/main*/SNES/CPU/P65C816/*] 6
#set_multicycle_path -through [get_cells EMU_i/main*/SNES/SMP/*] -to [get_cells EMU_i/main*/SNES/SMP/*] 6
#set_multicycle_path -through [get_cells EMU_i/main*/SNES/DSP/*] -to [get_cells EMU_i/main*/SNES/DSP/*] 6

#set_multicycle_path -from {EMU_inst/sdram_i/*} -to [get_clocks {*/pll_i/outclk_2] -start -setup 2
#set_multicycle_path -rise_from [get_cells {EMU_i/sdram*/*}] -rise_to [get_pins EMU_i/pll_i/outclk_2] 2
#set_multicycle_path -from {EMU_inst/sdram_i/*} -to [get_clocks {*/pll_i/outclk_2] -start -hold 1
#set_multicycle_path -fall_from [get_cells {EMU_i/sdram_i*}] -fall_to [get_pins EMU_i/pll_i/outclk_2] 1

#set_multicycle_path -from [get_clocks {*/pll_i/outclk_2] -to {EMU_inst/sdram_i/*} -setup 2
#set_multicycle_path -rise_from [get_pins EMU_i/pll_i/outclk_2] -rise_to [get_cells {EMU_i/sdram_i*}] 2
#set_multicycle_path -from [get_clocks {*/pll_i/outclk_2] -to {EMU_inst/sdram_i/*} -hold 1
#set_multicycle_path -fall_from [get_pins EMU_i/pll_i/outclk_2] -fall_to [get_cells {EMU_i/sdram_i*}] 1

set_clock_groups -asynchronous -group [get_clocks { GSU_CACHE_CLK CX4_MEM_CLK }] 


################################################################################
# Max delay constraints

set_max_delay -from [get_cells { EMU_i/hps_io*/* \
													 EMU_i/main*/* }] 23.0
set_max_delay -to   [get_cells { EMU_i/sdram*/a[*] \
													 EMU_i/sdram*/ram_req* \
													 EMU_i/sdram*/we* \
													 EMU_i/sdram*/state_reg[*] \
													 EMU_i/sdram*/old_* \
													 EMU_i/sdram*/busy* \
													 EMU_i/sdram*/SDRAM_nCAS_reg \
													 EMU_i/sdram*/SDRAM_A_reg[*] \
													 EMU_i/sdram*/SDRAM_BA_reg[*] }] 23.0

set_max_delay -from [get_cells { EMU_i/sdram*/* }] \
set_max_delay -to   [get_cells { EMU_i/main*/* \
													 EMU_i/BSRAM*/* \
													 EMU_i/WRAM*/* \
													 EMU_i/VRAM*/* }] 23.0

################################################################################
# False path constraints

set_false_path -to [get_cells {EMU_i/sdram*/ds* EMU_i/sdram*/ata*[*]}]
set_false_path -from [get_cells {EMU_i/en216p*}]
set_false_path -from [get_cells {EMU_i/rom_type* EMU_i/rom_mask* EMU_i/ram_mask* EMU_i/PAL* EMU_i/spc_mode*}]

