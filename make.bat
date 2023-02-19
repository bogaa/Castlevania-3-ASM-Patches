@echo off
rem -- Settings ----------------------------

rem pause when done
rem (note: errors will always pause)
set dopause=0

set script=make.py

rem ----------------------------------------

rem default error
set errormessage=unspecified error

rem run this to fill the pycmd environment variable
call findpython.bat 1
if %errorlevel% NEQ 0 goto error

%pycmd% %script%
if %errorlevel% NEQ 0 set errormessage=script error&goto error

goto success

:error
echo.
echo.ERROR: %errormessage%
echo.
pause
goto theend

:success
if %dopause% NEQ 0 pause


:theend
rem timeout 2
pause 