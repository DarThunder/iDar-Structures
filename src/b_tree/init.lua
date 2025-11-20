local b_tree = require("idar-st.b_tree.b_tree")

return {
    new_ascending = function(max_keys, comp_func)
        return b_tree(type(comp_func) == "function" or function(a, b) return a < b end, max_keys)
    end,
    new_descending = function(max_keys, comp_func)
        return b_tree(type(comp_func) == "function" or function(a, b) return a > b end,max_keys)
    end
}