@echo off

set DIR=%~dp0

echo %QUICK_V3_ROOT%
set COCOS_SCRIPT_PATH=%QUICK_V3_ROOT%\cocos\scripting\lua-bindings\script
set QUICK_FRAME_PATH=%QUICK_V3_ROOT%\quick
set QUICK_COCOSFRAME_PATH=%QUICK_FRAME_PATH%\cocos
set COPY_CMD=xcopy /s /i %COCOS_SCRIPT_PATH% %QUICK_COCOSFRAME_PATH%
if not exist %QUICK_COCOSFRAME_PATH% %COPY_CMD%

set BIN=%QUICK_V3_ROOT%\tools\simulator\runtime/win32/simulator.exe
if not exist %BIN% echo "PLEASE BUILD %QUICK_V3_ROOT%\tools\simulator\frameworks\runtime-src\proj.win32/simulator.sln FIRST"

set ARG=-workdir %DIR% -search-path %QUICK_FRAME_PATH%

%BIN% %ARG%

echo ""
echo "------------------------------------------------------"
