# Core Game Architecture

**Goal**: Dead-simple, reliable, easy to extend, and mobile-friendly.

The implementation is deliberately small so one person can ship the first version fast.

## Data Model

```csharp
// ColorID.cs (or inside Tube.cs)
public enum ColorID { None, Red, Blue, Green, Yellow, Purple, Cyan, Orange, Magenta }

// TubeState (plain serializable data)
[Serializable]
public class TubeState {
    public List<ColorID> layers;   // 0 = bottom, last = top. Max 4 elements.
}
```

**LevelData** (ScriptableObject shown in the project):
- id, levelName, parMoves
- TubeState[] tubes
- Optional: hint text, star thresholds, tags

We keep **pure data** separate from MonoBehaviours so levels are trivial to edit, generate, or load from JSON later.

## Core Classes (already partially implemented in Assets/Scripts/)

1. **Tube.cs** (MonoBehaviour)
   - Holds runtime `List<ColorID> layers`
   - `CanPourInto(Tube other)`
   - `PourInto(Tube other)` — moves the maximum possible same-color layers
   - `GetPourableAmount()` (consecutive top color)
   - `GetState()` / `LoadState(TubeState)` for snapshots
   - Fires `OnStateChanged` event for visuals

2. **LevelManager.cs**
   - Owns the list of active `Tube` references
   - `LoadLevel(LevelData)`
   - `TryPour(Tube from, Tube to)`
   - Undo via `Stack<TubeState[]>`
   - `CheckWinCondition()` — every non-empty tube must be full and mono-color
   - Exposes UnityEvents for UI binding

3. **GameController.cs** (or LevelSceneController)
   - Wires LevelManager + UI
   - Level progression, win popup, restart, next level

## Input (very important to keep simple)

Option A (easiest for vertical slice):
- Each Tube has a `TubeVisual` that has a big invisible Button or uses IPointerClickHandler
- On click: if no source selected → select this tube (highlight)
- If source selected → call `levelManager.TryPour(source, this)`, then clear selection

Option B (more robust later):
- Use a small state machine in GameController: `None → SourceSelected → WaitingForDestination`

Add nice feedback:
- Scale / color highlight on selected tube
- Brief animation when pouring (move the colored segment sprites)

## Visuals (TubeVisual.cs recommended next)

Separate logic from presentation:
- TubeVisual listens to `tube.OnStateChanged`
- Rebuilds the visual stack (4 slots, each can show a colored liquid sprite or Image with color)
- Use a simple array of `Image` or `SpriteRenderer` children
- Optional: particle burst when a tube becomes complete

## Serialization & Level Authoring

**During development**:
- Use the `LevelData` ScriptableObjects (create via Assets → Create → WaterSort → LevelData)
- Assign them in the GameController inspector for quick testing

**For production / many levels**:
- Export to JSON (or Addressables)
- Build a tiny in-game level editor or external tool (even a simple web page + copy JSON)
- Godot users: use .tres Resources or JSON + `JSON.parse`

Example minimal JSON level:
```json
{
  "id": 5,
  "levelName": "First Split",
  "parMoves": 6,
  "tubes": [
    { "layers": ["Red","Red","Blue","Blue"] },
    { "layers": ["Blue","Blue","Red","Red"] },
    { "layers": [] },
    { "layers": [] }
  ]
}
```

## Recommended Additional Systems (add after core loop works)

- Undo / limited undos (or buy more with rewarded ad)
- Hint system (use a simple solver — BFS works great for <10 tubes)
- Star scoring + level select with progress
- Daily challenge (seed a procedural level)
- Settings (sound, haptics, remove ads)

## Godot Notes

If using Godot:
- `Tube` becomes a `Node2D` + script (GDScript or C#)
- Use `Resource` classes for LevelData instead of ScriptableObject
- Signals instead of UnityEvents
- The logic (CanPour / Pour) stays almost identical

See `Assets/Scripts/GodotNotes.md` (created by bootstrap if you chose Godot).

## Summary — Minimal Vertical Slice Order

1. 4–6 hard-coded tubes on screen using the `Tube` + `LevelManager`
2. Click-to-pour working + undo button
3. Win detection + simple "Level Complete" UI
4. Load real LevelData assets (5 tutorial levels)
5. Add juice (animations, particles, sound)
6. Then expand to level select, more levels, monetization hooks.

This architecture has powered many successful hyper-casual / puzzle games. It is small, testable, and easy to hand to another developer later.

Next document: LevelDesign.md (first 30 levels strategy).

