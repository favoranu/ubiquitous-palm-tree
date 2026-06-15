// Assets/Scripts/GameController.cs
// Minimal example of a scene controller that wires everything together.
// Attach to a GameObject in your Game scene.
// This is a starting vertical slice — expand with UI, animations, level selection, etc.

using UnityEngine;

public class GameController : MonoBehaviour
{
    [Header("Level Setup")]
    public LevelManager levelManager;
    public LevelData[] levels;           // assign in inspector or load from Resources/Addressables

    [Header("Current")]
    public int currentLevelIndex = 0;

    private void Start()
    {
        if (levels != null && levels.Length > 0 && levelManager != null)
        {
            StartLevel(0);
        }
        else
        {
            Debug.LogWarning("Assign LevelManager and at least one LevelData in the inspector to test.");
        }
    }

    public void StartLevel(int index)
    {
        if (levels == null || index < 0 || index >= levels.Length) return;

        currentLevelIndex = index;
        levelManager.LoadLevel(levels[index]);

        // TODO: Hide win popup, reset UI, camera, etc.
        levelManager.OnWin.RemoveListener(OnLevelWon);
        levelManager.OnWin.AddListener(OnLevelWon);
    }

    public void OnLevelWon()
    {
        // TODO: Show beautiful win popup with stars based on par moves
        Debug.Log("Show Win Screen! Stars: " + CalculateStars());

        // Example: auto-advance for quick testing
        // Invoke(nameof(NextLevel), 1.5f);
    }

    private int CalculateStars()
    {
        if (levelManager.currentLevel == null) return 1;
        int moves = levelManager.MoveCount;
        int par = levelManager.currentLevel.parMoves;

        if (moves <= par) return 3;
        if (moves <= par + 5) return 2;
        return 1;
    }

    public void NextLevel()
    {
        int next = currentLevelIndex + 1;
        if (next < levels.Length)
            StartLevel(next);
        else
            Debug.Log("All levels complete (or load more / go to level select).");
    }

    // These would be called from UI buttons
    public void RequestUndo() => levelManager.Undo();

    public void RestartLevel() => levelManager.ResetToInitial();
}