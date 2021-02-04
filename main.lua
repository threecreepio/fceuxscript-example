require('./smb1')
require('./utils')
local arg = io.stdin:read()
print(arg)
local log = io.stdout
local start = savestate.object()

inputs = load_tas_file("main.tas")

-- initialize smb1 random number generator
local seed = prng_init()

-- power cycle the nes and set max speed
emu.poweron()
emu.speedmode('turbo')

-- advance to the correct spot in the tas file
for i=1,1104,1 do
    joypad.set(1, inputs[emu.framecount()] or {})
    emu.frameadvance()
end

-- make a savestate
savestate.save(start)
for rng=0,0x7FFE,1 do
    log:write(string.format("\n%d", rng))
    log:flush()
    -- reload
    savestate.load(start)
    -- advance rng counter 1 step
    seed = prng_advance(seed)
    prng_apply(seed)

    -- run a few frames of the tas
    for i=1,240,1 do
        joypad.set(1, inputs[emu.framecount()] or {})
        emu.frameadvance()
    end

    -- and log if we died or not to stdout
    if memory.readbyte(GameEngineSubroutine) == 0xB then
        log:write(",dead")
    else
        log:write(",alive")
    end
end

-- shut down the emulator to end!
emu.exit()
