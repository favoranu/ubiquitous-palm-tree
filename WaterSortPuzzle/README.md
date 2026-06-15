# Water Sort Puzzle

**The simplest, fastest, and most reliable puzzle game to publish on Android + iOS and start generating revenue for Nexus Chess.**

This project was bootstrapped with the official Start-WaterSortPuzzle.ps1 script.

## Project Goal
Ship a polished, addictive water sort puzzle with:
- 30+ high-quality levels (hand-crafted + procedural)
- Clean 2D visuals (URP / Godot)
- Strong retention loop (daily rewards, level progression, stars)
- Monetization: Unity Ads (or Godot equivalent) + In-App Purchases
- Fast iteration → revenue → fund the bigger **Nexus Chess** project

## Getting Started

### 1. Create the Engine Project (do this now)
**For Unity (recommended for fastest store publishing):**

You are likely hitting **"A project with this name already exists at this location"**.

The bootstrap pre-created the `WaterSortPuzzle` folder, so Unity Hub blocks creating another project with that name there.

**Exact steps to fix:**
1. Close Unity Hub.
2. In Explorer, rename `WaterSortPuzzle` (inside mobilegames) to `WaterSortPuzzle_scaffold`.
3. Unity Hub → New project:
   - **Location**: `C:\Users\klslc\GROK\mobilegames` (the parent)
   - **Project name**: `WaterSortPuzzle`
   - Template: **2D** (use this; 2D URP may not show)
4. Create the project. Unity makes a fresh `WaterSortPuzzle` with its own files.
5. Open it.
6. Copy from `_scaffold`:
   - `Assets/Scripts/` *.cs files → new project's `Assets/Scripts/`
   - `Docs/` folder → project root
   - Root `README.md` and `.gitignore` → project root
7. Delete the `_scaffold` folder.
8. In Unity: scripts will import. Set up URP next.

**For Godot:**
- Open Godot 4+
- Create new project and point it to this folder.
- Use Forward+ or Mobile renderer.

### 2. Recommended Project Settings (Unity)
- Target: Android + iOS
- Minimum API: 24 (Android), iOS 13+
- Scripting Backend: IL2CPP
- Graphics API: Vulkan + OpenGLES3 (Android), Metal (iOS)
- Enable "Optimized Frame Pacing"
- Use Unity's 2D URP + addressables or built-in for levels later

### Folder Structure
`
WaterSortPuzzle/
├── Assets/
│   ├── Scripts/          # C# game logic (Tube, Liquid, LevelManager, etc.)
│   ├── Scenes/           # MainMenu, Game, LevelSelect, WinPopup
│   ├── UI/               # Canvas prefabs, UI Toolkit or uGUI
│   ├── Art/              # Sprites, animations, materials, atlases
│   └── Sounds/           # SFX + music (use Addressables later)
├── Builds/               # Exported APKs, IPAs, release notes
├── Docs/                 # Design docs, level plans, postmortems
├── README.md
└── .gitignore
`

## Next Steps (after creating the engine project)
Reply in our conversation with one of the following:

- **"Project created, give me the core architecture"**  
  → (Already partially provided — see Docs/Architecture.md + the ready-to-use scripts in Assets/Scripts/: Tube.cs, LevelManager.cs, LevelData.cs, GameController.cs)

The bootstrap script has given you a running start with working pour logic, undo, win detection, and level data.

## Core Scripts Provided by Bootstrap
- `Assets/Scripts/Tube.cs` — complete data + CanPourInto / PourInto rules
- `Assets/Scripts/LevelManager.cs` — level loading, undo stack, win checking, events
- `Assets/Scripts/LevelData.cs` — ScriptableObject level format + helpers
- `Assets/Scripts/GameController.cs` — minimal scene wiring example

See `Docs/GettingStarted.md` for the exact 1-hour vertical slice instructions.

- **"I'm using Godot, give me the structure"**  
  → Godot-specific nodes, GDScript / C# layout, scene organization

- **"Give me the full development plan"**  
  → 30 levels strategy, monetization setup (Unity Ads + IAP), analytics, store listing checklist, release timeline

## Monetization Philosophy (keep it honest)
- Non-intrusive rewarded ads for hints / extra moves / level skips
- One-time "Remove Ads" + "Unlock All Levels" IAP
- No aggressive interstitials on every loss
- Goal: high retention + LTV that funds Nexus Chess development

## License / Notes
Internal project for revenue generation. Keep the code clean and well-documented so we can move fast.

Let's ship this quickly and profitably.
