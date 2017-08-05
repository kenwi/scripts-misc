@echo off
for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set datetime=%%I

set binary="%SOAPY_SDR_ROOT%\bin\rtl_power.exe"
set datetime=%datetime:~0,8%-%datetime:~8,6%
set deviceid=1
set gain=5
set integrationtime=10
set label=Scan
set frequency=25M:900M:50k

%binary% -d %deviceid% -i %integrationtime% -f %frequency% -g %gain% %label%-%datetime%.csv
