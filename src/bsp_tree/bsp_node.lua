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

function bsp_node:get_geometry()
    if self:is_leaf() then
        return self.value
    end

    local parent_geom = self.parent and self.parent:get_geometry() or self.value
    if not parent_geom then return nil end

    local ratio = self.split_ratio or 0.5
    local gx, gy, gw, gh = parent_geom.x, parent_geom.y, parent_geom.w, parent_geom.h

    if self.split_direction == "horizontal" then
        local split_h = math.floor(gh * ratio)
        if self == self.parent.left then
            return {x = gx, y = gy, w = gw, h = split_h}
        else
            return {x = gx, y = gy + split_h, w = gw, h = gh - split_h}
        end
    else
        local split_w = math.floor(gw * ratio)
        if self == self.parent.left then
            return {x = gx, y = gy, w = split_w, h = gh}
        else
            return {x = gx + split_w, y = gy, w = gw - split_w, h = gh}
        end
    end
end

return bsp_node