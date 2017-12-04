@echo off
REM make16.bat
REM Created 06/01/2006
REM By: Kip R. Irvine

REM Assembles and links the current 16-bit ASM program.
REM Assumes you have installed Microsoft Visual Studio 2005,
REM or Visual C++ 2005 Express.
REM 
REM Command-line options (unless otherwise noted, they are case-sensitive):
REM 
REM -Cp         Enforce case-sensitivity for all identifiers
REM -Zi		Include source code line information for debugging
REM -Fl		Generate a listing file (see page 88)
REM /CODEVIEW   Generate CodeView debugging information (linker)
REM %1.asm      The name of the source file, passed on the command line
rem
rem  Update History: 
rem  -------------------------------------------------------------------
rem  25/06/2010: revised to display help if no arguments are given       
rem  25/06/2010: Make portable for fun, by Carlos Vásquez Espino
rem              run in any media (usb, cd, dvd), make you sure to unrar
rem              directly to "\Irvine" directory.
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
rem      Ubica la ruta desde donde se esta ejecutando el batch
rem         By: Carlos Edgardo Vásquez Espino, El Salvador   
rem -----------------------------------------------------------------
SET DRIVE=#
rem FOR %%i IN (A B C D E F G H I J K L M N O P Q R S T U V W X Y Z) DO IF EXIST %%i:\Irvine\Irvine16.inc SET DRIVE=%%i:
SET DRIVE=%cd%\
If "%DRIVE%"=="#" goto WARNING

REM ************* The following lines can be customized:
rem SET MASM="E:\Irvine\Microsoft Visual Studio 8\VC\bin\"
rem SET INCLUDE=E:\Irvine
rem SET LIB=E:\Irvine
SET MASM=%DRIVE%\Irvine\Microsoft Visual Studio 8\VC\bin\
SET INCLUDE=%DRIVE%\Irvine
SET LIB=%DRIVE%\Irvine
REM **************************** End of customized lines

REM Invoke ML.EXE (the assembler):

%MASM%ML /nologo -c -omf -Fl -Zi %1.asm
if errorlevel 1 goto terminate

REM Run the 16-bit linker, modified for Visual Studio.Net:

rem E:\Irvine\LINK16 %1,,NUL,Irvine16 /CODEVIEW;
%DRIVE%\Irvine\LINK16 %1,,NUL,Irvine16 /CODEVIEW;

if errorlevel 1 goto terminate

REM Display all files related to this program:
DIR %1.*
goto terminate


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
echo Assembles and links the current 16-bit ASM program.
echo Assumes you have installed Microsoft Visual Studio 2005,
echo or Visual C++ 2005 Express.
echo. 
echo Command-line options (unless otherwise noted, they are case-sensitive):
echo. 
echo    make16 [/H ^| /h ^| -H ^| -h]  -- display this help information
echo    make16 -Cp                  -- Enforce case-sensitivity for all identifiers
echo    make16 -Zi                  -- Include source code line information for debugging
echo    make16 -Fl                  -- Generate a listing file (see page 88)
echo    make16 /CODEVIEW            -- Generate CodeView debugging information (linker)
echo    make16 filelist             -- The name of the source file, passed on the command line
echo.
echo ^<filelist^> is a filename (without extensions), 
echo The filenames are assumed to refer to files having .asm extensions.
echo Command-line switches are case-sensitive.
goto terminate

rem -----------------------------------------------------------------
rem                    SHOW WARNING INFORMATION
rem -----------------------------------------------------------------
:WARNING
cls
echo.
echo You must copy this into "<DRIVE>:\Irvine" directory
echo Before using it.
echo.
echo Unrar directly to irvine directory.
echo.
goto terminate


:terminate

rem ENDLOCAL clears all local environment variable settings.
ENDLOCAL

pause
