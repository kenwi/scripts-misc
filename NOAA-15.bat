for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set datetime=%%I
set datetime=%datetime:~0,8%-%datetime:~8,6%

"C:\Program Files\PothosSDR\bin\rtl_power.exe" -e 20m -d 1 -i 1 -f 137585000:137655000:4 -g 5 c:\users\wilken\desktop\data\NOAA-15-%datetime%.csv