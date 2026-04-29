local ls = require("luasnip")
local f = ls.function_node
local postfix = require("luasnip.extras.postfix").postfix

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

local function parse_fmt_string(match)
    local vars = {}
    local fmt_str = match:gsub("{([^}]+)}", function(v)
        table.insert(vars, v)
        return "{}"
    end)
    return fmt_str, vars
end

local fmt_snippet = postfix(
    { trig = ".fmt", match_pattern = [["[^"]*"]] },
    {
        f(function(_, parent)
            local match = parent.snippet.env.POSTFIX_MATCH
            local fmt_str, vars = parse_fmt_string(match)
            return string.format("std::format(%s, %s);", fmt_str, table.concat(vars, ", "))
        end, {})
    }
)

local print_snippet = postfix(
    { trig = ".print", match_pattern = [["[^"]*"]] },
    {
        f(function(_, parent)
            local match = parent.snippet.env.POSTFIX_MATCH
            local fmt_str, vars = parse_fmt_string(match)
            if #vars == 0 then
                return string.format("std::println(%s);", match)
            end
            return string.format("std::println(%s, %s);", fmt_str, table.concat(vars, ", "))
        end, {})
    }
)

local shared = get_shared_snippets()
vim.list_extend(shared, { fmt_snippet, print_snippet })
return shared
