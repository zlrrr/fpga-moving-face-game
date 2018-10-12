onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib die_rom_opt

do {wave.do}

view wave
view structure
view signals

do {die_rom.udo}

run -all

quit -force
