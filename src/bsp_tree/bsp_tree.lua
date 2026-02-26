local bsp_node = require("..iDar.Structures.src.bsp_tree.bsp_node")

local bsp_tree = {}
bsp_tree.__index = bsp_tree

function bsp_tree.new(initial_value)
    local self = {
        root = bsp_node.new(initial_value)
    }
    return setmetatable(self, bsp_tree)
end

return {
    new = function(initial_value) return bsp_tree.new(initial_value) end
}