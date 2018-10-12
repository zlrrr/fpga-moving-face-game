onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+die_rom -L xil_defaultlib -L xpm -L blk_mem_gen_v8_3_6 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.die_rom xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {die_rom.udo}

run -all

endsim

quit -force
