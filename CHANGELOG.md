# Changelog

## Beta

### v0.1.0

#### New Structures

- **`B-Tree` Module:** Implementation of a self-balancing B-Tree of order $M$, optimized for searching and maintaining large sorted datasets.
- **`Binary Heap` Module:** Efficient implementation of a Priority Queue (Min-Heap and Max-Heap).

#### Added

- **B-Tree Core:**
  - Complex Insertion (`tree:insert`) and Deletion (`tree:delete`) with full rebalancing (split/merge).
  - Search (`tree:search`) using a **strictly iterative** approach to prevent stack overflows.
  - Native iterator (`tree:iterator`) that uses Lua **coroutines** for highly efficient **In-Order** $O(N)$ traversal.
  - Helper constructors (`new_ascending`/`new_descending`) to set the default sorting order.
  - Full support for custom comparison functions (`comp_func`) to sort complex objects.
- **Binary Heap Core:**
  - Essential manipulation functions: `heap:insert()`, `heap:pop()`, `heap:remove(value)`, and `heap:change_key(old, new)`.
  - Convenient constructors `heap.new_min()` and `heap.new_max()`.

#### Performance Notes

- **Search Optimization:** The iterative search implementation is approximately **25% faster** than traditional recursive implementations.
- **Capacity:** Successfully tested with insertions and searches of up to **50,000 elements** in standard ComputerCraft environments, maintaining response times under **0.15 seconds**.
- **Traversal Efficiency:** The use of coroutines in the iterator guarantees minimal overhead for $O(N)$ iteration.

#### Known Issues

- The current implementation of the B-Tree deletion method (`tree:delete`) is still **recursive**. While it is functional and robust, caution is advised when deleting large portions of the tree in stack-limited contexts.

### v0.1.1

#### Added

- **Package Manager Support:** Added the `manifest.lua` metadata file to enable installation and proper dependency resolution through **iDar-Pacman** (SATD Standard).

#### Changed

- **Module Paths:** Modified all internal `require` paths to align with the new absolute standard of the `iDar` ecosystem (example: `require("iDar.Structures.src.BTree.bTree")`).

#### Removed

- Legacy installer script (`installer.lua`).

### v0.1.2

#### Changed

- Manifest updated for compatibility with iDar-Pacman Alpha v2

## v0.1.3

**"The Collections Update"**

After extensive testing in high-throughput scenarios, we identified the need for strictly ordered data processing. This update introduces efficient linear data structures to complement our existing Heap implementation.

### New Features

- **Queue (FIFO):** Added a high-performance Queue implementation (`queue.lua`).
  - _Performance:_ optimized for $O(1)$ push/pop operations, replacing the inefficient `table.remove` paradigm used in standard Lua scripts.
  - _Use Case:_ Essential for upcoming networking layers and BFS pathfinding algorithms.

### Improvements & Fixes

- **Heap Constructor Robustness:** Refined the type checking logic in `init.lua`'s `new_min/new_max` factories.
  - _Detail:_ Improved the evaluation of custom comparator functions to ensure they are correctly prioritized over default implementations during instantiation.
- **Memory Management:** Queues automatically clear references to popped items to prevent memory leaks in long-running daemon processes.
