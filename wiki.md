# iDar-Structures Functions Wiki

## Introduction

This wiki explains the functions available in `iDar-Structures`, a library designed to bring robust data structures (B-Trees and Heaps) to ComputerCraft: Tweaked. Because sometimes standard Lua tables just aren't enough to organize your chaotic inventory data.

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
local BTree = require("iDar.Structures.src.b_tree.init")
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
local Heap = require("iDar.Structures.src.heap.init")
local tasks = Heap.new_min()

-- Adding tasks with priority (lower number = higher priority)
tasks:insert(10) -- Low priority
tasks:insert(1)  -- High priority

print(tasks:pop()) -- Output: 1 (High priority)
```

## Additional Notes

- **B-Tree Performance:** The search function is iterative, which is cool for performance, but `delete` is currently recursive. It still handles 50k elements like a champ, but keep that in mind if you're planning to delete half the universe.
- **Heap vs. Sort:** If you just need to sort a list once, use `table.sort`. If you need to constantly add items and always know which is the smallest/largest, use the **Heap**. It's much faster (`O(log n)`) than re-sorting a table every time.
- **Lua Versions:** Written in pure Lua 5.1, so it runs on basically any potato that supports ComputerCraft.

## Performance Considerations

- **B-Tree Order:** For ComputerCraft, a `maxKeys` (order) between **5 and 10** usually gives the best balance between memory usage and search speed.
- **Memory:** These structures use Lua tables heavily. While efficient, storing 100k+ complex objects might hit the CC memory limit (usually 1MB for standard computers).
