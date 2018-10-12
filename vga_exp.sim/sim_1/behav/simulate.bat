@echo off
set xv_path=D:\\vivado\\Vivado\\2017.2\\bin
call %xv_path%/xsim vga_tb_behav -key {Behavioral:sim_1:Functional:vga_tb} -tclbatch vga_tb.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
