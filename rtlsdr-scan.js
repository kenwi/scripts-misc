
const spawn = require('child_process').spawn;
console.log(":: Starting scan");
var cp = spawn(process.env.comspec, [
    '/c', 
    'C:\\Users\\kenwi\\sdr\\x64\\rtl_power.exe', 
    '-f 88M:300M:10k', 
    '-i 10s',
    '-e 1m', 
    'C:\\Users\\kenwi\\sdr\\output.csv'
]);

cp.stdout.on('data', function (data) {
    console.log(data);
});

cp.stderr.on('data', function (data) {
    console.error(data.toString());
});

cp.on('close', function (data) {
    console.log(":: Generating image");
    var heatmap = spawn(process.env.comspec, [
        '/c',
        'C:\\python27\\python.exe',
        'C:\\Users\\kenwi\\sdr\\x64\\heatmap.py',
        'C:\\Users\\kenwi\\sdr\\output.jpg'
    ]);
    
    heatmap.stdout.on('data', function (data) {
        console.log(data);
    });

    heatmap.on('close', function (data) {
        console.log(':: Finished');
    });
});

