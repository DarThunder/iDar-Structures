local queue = {}
queue.__index = queue

function queue.new()
    return setmetatable({first = 0, last = -1, items = {}}, queue)
end

function queue:push(item)
    local last = self.last + 1
    self.last = last
    self.items[last] = item
end

function queue:pop()
    local first = self.first
    if first > self.last then return nil end

    local item = self.items[first]
    self.items[first] = nil
    self.first = first + 1

    return item
end

function queue:peek()
    if self.first > self.last then return nil end
    return self.items[self.first]
end

function queue:is_empty()
    return self.first > self.last
end

function queue:count()
    return (self.last - self.first) + 1
end

return queue