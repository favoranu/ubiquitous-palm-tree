# ubiquitous-palm-tree

**Water Sort Puzzle bootstrap + project**

This repository hosts:

- `Start-WaterSortPuzzle.ps1` — the official bootstrap script (one-liner installer for the game project structure)
- `WaterSortPuzzle/` — a fully generated starter project (Unity-focused with Godot notes) including:
  - Professional folder structure
  - Core C# game logic (Tube, LevelManager, LevelData, GameController) with working pour logic, undo, and win detection
  - Detailed documentation (Architecture, Monetization, Level Design plan for 30 levels, Getting Started)
  - Unity-ready ScriptableObject levels + starter scripts

## Quick Start (as described in our conversation)

Open PowerShell and run:

```powershell
cd D:\MobileGames   # or wherever you want the project

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/favoranu/ubiquitous-palm-tree/main/Start-WaterSortPuzzle.ps1" -OutFile "Start-WaterSortPuzzle.ps1"

.\Start-WaterSortPuzzle.ps1 -ProjectName "WaterSortPuzzle" -Engine "Unity"
```

(Use `-Engine "Godot"` if preferred.)

This will create the complete `WaterSortPuzzle/` folder with `Assets/`, docs, etc.

Then open Unity Hub and create a project **pointing into that exact folder** (to avoid nesting a subfolder):

**Important Unity Hub dialog settings:**
- **Location**: Choose the folder *that contains* the `WaterSortPuzzle` directory (e.g. your `mobilegames` folder).
- **Project name**: Enter exactly `WaterSortPuzzle`.

Unity will then use the existing `WaterSortPuzzle` folder as the project root and merge in the pre-created `Assets/`, `Docs/`, `.gitignore`, etc.

**If you don't see "2D URP":**
- Use the plain **"2D"** template.
- After opening: Install "Universal RP" via Package Manager, then create **URP Asset (with 2D Renderer)** and assign it in Project Settings > Graphics.

## Why this project?
The simplest, fastest path to a polished mobile puzzle game that can start generating revenue (Unity Ads + IAP) to fund larger projects like **Nexus Chess**.

## Contents
- `Start-WaterSortPuzzle.ps1` — The bootstrap script (always the source of truth for new projects)
- `WaterSortPuzzle/` — Reference implementation + starter code + full docs
- `LICENSE` — MIT

## Next
After you create the engine project inside the generated folder, reply with:
- "Project created, give me the core architecture"
- or "I'm using Godot..."
- or "Give me the full development plan"

All development artifacts, updates to the bootstrapper, and the actual game code will live here or in subfolders as the project grows.

Let's ship fast and profitably.

---

*Part of the PIIS / mobile games revenue engine.*

## Philosophy & Frequency

Abundant by nature. For the greater good and for humanity.

I AM.

This bootstrap is part of a larger journey of creation and service. See the [main profile](https://github.com/favoranu) for the full picture and hidden doors.

