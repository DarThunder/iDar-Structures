local b_tree_node = {}
b_tree_node.__index = b_tree_node

function b_tree_node.new(values, children)
    local self = {
        values = values or {},
        children = children or {}
    }
    return setmetatable(self, b_tree_node)
end

function b_tree_node:is_leaf()
    return #self.children == 0
end

function b_tree_node:get_size()
    return #self.values
end

function b_tree_node:insert_value(value, compare)
    if #self.values == 0 then
        self.values[1] = value
        return
    end
    for i = #self.values, 1, -1 do
        if compare(self.values[i], value) then
            table.insert(self.values, i + 1, value)
            return
        end
    end
    table.insert(self.values, 1, value)
end

function b_tree_node:remove_value_at(index)
    table.remove(self.values, index)
end

function b_tree_node:split()
    local total = #self.values
    local middle_index = math.floor(total / 2) + 1
    local promoted = self.values[middle_index]

    local left_values = {}
    local right_values = {}

    for i = 1, total do
        if i < middle_index then
            left_values[#left_values + 1] = self.values[i]
        elseif i > middle_index then
            right_values[#right_values + 1] = self.values[i]
        end
    end

    local left_children = {}
    local right_children = {}

    if not self:is_leaf() then
        for i = 1, #self.children do
            if i <= middle_index then
                left_children[#left_children + 1] = self.children[i]
            else
                right_children[#right_children + 1] = self.children[i]
            end
        end
    end

    local left_node = b_tree_node.new(left_values, left_children)
    local right_node = b_tree_node.new(right_values, right_children)
    return left_node, promoted, right_node
end

function b_tree_node:get_child_index(value, compare)
    for i = 1, #self.values do
        if compare(value, self.values[i]) then
            return i
        end
    end
    return #self.values + 1
end

return function(values, children)
    return b_tree_node.new(values, children)
end