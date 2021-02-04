function load_tas_file(filename)
    local f = io.open(filename,'r')
    if f == nil then
        print(string.format("could not open file %s.", filename))
    end
    f:read()
    result = {}
    for i=0,1000000,1 do
        line = f:read()
        if line == nil then
            break
        end
        local inp = {}
        for c in line:gmatch(".") do
            if c == "A" then
                inp["A"] = true
            end
            if c == "B" then
                inp["B"] = true
            end
            if c == "S" then
                inp["select"] = true
            end
            if c == "T" then
                inp["start"] = true
            end
            if c == "U" then
                inp["up"] = true
            end
            if c == "D" then
                inp["down"] = true
            end
            if c == "L" then
                inp["left"] = true
            end
            if c == "R" then
                inp["right"] = true
            end
        end
        result[i] = inp
    end
    result["filename"] = filename
    return result
end
