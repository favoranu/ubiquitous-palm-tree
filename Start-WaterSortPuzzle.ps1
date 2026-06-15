<#
.SYNOPSIS
    Bootstrapper for Water Sort Puzzle mobile game project (Unity or Godot).

.DESCRIPTION
    Creates a clean, professional folder structure for a Water Sort Puzzle game.
    This is the script referenced in the private conversation for quickly launching
    a revenue-generating puzzle game to fund the larger Nexus Chess project.

    Intended workflow:
      1. Run this script with -ProjectName and -Engine.
      2. Open Unity Hub (or Godot) and create the engine project *inside* the generated folder.
      3. Proceed with architecture, levels, monetization.

.PARAMETER ProjectName
    Name of the game/project folder to create. Default: WaterSortPuzzle

.PARAMETER Engine
    "Unity" (default) or "Godot". Controls .gitignore and README guidance.

.PARAMETER TargetPath
    Optional. Parent directory where the project folder will be created.
    Defaults to current directory.

.PARAMETER Force
    Overwrite existing files if the project folder already exists.

.EXAMPLE
    .\Start-WaterSortPuzzle.ps1 -ProjectName "WaterSortPuzzle" -Engine "Unity"

.EXAMPLE
    cd D:\MobileGames
    .\Start-WaterSortPuzzle.ps1 -ProjectName "WaterSortPuzzle" -Engine "Godot"

.NOTES
    Run from PowerShell (normal user is fine).
    After running, follow the printed instructions.
#>

[CmdletBinding()]
param(
    [string]$ProjectName = "WaterSortPuzzle",

    [ValidateSet("Unity", "Godot")]
    [string]$Engine = "Unity",

    [string]$TargetPath,

    [switch]$Force
)

$ErrorActionPreference = "Stop"

# --- Resolve target location -------------------------------------------------
if (-not $TargetPath) {
    $TargetPath = Get-Location
}

$ProjectRoot = Join-Path $TargetPath $ProjectName

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  WATER SORT PUZZLE - Project Bootstrapper" -ForegroundColor Yellow
Write-Host "  Engine: $Engine" -ForegroundColor White
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

if (Test-Path $ProjectRoot) {
    if (-not $Force) {
        Write-Warning "Project folder already exists: $ProjectRoot"
        $response = Read-Host "Overwrite / continue anyway? (y/N)"
        if ($response -notmatch '^[Yy]') {
            Write-Host "Aborted by user." -ForegroundColor Red
            exit 1
        }
    }
}

# Ensure root exists
New-Item -ItemType Directory -Path $ProjectRoot -Force | Out-Null

Write-Host "Creating project at: $ProjectRoot" -ForegroundColor Green

# --- Folder structure (as specified in the conversation) ---------------------
$folders = @(
    "Assets/Scripts",
    "Assets/Scenes",
    "Assets/UI",
    "Assets/Art",
    "Assets/Sounds",
    "Builds",
    "Docs"
)

foreach ($folder in $folders) {
    $full = Join-Path $ProjectRoot $folder
    New-Item -ItemType Directory -Path $full -Force | Out-Null
    # Add .gitkeep so the folder is tracked even when empty
    $gitkeep = Join-Path $full ".gitkeep"
    if (-not (Test-Path $gitkeep)) {
        "" | Out-File -FilePath $gitkeep -Encoding utf8 -Force
    }
    Write-Host "  + $folder" -ForegroundColor DarkGray
}

# --- Root supporting files ---------------------------------------------------
function Write-File {
    param([string]$RelativePath, [string]$Content)
    $fullPath = Join-Path $ProjectRoot $RelativePath
    $Content | Out-File -FilePath $fullPath -Encoding utf8 -Force
    Write-Host "  + $RelativePath" -ForegroundColor DarkGray
}

# .gitignore (engine-specific + common)
$gitignoreContent = if ($Engine -eq "Unity") {
@"
# Unity generated
[Ll]ibrary/
[Tt]emp/
[Oo]bj/
[Bb]uild/
[Bb]uilds/
[Ll]ogs/
[Uu]serSettings/

# Unity packages / cache
*.apk
*.aab
*.unitypackage

# OS junk
.DS_Store
Thumbs.db
desktop.ini

# IDE / editor
.vscode/
.idea/
*.csproj
*.sln
*.suo
*.user
*.userprefs

# Builds we intentionally keep
# Builds/   <-- we want to track release notes, but not the actual player data

# Water Sort specific (add your own generated data here if needed)
# Assets/Art/Generated/
"@
} else {
@"
# Godot 4
.godot/
export.cfg
export_presets.cfg

# Godot 3 (legacy)
.import/
export.cfg
export_presets.cfg

# Build outputs
*.apk
*.aab
*.ipa
*.xapk
Builds/

# OS junk
.DS_Store
Thumbs.db
desktop.ini

# IDE
.vscode/
.idea/
*.sln
*.csproj

# Add your own
# .godot/mono/
"@
}

Write-File ".gitignore" $gitignoreContent

# README.md
$readme = @"
# Water Sort Puzzle

**The simplest, fastest, and most reliable puzzle game to publish on Android + iOS and start generating revenue for Nexus Chess.**

**Source:** https://github.com/favoranu/ubiquitous-palm-tree

This project was bootstrapped with the official Start-WaterSortPuzzle.ps1 script (hosted at the root of the repo above).

**One-liner to get the latest bootstrapper:**
```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/favoranu/ubiquitous-palm-tree/main/Start-WaterSortPuzzle.ps1" -OutFile "Start-WaterSortPuzzle.ps1"
.\Start-WaterSortPuzzle.ps1 -ProjectName "$ProjectName" -Engine "$Engine"
```

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
- Open **Unity Hub**
- Create new project → **2D (URP)** template
- **Important**: Point the location to this exact folder:
  ````text
  $ProjectRoot
  ````
  Unity will populate ProjectSettings/, Packages/, etc. The Assets/ folder you see here will become your project Assets.

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
```
$ProjectName/
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
```

## Next Steps (after creating the engine project)
Reply in our conversation with one of the following:

- **"Project created, give me the core architecture"**  
  → Tube class, Liquid data model, Level serialization, Input system (very simple stack-based model)

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
"@

# Replace the placeholder $ProjectRoot in the README with the actual name
$readme = $readme.Replace('$ProjectName', $ProjectName).Replace('$ProjectRoot', $ProjectRoot)
Write-File "README.md" $readme

# --- Docs/ content -----------------------------------------------------------
$docsReadme = @"
# Water Sort Puzzle - Documentation

This folder contains all planning, architecture, and production documents.

See the main README.md for how to get started.
"@ 
Write-File "Docs/README.md" $docsReadme

$architectureStub = @"
# Core Game Architecture (Stub)

## Data Model (keep it dead simple)
- **Color**: enum or string / int ID (Red, Blue, Green, Yellow, Purple, Cyan, etc.)
- **Tube**: 
  - Capacity (usually 4)
  - List<Color> layers   // index 0 = bottom, last = top
- **LevelData**:
  - tubes: array of tube states (serialized)
  - moves: int (optional par)
  - id / name / difficulty

## Core Systems
1. TubeController (or Tube node)
   - CanPourTo(other)
   - PourTo(other)  // moves max possible layers
   - IsFullOfOneColor()
2. LevelManager
   - LoadLevel(LevelData)
   - CheckWin()
   - Undo stack (simple state snapshots)
3. InputSystem
   - Tap tube → highlight → tap second tube → attempt pour
4. LevelGenerator (for infinite / daily levels)
   - Shuffle + validate solvability (with 2 empty tubes this is almost always possible)

## Serialization
- Unity: ScriptableObject or JSON (Newtonsoft or built-in)
- Godot: Resource (.tres) or JSON

Keep everything in plain data so levels are easy to author by hand or generate.

See LevelDesign.md for the 30-level plan.
"@
Write-File "Docs/Architecture.md" $architectureStub

$monetization = @"
# Monetization Setup Guide

## Unity (primary path)
1. Install **Unity Ads** package (or Mediation)
2. Initialize in a persistent GameObject (Application.internetReachability check)
3. Rewarded Ads:
   - Hint (show solution step)
   - Extra moves
   - Skip to next level
4. Interstitials: only on level complete / fail (very light)
5. Banner: bottom of level select only (optional)

## IAP (Unity Purchasing)
- Remove Ads (non-consumable)
- Unlock All Levels (one-time)
- Coin packs (if we add a soft currency later)

## Godot equivalent
- Use Godot AdMob plugin or custom Android/iOS export plugins.
- For IAP use Godot's in-app purchase plugins or third-party.

## Key Metrics to track early
- Day 1 / Day 7 retention
- Average levels per session
- Hint usage rate (adjust difficulty)
- Ad view → reward completion rate

Target: 35%+ D1 retention and decent LTV within first month.
"@
Write-File "Docs/Monetization.md" $monetization

$levelsPlan = @"
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
"@
Write-File "Docs/LevelDesign.md" $levelsPlan

$gettingStarted = @"
# Getting Started After Engine Project Creation

1. Delete Unity's default SampleScene if present.
2. Create folders under Assets/ matching (or use the ones created by bootstrap).
3. Create first scene: MainMenu
4. Implement the absolute minimal vertical slice:
   - 4 tubes on screen (hard-coded data)
   - Click-to-select + click-to-pour
   - Win condition popup
5. Once the core loop feels good, expand to level loading + 5 tutorial levels.

Reply with "Project created, give me the core architecture" when you're at this point.
"@
Write-File "Docs/GettingStarted.md" $gettingStarted

# --- Engine-specific starter files -------------------------------------------
if ($Engine -eq "Unity") {
    $tubeStub = @"
// Assets/Scripts/Tube.cs
// TODO: Implement after project is created in Unity
using System.Collections.Generic;
using UnityEngine;

public class Tube : MonoBehaviour
{
    public int Capacity = 4;
    public List<ColorID> layers = new List<ColorID>(); // 0 = bottom

    public bool IsEmpty => layers.Count == 0;
    public ColorID? TopColor => IsEmpty ? null : layers[layers.Count - 1];

    public bool CanPourInto(Tube other)
    {
        if (IsEmpty) return false;
        if (other.layers.Count >= other.Capacity) return false;
        if (other.IsEmpty) return true;
        return other.TopColor == this.TopColor;
    }

    // ... PourInto logic, visual update, etc.
}

public enum ColorID
{
    None = 0,
    Red,
    Blue,
    Green,
    Yellow,
    Purple,
    Cyan,
    Orange,
    // Add more as needed
}
"@
    Write-File "Assets/Scripts/Tube.cs" $tubeStub

    $levelDataStub = @"
// Assets/Scripts/LevelData.cs
// Simple serializable level definition. Expand later.
using System;
using UnityEngine;

[CreateAssetMenu(fileName = "LevelData", menuName = "WaterSort/LevelData")]
public class LevelData : ScriptableObject
{
    public int id;
    public string levelName;
    public TubeState[] tubes;

    [Serializable]
    public class TubeState
    {
        public ColorID[] layers; // bottom to top
    }
}
"@
    Write-File "Assets/Scripts/LevelData.cs" $levelDataStub
}

if ($Engine -eq "Godot") {
    $godotReadme = @"
# Godot Specific Notes

- Put game scripts in `Assets/Scripts/` (or move to a `scripts/` folder at root if you prefer Godot conventions).
- Scenes go in `Assets/Scenes/`.
- Use Godot Resources for LevelData (or plain JSON + ResourceLoader).
- For mobile export: enable "Mobile" rendering, export to Android + iOS templates.
"@
    Write-File "Assets/Scripts/GodotNotes.md" $godotReadme
}

# --- Final output ------------------------------------------------------------
Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ✅ Bootstrap complete!" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "Project folder: $ProjectRoot" -ForegroundColor White
Write-Host ""
Write-Host "Next actions:" -ForegroundColor Yellow
Write-Host "  1. Open Unity Hub (recommended) or Godot" -ForegroundColor White
Write-Host "  2. Create a new 2D (URP) / Godot project pointing EXACTLY to:" -ForegroundColor White
Write-Host "     $ProjectRoot" -ForegroundColor Cyan
Write-Host "  3. Once the engine project exists, come back here and reply with:" -ForegroundColor White
Write-Host ""
Write-Host '     "Project created, give me the core architecture"' -ForegroundColor Magenta
Write-Host "     or" -ForegroundColor DarkGray
Write-Host '     "I''m using Godot, give me the structure"' -ForegroundColor Magenta
Write-Host "     or" -ForegroundColor DarkGray
Write-Host '     "Give me the full development plan"' -ForegroundColor Magenta
Write-Host ""
Write-Host "This will get Water Sort Puzzle on the stores fast and start" -ForegroundColor DarkGray
Write-Host "generating the revenue to pour into Nexus Chess. Let's go!" -ForegroundColor DarkGray
Write-Host ""

# Optional: open the folder
try {
    if ($IsWindows -or $env:OS -like "*Windows*") {
        Start-Process explorer.exe $ProjectRoot
    }
} catch { }

exit 0
