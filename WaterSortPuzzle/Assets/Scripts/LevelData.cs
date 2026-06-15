// Assets/Scripts/LevelData.cs
// ScriptableObject + plain data for levels.
// Use these to author levels in the editor or load from JSON at runtime.

using System;
using UnityEngine;

[CreateAssetMenu(fileName = "New LevelData", menuName = "WaterSort/LevelData")]
public class LevelData : ScriptableObject
{
    public int id = 1;
    public string levelName = "Level 1";
    [TextArea] public string hint = "";

    [Range(1, 60)]
    public int parMoves = 8;          // "Perfect" move count for 3 stars

    public TubeState[] tubes;         // The initial configuration

    [Serializable]
    public class TubeState
    {
        public ColorID[] layers; // bottom (index 0) to top (last)
    }

    /// <summary>
    /// Quick validation in editor.
    /// </summary>
    private void OnValidate()
    {
        if (tubes == null) return;
        foreach (var t in tubes)
        {
            if (t.layers != null && t.layers.Length > 4)
            {
                Debug.LogWarning($"Level {id}: Tube has more than 4 layers.");
            }
        }
    }

    /// <summary>
    /// Helper to create a runtime deep copy of the tube data.
    /// </summary>
    public TubeState[] GetInitialTubeStates()
    {
        if (tubes == null) return Array.Empty<TubeState>();
        var copy = new TubeState[tubes.Length];
        for (int i = 0; i < tubes.Length; i++)
        {
            copy[i] = new TubeState
            {
                layers = tubes[i].layers != null ? (ColorID[])tubes[i].layers.Clone() : Array.Empty<ColorID>()
            };
        }
        return copy;
    }
}
