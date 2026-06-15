# Getting Started After Engine Project Creation

## Creating the Unity Project (if you couldn't find "2D URP")

If Unity Hub did not show a **"2D URP"** or **"Universal 2D"** template:

- Choose the regular **"2D"** template.
- Point it at the `WaterSortPuzzle` folder the bootstrap script created.
- Once inside the editor:
  1. Open **Window → Package Manager**
  2. In the top-left dropdown choose **Unity Registry**
  3. Search for "**Universal RP**" and install it.
  4. Accept the prompt to convert the project to the Universal Render Pipeline.
  5. Create a 2D-ready pipeline asset:
     - Right-click in Project window → **Create → Rendering → URP Asset (with 2D Renderer)**
     - Name it e.g. `Main2D_URP`
  6. Go to **Edit → Project Settings → Graphics** and assign the new asset you created.
  7. (Optional but recommended for 2D) In the same URP asset, make sure it uses the 2D Renderer for 2D scenes.

This gives you modern mobile-friendly 2D rendering with URP.

---

1. Delete Unity's default SampleScene if present (or keep for reference).
2. The bootstrap already created the recommended `Assets/Scripts/`, `Assets/Scenes/`, etc.
3. Create your first scene called `Game` (or `LevelScene`).
4. Minimal vertical slice (you can do this in < 1 hour once project is open):
   - Drag a few Tube prefabs (or plain GameObjects with Tube.cs + TubeVisual) into the scene.
   - Add a LevelManager to an empty GameObject and assign the Tubes.
   - Create 1-2 LevelData assets (Assets → Create → WaterSort → LevelData).
   - Add GameController, wire it up, assign the LevelData.
   - Implement basic selection + pouring (TubeVisual with Button or IPointerClickHandler recommended).
   - Wire win popup (Canvas + Text/Button).
5. Test undo, win condition, and a couple of different LevelData setups.
6. Once the core "pour water until every tube is one solid color" feels fun and reliable, expand.

## Files the bootstrap already gave you
- `Assets/Scripts/Tube.cs` — fully working pour logic + state snapshot
- `Assets/Scripts/LevelManager.cs` — undo, win detection, level loading
- `Assets/Scripts/GameController.cs` — scene wiring example
- `Assets/Scripts/LevelData.cs` — ScriptableObject for levels

You can start playing with these immediately after creating the Unity project.

Reply with **"Project created, give me the core architecture"** (or the Godot variant) if you want even more detailed next pieces (TubeVisual implementation, simple solver for hints, UI flow, etc.).

