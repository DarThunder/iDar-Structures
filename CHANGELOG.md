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
