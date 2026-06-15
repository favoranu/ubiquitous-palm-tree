# Level Design Plan - First 30 Levels

## Philosophy
Start extremely easy so players feel smart and get the "aha" moment quickly.
Gradually introduce mechanics:
- Multiple same-color splits
- Using empty tubes as temporary storage
- Forced partial pours
- Color count > number of tubes - 2 (requires clever use of space)

## Tier Structure (example)
1-5   : Tutorial (2-3 colors, 1 empty tube)
6-12  : Basic (3-4 colors, 2 empties)
13-20 : Intermediate (4-5 colors, tricky splits)
21-27 : Advanced (5-6 colors, backtracking required)
28-30 : Expert / "boss" levels (beautiful hand-crafted)

## Generation Strategy
- Hand-author first 15 (quality control)
- Procedural for the rest + daily challenges
- Every level must be solvable in <= 25-30 moves with optimal play
- Store levels as JSON / ScriptableObject / Godot Resource so designers (or you) can tweak easily

## Tools we will build
- In-game level editor (or simple external tool)
- Solver (BFS / DFS) so we can validate + generate hints
- Star rating system (moves par, perfect clear, etc.)

Document every interesting level pattern here as we discover them.
