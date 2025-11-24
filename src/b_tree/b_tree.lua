local b_tree_node = require("..iDar.Structures.src.b_tree.b_tree_node")

local b_tree = {}
b_tree.__index = b_tree

function b_tree.new(compare, max_keys)
    assert(type(compare) == "function", "compare function required")
    local self = {
        compare = compare,
        max_keys = max_keys or 5,
        root = b_tree_node({}, {})
    }
    return setmetatable(self, b_tree)
end

local function split_child(parent, child_index)
    local child = parent.children[child_index]
    local left_node, promoted, right_node = child:split()

    table.insert(parent.values, child_index, promoted)
    parent.children[child_index] = left_node
    table.insert(parent.children, child_index + 1, right_node)
end

local function insert_in_node(self, node, value)
    if node:is_leaf() then
        node:insert_value(value, self.compare)
        return
    end

    local child_index = node:get_child_index(value, self.compare)
    local child = node.children[child_index]
    insert_in_node(self, child, value)

    if #child.values > self.max_keys then
        split_child(node, child_index)
    end
end

function b_tree:insert(value)
    insert_in_node(self, self.root, value)
    if #self.root.values > self.max_keys then
        local left_node, promoted, right_node = self.root:split()
        self.root = b_tree_node({promoted}, {left_node, right_node})
    end
end

local function get_predecessor(node)
    while not node:is_leaf() do
        node = node.children[#node.children]
    end
    return node.values[#node.values]
end

local function get_sucessor(node)
    while not node:is_leaf() do
        node = node.children[1]
    end
    return node.values[1]
end

local function merge_children(parent, index)
    local child = parent.children[index]
    local sibling = parent.children[index + 1]
    child.values[#child.values + 1] = parent.values[index]

    for _, r in ipairs(sibling.values) do
        child.values[#child.values + 1] = r
    end
    for _, c in ipairs(sibling.children or {}) do
        child.children[#child.children + 1] = c
    end

    table.remove(parent.values, index)
    table.remove(parent.children, index + 1)
end

local function fix_child(self, parent, index)
    local t = math.floor(self.max_keys / 2) + 1
    local child = parent.children[index]

    local left = parent.children[index - 1]
    local right = parent.children[index + 1]

    if left and #left.values >= t then
        table.insert(child.values, 1, parent.values[index - 1])
        parent.values[index - 1] = table.remove(left.values)
        if not left:is_leaf() then
            table.insert(child.children, 1, table.remove(left.children))
        end
    elseif right and #right.values >= t then
        table.insert(child.values, parent.values[index])
        parent.values[index] = table.remove(right.values, 1)
        if not right:is_leaf() then
            table.insert(child.children, table.remove(right.children, 1))
        end
    else
        if left then
            merge_children(parent, index - 1)
        else
            merge_children(parent, index)
        end
    end
end

function b_tree:remove(node, value)
    local t = math.floor(self.max_keys / 2) + 1

    local i = 1
    while i <= #node.values and self.compare(node.values[i], value) do
        i = i + 1
    end

    if i <= #node.values and not self.compare(value, node.values[i]) and not self.compare(node.values[i], value) then
        if node:is_leaf() then
            table.remove(node.values, i)
            return true
        else
            local left = node.children[i]
            local right = node.children[i + 1]
            if #left.values >= t then
                local pred = get_predecessor(left)
                node.values[i] = pred
                return self:remove(left, pred)
            elseif #right.values >= t then
                local succ = get_sucessor(right)
                node.values[i] = succ
                return self:remove(right, succ)
            else
                merge_children(node, i)
                return self:remove(node.children[i], value)
            end
        end
    else
        local child = node.children[i]
        if not child then
            return false
        end

        if #child.values < t then
            fix_child(self, node, i)
            if not node.children[i] then
                child = node.children[i - 1]
            elseif i > 1 and self.compare(value, node.values[i-1]) then
                child = node.children[i - 1]
            else
                child = node.children[i]
            end
        end

        return self:remove(child, value)
    end
end

function b_tree:delete(value)
    if not self.root then return false end
    local ok = self:remove(self.root, value)
    if #self.root.values == 0 and #self.root.children > 0 then
        self.root = self.root.children[1]
    end
    return ok
end

function b_tree:search(value)
    local node = self.root

    while node do
        local i = 1
        local len = #node.values

        while i <= len and self.compare(node.values[i], value) do
            i = i + 1
        end

        if i <= len and not self.compare(value, node.values[i]) then
            return node.values[i]
        end

        if node:is_leaf() then
            return nil
        end

        node = node.children[i]
    end

    return nil
end

function b_tree:iterator()
    return coroutine.wrap(function()
        local function traverse(node)
            if not node then return end
            local is_leaf = node:is_leaf()
            local count = #node.values

            for i = 1, count do
                if not is_leaf then
                    traverse(node.children[i])
                end

                coroutine.yield(node.values[i])
            end

            if not is_leaf then
                traverse(node.children[count + 1])
            end
        end

        traverse(self.root)
    end)
end

return function(list, comp_func)
    return b_tree.new(list, comp_func)
end
