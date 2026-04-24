# iDar-Structures Functions Wiki

## Introduction

This wiki explains the functions available in `iDar-Structures`, a library designed to bring robust data structures (B-Trees, Heaps, and Queues) to ComputerCraft: Tweaked. Because sometimes standard Lua tables just aren't enough to organize your chaotic inventory data.

## Structures

## B-Tree

The B-Tree implementation is optimized for range searches and maintaining sorted data. It uses an **iterative search** approach to avoid stack overflows and improve speed.

### bTree.new_ascending(max_keys, comp_func?) / bTree.new_descending(max_keys, comp_func?)

Helper constructors for standard sorting (numbers or strings).

- **Parameters:**
  - `max_keys`: The maximum number of keys per node.
  - `comp_func?`: The comparation number for sorting, can be nil and use the default (a < b for ascending and a > b for descending)
- **Returns:**
  - `tree`: A new B-Tree instance pre-configured with `<` or `>` comparison.

### tree:insert(value)

Inserts a value into the B-Tree while maintaining order and balancing the tree.

- **Parameters:**
  - `value`: The value to insert (must be compatible with your compare function).
- **Returns:** `nil`

### tree:search(value)

Searches for a value in the tree.

- **Parameters:**
  - `value`: The value to find.
- **Returns:**
  - `foundValue`: The value if found, or `nil` if not present.

#### Implementation Details:

- Uses a **strictly iterative** approach (no recursion), making it roughly 25% faster than recursive implementations and safe against deep trees.
- Performance is approx. 0.09ms per search on large datasets (50k items).

### tree:delete(value)

Removes a value from the tree and rebalances it.

- **Parameters:**
  - `value`: The value to remove.
- **Returns:**
  - `success`: `true` if the value was found and removed, `false` otherwise.

### tree:iterator()

Returns an iterator function to traverse the tree in order.

- **Returns:**
  - `iterator`: A function compatible with the generic `for` loop.

#### Example:

```lua
local BTree = require("Structures.b_tree.init")
local tree = BTree.new_ascending(5)

tree:insert(50)
tree:insert(10)
tree:insert(90)

-- Iterating
for value in tree:iterator() do
    print(value) -- Output: 10, 50, 90
end

```

## Binary Heap

A Binary Heap implementation (Priority Queue) optimized for quick access to the minimum or maximum element.

### binary_heap.new(list?, comp_func?)

Generic constructor for a heap.

- **Parameters:**
- `list?`: (Optional) Initial table of elements to heapify.
- `comp_func?`: (Optional) Comparison function.

- **Returns:**
- `heap`: A new Heap instance.

### heap.new_min(list?) / heap.new_max(list?)

Helper constructors for standard Min-Heaps or Max-Heaps.

- **Parameters:**
- `list?`: (Optional) Initial table of elements.

- **Returns:**
- `heap`: A configured Min or Max Heap.

### heap:insert(node)

Adds an element to the heap and bubbles it up to the correct position.

- **Parameters:**
- `node`: The value to insert.

### heap:pop()

Removes and returns the top element (min or max depending on configuration).

- **Returns:**
- `value`: The top element, or `nil` if empty.

### heap:remove(value)

Removes an arbitrary value from anywhere in the heap and repairs the structure.

- **Parameters:**
- `value`: The value to remove.

### heap:change_key(old_value, new_value)

Updates a value in the heap and rebalances it (bubbles up or heapifies down as needed).

- **Parameters:**
- `old_value`: The current value to change.
- `new_value`: The new value.

#### Example:

```lua
local Heap = require("Structures.heap.init")
local tasks = Heap.new_min()

-- Adding tasks with priority (lower number = higher priority)
tasks:insert(10) -- Low priority
tasks:insert(1)  -- High priority

print(tasks:pop()) -- Output: 1 (High priority)

```

## Queue

A high-performance **First-In-First-Out (FIFO)** buffer. Designed to replace Lua's inefficient `table.remove` for sequential processing.

### Queue()

Creates a new empty queue.

- **Returns:**
- `queue`: A new Queue instance.

### queue:push(item)

Adds an item to the end of the queue.

- **Parameters:**
- `item`: The data to store.

### queue:pop()

Removes and returns the item at the front of the queue.

- **Returns:**
- `item`: The next item, or `nil` if empty.

### queue:peek()

Returns the item at the front without removing it.

- **Returns:**
- `item`: The next item, or `nil` if empty.

### queue:count()

Returns the number of items currently in the queue.

- **Returns:**
- `count`: Number.

#### Implementation Details:

- **O(1) Complexity:** Unlike Lua's native `table.remove(t, 1)` which shifts all remaining elements (O(n)), this implementation uses moving pointers (`first` and `last`) to achieve constant time operations.
- **Memory Safety:** Automatically nil-ifies popped indices to allow the Lua Garbage Collector to reclaim memory immediately.

#### Example:

```lua
-- Note: The module returns the constructor directly
local Queue = require("Structures.queue.init")
local packet_buffer = Queue()

packet_buffer:push("Header")
packet_buffer:push("Body")

print(packet_buffer:pop()) -- Output: Header

```

## BSP Tree

A Binary Space Partitioning (BSP) tree implementation. It's particularly useful for procedural generation (like dungeon rooms), spatial partitioning, and flexible UI layouts.

### bsp_tree(initial_value) / bsp_tree.new(initial_value)

Creates a new BSP Tree with a single root node.

- **Parameters:**
  - `initial_value`: The initial data, table, or area to store in the root node.
- **Returns:**
  - `tree`: A new BSP tree instance containing a `root` node.

### node:is_leaf()

Checks if the current node is a leaf (meaning it hasn't been split and has no children).

- **Returns:**
  - `boolean`: `true` if it's a leaf, `false` otherwise.

### node:split(direction, new_value, ratio)

Divides a leaf node into two children (`left` and `right`). The current node becomes a "split" type and transfers its original value to the new `left` child.

- **Parameters:**
  - `direction`: (Optional) The split direction, typically `"vertical"` or `"horizontal"`. Defaults to `"vertical"`.
  - `new_value`: The value to assign to the new `right` child.
  - `ratio`: (Optional) A number representing the split ratio. Defaults to `0.5` (50%).
- **Returns:**
  - `success`: `true` if successfully split.
  - `error_message`: If the node is already divided, it returns `false` and `"The node is already divided"`.

### node:leaves()

Returns a coroutine-based iterator to traverse all the leaf nodes (undivided areas) under the current node.

- **Returns:**
  - `iterator`: A function compatible with the generic `for` loop that yields leaf `bsp_node` objects.

### node:get_geometry()

Dynamically calculates and returns the spatial dimensions of the node. It resolves the geometry recursively based on the parent's dimensions, the node's split ratio, and the split direction.

- **Returns:**
  - `geometry`: A table containing the calculated dimensions `{x, y, w, h}`, or `nil` if the geometry cannot be resolved.

#### Example:

```lua
local bsp_tree = require("Structures.bsp_tree.init")

-- Create the tree with a starting area (providing initial geometry in the value)
local tree = bsp_tree({name = "Main Room", x = 0, y = 0, w = 100, h = 100})

-- Split the root (creates left and right children)
tree.root:split("vertical", {name = "Corridor"}, 0.6)

-- Split the left child further
tree.root.left:split("horizontal", {name = "Secret Stash"}, 0.3)

-- Iterate through all the final leaves and get their calculated geometry
for leaf in tree.root:leaves() do
    local geom = leaf:get_geometry()
    if geom then
        print(leaf.value.name .. " is at X:" .. geom.x .. " Y:" .. geom.y)
    end
end
```

## Additional Notes

- **B-Tree Performance:** The search function is iterative, which is cool for performance, but `delete` is currently recursive. It still handles 50k elements like a champ, but keep that in mind if you're planning to delete half the universe.
- **Heap vs. Sort:** If you just need to sort a list once, use `table.sort`. If you need to constantly add items and always know which is the smallest/largest, use the **Heap**. It's much faster (`O(log n)`) than re-sorting a table every time.
- **Queue vs. Table:** Stop using `table.insert` and `table.remove` for queues. It kills performance on large lists. Use the **Queue** class.
- **BSP Tree Iteration:** The `leaves()` iterator uses Lua coroutines (`coroutine.wrap` and `coroutine.yield`). This allows for highly efficient, memory-friendly tree traversal. It yields nodes one by one on demand, completely avoiding the need to build and return large intermediate tables to store the leaf nodes.
- **Lua Versions:** Written in pure Lua 5.1, so it runs on basically any potato that supports ComputerCraft.

## Performance Considerations

- **B-Tree Order:** For ComputerCraft, a `maxKeys` (order) between **5 and 10** usually gives the best balance between memory usage and search speed.
- **Memory:** These structures use Lua tables heavily. While efficient, storing 100k+ complex objects might hit the CC memory limit (usually 1MB for standard computers or something, idk dude I just do complex libraries cause it's fun lol).
