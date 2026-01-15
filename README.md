# iDar-Structures

iDar-Structures is an efficient and modular data structures library, implemented in pure Lua and optimized for ComputerCraft: Tweaked. Designed to fill the gap of complex structures in Lua, it provides robust implementations of B-Trees and Binary Heaps to handle large volumes of data with high performance.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)

  - [B-Tree](#b-tree)
  - [Binary Heap](#binary-heap)
  - [Queue](#queue)

- [Performance Notes](#performance-notes)
- [FAQ](#faq)
- [Contributing](#contributing)
- [License](#license)

## Features

- **B-Tree**: A self-balancing search tree of order _m_.

  - **Iterative Search**: Optimized to avoid stack overflows and improve speed.
  - **Native Iterators**: Traverse the tree using `for x in tree:iterator()`.
  - **Custom Comparators**: Full flexibility to sort numbers, strings, or complex tables.

- **Binary Heap**: Efficient priority queue implementation.

  - **Min-Heap and Max-Heap**: Fast constructors for common use cases.
  - **Key Updates**: Supports `change_key` and arbitrary removal.

- **Queue**: High-performance FIFO (First-In-First-Out) buffer.

  - **O(1) Operations**: Optimized `push` and `pop` mechanisms, significantly faster than Lua's native `table.remove` for large datasets.
  - **Memory Safe**: Automatic reference clearing to prevent memory leaks in long-running processes.

- **Lightweight**: No external dependencies, pure Lua.

- **Modular**: Load only the structures you need.

## Requirements

- Minecraft with the ComputerCraft: Tweaked mod installed.
- Basic Lua programming knowledge.
- Any version of CC: Tweaked that supports Lua 5.1+ (basically all modern ones).

## Installation

### Recommended Installation (via [`iDar-Pacman`](https://github.com/DarThunder/iDar-Pacman)):

```lua
pacman -S idar-structures
```

### Manual Installation:

1. Download the files from the repository.
2. Place them inside your computer folder at `/iDar/Structures/src`.
3. Use `require("iDar.Structures.src.module_name")` to load the structures.

## Usage

### B-Tree

The B-Tree is ideal for storing large amounts of sorted data and performing fast searches in disk or memory.

```lua
local BTree = require("iDar.Structures.src.b_tree.init")

-- Create an ascending tree with a maximum of 5 keys per node
local tree = BTree.new_ascending(5)

-- Insert data
tree:insert(42)
tree:insert(10)
tree:insert(88)

-- Search for a value
local val = tree:search(10)
print(val) -- Output: 10

-- Iterate through the tree in sorted order (Iterator)
print("--- Sorted Values ---")
for value in tree:iterator() do
    print(value)
end
-- Output: 10, 42, 88

-- Delete values
tree:delete(42)
```

### Binary Heap

Perfect for priority queues, pathfinding (A\*), or scheduled task management.

```lua
local Heap = require("iDar.Structures.src.heap.init")

-- Create a Min-Heap (lowest value has priority)
local pq = Heap.new_min()

-- Insert tasks or values
pq:insert(15)
pq:insert(5)
pq:insert(30)

-- Get and remove the highest priority item (the smallest)
print(pq:pop()) -- Output: 5
print(pq:pop()) -- Output: 15

-- Create a Max-Heap (highest value has priority)
local max_pq = Heap.new_max()
max_pq:insert(10)
max_pq:insert(100)
print(max_pq:pop()) -- Output: 100
```

### Queue

A strictly typed First-In-First-Out structure. Essential for buffering network packets, managing task pipelines, or Breadth-First Search (BFS) algorithms where order matters.

```lua
-- The module returns the constructor directly
local Queue = require("iDar.Structures.src.queue.init")

local q = Queue()

-- Enqueue items (O(1))
q:push("Packet_001")
q:push("Packet_002")
q:push("Packet_003")

-- Check size
print(q:count()) -- Output: 3

-- Peek at the front without removing
print(q:peek()) -- Output: Packet_001

-- Dequeue items (O(1))
print(q:pop()) -- Output: Packet_001
print(q:pop()) -- Output: Packet_002

-- Check if empty
print(q:is_empty()) -- Output: false
```

## Performance Notes

**B-Tree Optimization:**
Unlike traditional recursive implementations, this B-Tree’s `search` method is **iterative**. This results in superior performance (approx. 25% faster in 50k-element benchmarks) and zero risk of stack overflow in deep searches.

**Capacity:**
Successfully tested with insertions and lookups of up to 50,000 elements in standard ComputerCraft environments while maintaining response times under 0.15s.

## FAQ

**Q: Can I store tables or objects in the B-Tree?**
A: Yes! You can pass a custom comparison function (`comp_func`) as the second argument to the helper constructors (`new_ascending` or `new_descending`) to define the sorting logic for your objects.

**Q: Why use a B-Tree instead of a Lua table?**
A: Lua tables are fast, but they don’t keep keys sorted automatically, and sorting (`table.sort`) becomes expensive when done repeatedly. The B-Tree keeps data sorted at all times—perfect for databases or large inventories.

**Q: Is it compatible with older versions of ComputerCraft?**
A: The library is written in standard Lua 5.1, so it should work with the vast majority of ComputerCraft and CC: Tweaked versions.

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or fix (`git checkout -b feature/new-feature`).
3. Submit a Pull Request with a clear description.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.
