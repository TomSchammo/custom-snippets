local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
-- local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
local d = ls.dynamic_node
-- local r = ls.restore_node
-- local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
-- local p = require("luasnip.extras").partial
-- local m = require("luasnip.extras").match
-- local n = require("luasnip.extras").nonempty
-- local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta
-- local types = require("luasnip.util.types")
-- local conds = require("luasnip.extras.conditions")
-- local conds_expand = require("luasnip.extras.conditions.expand")

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

-- C++

ls.add_snippets("cpp", {
    header_guard_snippet,
})

-- C

ls.add_snippets("c", {
    header_guard_snippet,
})
