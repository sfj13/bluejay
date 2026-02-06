@ECHO off
@ECHO ***** Batch file for BlHeli_S (from 4712)  v.2         *****
@ECHO ***** All Messages will be saved to MakeHex_Result.txt *****
@ECHO ***** Start compile with any key  - CTRL-C to abort    *****
Break ON
@pause
DEL MakeHex_Result.txt /Q

rem ***** Adapt settings to your enviroment ****
DEL Output\Hex\*.* /Q
RMDIR Output\Hex
DEL Output\*.* /Q
RMDIR Output
MKDIR Output
MKDIR Output\Hex
SET Revision=REV16_7
SET KeilPath=C:\SiliconLabs\SimplicityStudio\v5\developer\toolchains\keil_8051\9.60\BIN

@ECHO Revision: %Revision% >> MakeHex_Result.txt
@ECHO Path for Keil toolchain: %KeilPath% >> MakeHex_Result.txt
@ECHO Start compile ..... >> MakeHex_Result.txt


SET ESCNO=28
SET ESC=AC_
SET MCU_48MHZ=1
SET FETON_DELAY=90
SET PWM=48
SET ESCNAME=%ESC%%FETON_DELAY%
SET AX51_FLAGS	= NOMOD51 REGISTERBANK(0,1,2) NOLIST NOSYMBOLS

::# Source files
set ASM_SRC = .\src\Bluejay.asm
set SETTINGSDIR = src\Settings\BluejaySettings.asm

call :compile_code

goto :end

:compile_code
@ECHO compiling %ESCNAME%  
@ECHO. >> MakeHex_Result.txt
@ECHO ********************************************************************  >> MakeHex_Result.txt
@ECHO %ESCNAME%  >> MakeHex_Result.txt
::%KeilPath%\AX51.exe "BLHeli_S.asm" DEFINE(ESCNO=%ESCNO%) DEFINE(MCU_48MHZ=%MCU_48MHZ%) DEFINE(FETON_DELAY=%FETON_DELAY%) OBJECT(Output\%ESCNAME%_%Revision%.OBJ) %DEBUG MACRO NOMOD51 COND SYMBOLS PAGEWIDTH(120) PAGELENGTH(65)% >> MakeHex_Result.txt
%KeilPath%\AX51.exe %ASM_SRC% INCDIR(%SETTINGSDIR%) DEFINE(ESCNO=%ESCNO%) DEFINE(MCU_TYPE=%MCU_48MHZ%) DEFINE(DEADTIME=%FETON_DELAY%) DEFINE(PWM_FREQ=%PWM%) OBJECT(Output\%ESCNAME%_%Revision%.OBJ) %AX51_FLAGS% >> MakeHex_Result.txt

::%KeilPath%\LX51.exe "Output\%ESCNAME%_%Revision%.OBJ" TO "Output\%ESCNAME%_%Revision%.OMF" PAGEWIDTH (120) PAGELENGTH (65) >> MakeHex_Result.txt
%KeilPath%\LX51.exe "Output\%ESCNAME%_%Revision%.OBJ" TO "Output\%ESCNAME%_%Revision%.OMF" PAGEWIDTH (120) PAGELENGTH (65) >> MakeHex_Result.txt
%KeilPath%\Ohx51 "Output\%ESCNAME%_%Revision%.OMF" "HEXFILE (Output\%ESCNAME%_%Revision%.HEX)" "H386" >> MakeHex_Result.txt
copy "Output\%ESCNAME%_%Revision%.HEX" "Output\Hex\%ESCNAME%_%Revision%.HEX" > nul
del "Output\%ESCNAME%_%Revision%.HEX" > nul
@ECHO. >> MakeHex_Result.txt
goto :eof

:end

@pause
::exit
