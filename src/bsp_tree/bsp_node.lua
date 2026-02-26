local bsp_node = {}
bsp_node.__index = bsp_node

function bsp_node.new(value)
    local self = {
        type = "leaf",
        value = value,
        left = nil,
        right = nil,
        split_direction = nil,
        split_ratio = nil,
        parent = nil
    }
    return setmetatable(self, bsp_node)
end

function bsp_node:is_leaf()
    return self.type == "leaf"
end

function bsp_node:split(direction, new_value, ratio)
    if not self:is_leaf() then
        return false, "The node is already divided"
    end

    local left_child = bsp_node.new(self.value)
    left_child.parent = self

    local right_child = bsp_node.new(new_value)
    right_child.parent = self

    self.type = "split"
    self.split_direction = direction or "vertical"
    self.split_ratio = ratio or 0.5
    self.value = nil
    self.left = left_child
    self.right = right_child

    return true
end

function bsp_node:leaves()
    return coroutine.wrap(function()
        local function traverse(node)
            if not node then return end
            if node:is_leaf() then
                coroutine.yield(node)
            else
                traverse(node.left)
                traverse(node.right)
            end
        end
        traverse(self)
    end)
end

return bsp_node