const childproc = require('child_process');
const path = require('path');
const fs = require('fs');
if (!fs.existsSync('out')) fs.mkdirSync('out');

const fceuPath = '/mnt/c/games/emu/fceux/fceux.exe';
const romPath = '..\\pellsson.nes';
const instances = 18;

const args = [0];

async function runNext() {
    while (1) {
        if (args.length === 0) return;
        const arg = args.shift();
        const csvPath = path.join(__dirname, 'out', arg + '.csv');
        // if (fs.existsSync(csvPath)) continue;
        console.log(`starting ${arg}`);

        const proc = childproc.spawn(fceuPath, ["-lua", "main.lua", romPath], {
            cwd: __dirname,
            stdio: 'pipe'
        });

        const f = fs.createWriteStream(csvPath);
        proc.stdin.write(String(arg) + "\r\n");
        proc.stdout.pipe(f);
        proc.stderr.pipe(process.stderr);

        await new Promise(r => proc.on('exit', r));
        try { f.close(); } catch(ex) {}
    }
}

for (let i=0; i<instances; ++i) {
    runNext();
}

