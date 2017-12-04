@echo off
COLOR 1F
rem 
rem  This is a MS-Windows batch file for assembling and linking assembly language 
rem  source files. It is designed to be used with the book entitled Assembly 
rem  Language for Intel-Based Computers, 5th edition, by Kip Irvine. The 
rem  configuration used here assumes that you are using MASM Version 8. This 
rem  file has been tested under Windows XP Professional and Windows 2000. 
rem  There is no reason to suggest that it would not work under Windows Vista.
rem  Copyright Kip Irvine, 2007. You may freely use and modify this file 
rem  as long as you do not remove the names of its authors.
rem                                                                    
rem  Copy this file to a location on your system path. Suggested       
rem  locations are c:\Windows or c:\WINNT                              
rem                                                                    
rem  Customization: 
rem  -----------------------------------------------------------------
rem  If Visual Studio is installed in some other directory than 
rem  C:\Program Files\Microsoft Visual Studio 8, you must modify the 
rem  SET VSHOME statement (near line 131 in this file).                                                    
rem                                                                    
rem  Syntax for running this file:                                     
rem  ------------------------------------------------------------------
rem     asm32                 -  display help                             
rem     asm32 [/H|/h|-H|-h]   -  display help                             
rem     asm32 filelist        -  assemble and link                        
rem     asm32 /D filelist     -  assemble, link, and debug                
rem     asm32 /C filelist     -  assemble only                            
rem                                                                    
rem  A filelist is a list of up to 5 filenames, separated by spaces.   
rem  The filenames must not have extensions, because .asm is assumed.
rem  The first filename determines the name of the exe file produced 
rem  by the linker.
rem   
rem  Examples:
rem  -----------------------------------------------------------------
rem  Display help information (5 ways to do this):
rem     asm32
rem     asm32 /H
rem     asm32 /h
rem     asm32 -H
rem     asm32 -h
rem
rem  Assemble and link myprog.asm, producing myprog.obj and myprog.exe:
rem     asm32 myprog
rem 
rem  Assemble main.asm, producing main.obj:
rem     asm32 /C main
rem
rem  Assemble main.asm, print.asm, and sum.asm. Then link all three,
rem  producing main.exe:
rem     asm32 main print sum
rem
rem  Assemble main.asm, print.asm, and sum.asm. Then link all three,
rem  producing main.exe. Then start main.exe in the debugger:
rem     asm32 /D main print sum
rem
rem  Credits:
rem  -------------------------------------------------------------------
rem  This batch file was the result of a collaboration between the     
rem  following individuals:                                            
rem  (1) Kip Irvine, http://asmirvine.com, mailto:kip@asmirvine.com                                           
rem  (2) John I. Moore, Jr., Department of Mathematics and Computer    
rem     Science, The Citadel, http://mathcs.citadel.edu                   
rem  (3) Gerald Cahill, Antelope Valley College                        
rem  (4) James Brink, Pacific Lutheran University                      
rem                                                                    
rem  Update History: 
rem  -------------------------------------------------------------------
rem   02/23/2007: created by Kip Irvine and John Moore                    
rem   02/23/2007: revised to display help if no arguments are given       
rem   02/24/2007: debugging /D switch enabled                             
rem   02/25/2007: linking /L switch removed, /C switch added              
rem   02/25/2007: permits up to 5 source files to be assembled            
rem   02/28/2007: when setting INCLUDE, LIB, and PATH commands, existing  
rem               values values are appended to our settings. Additional   
rem               command line switches added for displaying help.        
rem   03/04/2007: Created a loop to permit the linker to link multiple 
rem               obj files. Examples added to remarks section.
rem   25/06/2010: Make portable for fun, by Carlos Vásquez Espino
rem               run in any media (usb, cd, dvd), in "\Irvine" directory.
rem   03/02/2011: By Carlos Vásquez Espino
rem               run in any media (usb, cd, dvd) and any directory.
rem  --------------------------------------------------------------------

rem -------------------- BEGIN ACTIVE COMMANDS -----------------------
 
rem The SETLOCAL command makes all subsequent settings of environment 
rem settings local to this batch file. The settings will disappear when 
rem the batch file reaches the ENDLOCAL command.
SETLOCAL

rem Check for the /H (help) command
 
if "%1"=="" goto HELP
if %1==/H   goto HELP
if %1==/h   goto HELP
if %1==-H   goto HELP
if %1==-h   goto HELP

rem -----------------------------------------------------------------
rem             CHECK COMMAND-LINE SWITCHES
rem -----------------------------------------------------------------
rem  If the first argument is /C, disable LINKING and shift the 
rem  remaining arguments backward one position.
rem -----------------------------------------------------------------

set LINKING=yes
if %1 NEQ /C goto CHECK_DEBUG_SWITCH
shift
set LINKING=no

:CHECK_DEBUG_SWITCH
rem -----------------------------------------------------------------
rem  If the first argument is /D, enable the DEBUG option 
rem  and shift the remaining arguments backward one position.
rem -----------------------------------------------------------------

set DEBUG=no
if %1 NEQ /D goto DELETE_FILES
shift
set DEBUG=yes

:DELETE_FILES
rem ----------------------------------
rem Delete the old object file
rem ----------------------------------
if exist %1.obj del %1.obj

rem -----------------------------------------------------------------
rem      Ubica la ruta desde donde se esta ejecutando el batch
rem         By: Carlos Edgardo Vásquez Espino, El Salvador   
rem -----------------------------------------------------------------
SET DRIVE=#
IF EXIST "%cd%\Irvine32.inc" SET DRIVE=%cd%
If "%DRIVE%"=="#" goto WARNING

rem -----------------------------------------------------------------
rem             PREPARE THE ENVIRONMENT VARIABLES
rem 
rem  Set the VS_HOME environment variable to the location of Visual 
rem  Studio 2005 (or Visual C++ 2005 Express)
rem -----------------------------------------------------------------
set VS_HOME=%DRIVE%\Microsoft Visual Studio 8

rem -----------------------------------------------------------------
rem Add Visual Studio 2005 to the system path.
rem -----------------------------------------------------------------
set PATH=%VS_HOME%\VC\bin;%VS_HOME%\Common7\IDE;%PATH%

rem -----------------------------------------------------------------
rem  Set the INCLUDE environment variable to the location of the 
rem  MASM include files used by Irvine's book.
rem -----------------------------------------------------------------
set INCLUDE=%DRIVE%\;%INCLUDE%

rem -----------------------------------------------------------------
rem  Set the LIB environment variable to the location of the 
rem  Link libraries used by Irvine's book.
rem -----------------------------------------------------------------
set LIB=%VS_HOME%\VC\LIB;%DRIVE%\;%LIB%

rem -----------------------------------------------------------------
rem                   EXECUTE THE ASSEMBLER
rem Parameters:
rem  -nologo           suppress the Microsoft logo
rem  -c                assemble only
rem  -Zi               generate debugging information
rem  %%F               source filename, held in loop variable
rem -----------------------------------------------------------------

for %%F in (%1 %2 %3 %4 %5) do ml -nologo -c -Zi %%F.asm

if errorlevel 1 goto QUIT
rem (the preceding IF statement only affects the last source file to be assembled)

rem ---------------------------------
rem Find out if linking is disabled
rem ---------------------------------
if %LINKING%==no goto QUIT

rem -----------------------------------------------------------------------------------------
rem                   EXECUTE THE LINKER
rem Parameters:
rem   /NOLOGO                                   (suppress the Microsoft logo display)
rem   /DEBUG                                    (include debugging information)
rem   /SUBSYSTEM:CONSOLE                        (generate a Windows Console-aware application)
rem   irvine32.lib, kernel32.lib, user32.lib    (link libraries)
rem   %1                                        (EXE filename produced by the linker)
rem ------------------------------------------------------------------------------------------

echo.
echo Linking Assembler output files to the Irvine32, Kernel32, and User32 libraries.

SET LINKCMD=link /NOLOGO /DEBUG /SUBSYSTEM:CONSOLE irvine32.lib kernel32.lib user32.lib
SET FILELIST=%1.obj
SET EXENAME=%1.exe

:LINKLOOP
if !%2==! goto ENDLINKLOOP
SET FILELIST=%FILELIST% %2.obj
shift
goto LINKLOOP

:ENDLINKLOOP

rem -------------------------------------------------------------------
rem Execute the linker, using the command line and list of input files.
rem -------------------------------------------------------------------
%LINKCMD% %FILELIST%

if errorlevel 1 goto QUIT

echo.
echo Linker successful. The executable file %EXENAME% was produced.
echo ..................................
echo.

rem Find out if debugging was disabled

if %DEBUG%==no goto QUIT

rem -----------------------------------------------------------------
rem              LAUNCH THE VISUAL STUDIO DEBUGGER
rem -----------------------------------------------------------------

echo Launching the Visual Studio 2005 debugger...

devenv %1.exe /debugexe

goto QUIT


rem -----------------------------------------------------------------
rem                    SHOW HELP INFORMATION
rem -----------------------------------------------------------------
:HELP
cls
echo This file assembles, links, and debugs a single assembly language 
echo source file. Before using it, install Visual Studio 2005 in the following 
echo directory: C:\Program Files\Microsoft Visual Studio 8
echo.
echo Next, install the Irvine 5th edition link libraires and include files 
echo in the following directory: C:\Irvine
echo.
echo Finally, copy this batch file to a location on your system path. We recommend 
echo the following directory: C:\Program Files\Microsoft Visual Studio 8\VC\bin
echo.
echo Command-line syntax:
echo.
echo    asm32 [/H ^| /h ^| -H ^| -h]     -- display this help information
echo    asm32 filelist                -- assemble and link all files
echo    asm32 /D filelist             -- assemble, link, and debug
echo    asm32 /C filelist             -- assemble only
echo.
echo ^<filelist^> is a list of up to 5 filenames (without extensions), 
echo separated by spaces. The filenames are assumed to refer to files
echo having .asm extensions. Command-line switches are case-sensitive.
goto QUIT

rem -----------------------------------------------------------------
rem                    SHOW WARNING INFORMATION
rem -----------------------------------------------------------------
:WARNING
cls
COLOR 4F
echo.
echo -----------------------------------------------------------------
echo                        WARNING INFORMATION
echo -----------------------------------------------------------------
echo.
echo Debe copiar el Irvine completo dentro de "<UNIDAD>:\<DIRECTORIO>\" 
echo Antes de poder usarlo.
echo.
echo Esta version se puede descomprimir en cualquier unidad y en 
echo cualquier directorio.
echo.
echo AVISO: La ruta maxima no debe exceder mas de 255 caracteres.
echo.
echo.
echo You must copy this into "<DRIVE>:\<DIRECTORY>\" directory
echo Before using it.
echo.
echo.
echo Unrar directly to any directory.
echo.
echo.
pause
goto QUIT

rem -----------------------------------------------------------------
rem                   BATCH FILE EXIT POINT
rem -----------------------------------------------------------------
:QUIT

rem ENDLOCAL clears all local environment variable settings.
ENDLOCAL

Rem Eliminar Archivos Temporales de Compilacion
If Exist %1.ilk Del %1.ilk
If Exist %1.obj Del %1.obj
If Exist %1.pdb Del %1.pdb
COLOR 0A

