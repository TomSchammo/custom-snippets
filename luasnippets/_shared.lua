local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local i = ls.insert_node
local d = ls.dynamic_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

local guard_name = function(_, parent)
    local filename = parent.env.TM_FILENAME
    local header_name = filename:upper():gsub("%.", "_")
    return sn(nil, { i(1, header_name) })
end

local header_guard_snippet = s(
    "header_guard",
    fmt(
        [[
            #ifndef {}
            #define {}

            {}

            #endif // {}
        ]],
        { d(1, guard_name), rep(1), i(0), rep(1) }
    )
)

return {
    header_guard_snippet,
}

