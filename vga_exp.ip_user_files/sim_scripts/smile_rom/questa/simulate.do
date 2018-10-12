onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib smile_rom_opt

do {wave.do}

view wave
view structure
view signals

do {smile_rom.udo}

run -all

quit -force
