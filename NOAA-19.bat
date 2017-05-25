for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set datetime=%%I
set datetime=%datetime:~0,8%-%datetime:~8,6%

"C:\Program Files\PothosSDR\bin\rtl_power.exe" -e 20m -d 1 -i 1 -g 5 -f 137065000:137135000:4 c:\users\wilken\desktop\data\NOAA-19-%datetime%.csv