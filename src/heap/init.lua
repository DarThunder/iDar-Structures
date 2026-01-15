local binary_heap = require("iDar.Structures.src.heap.binary_heap")

return {
    new_min = function(list, comp_func)
        return binary_heap(list, type(comp_func) == "function" and comp_func or function(a, b) return a < b end)
    end,
    new_max = function(list, comp_func)
        return binary_heap(list, type(comp_func) == "function" and comp_func or function(a, b) return a > b end)
    end
}