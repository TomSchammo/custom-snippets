local function get_shared_snippets()
    local current_file = debug.getinfo(1, "S").source:sub(2) -- Remove @ prefix
    local current_dir = current_file:match("(.*/)")
    local shared_file = current_dir .. "_shared.lua"
    local shared_chunk = loadfile(shared_file)
    if shared_chunk then
        return shared_chunk()
    else
        error("Failed to load shared snippets from: " .. shared_file)
    end
end

return get_shared_snippets()

