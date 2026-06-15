// Assets/Scripts/LevelManager.cs
// Central controller for a single level.
// Manages tube instances, move history (for undo), win detection.

using System;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class LevelManager : MonoBehaviour
{
    [Header("References")]
    public List<Tube> tubes = new List<Tube>();

    [Header("Current Level")]
    public LevelData currentLevel;

    [Header("Events (wire to UI)")]
    public UnityEvent OnWin;
    public UnityEvent<int> OnMovesChanged;   // current move count

    private int moveCount = 0;
    private readonly Stack<TubeState[]> undoStack = new Stack<TubeState[]>();

    public int MoveCount => moveCount;
    public bool IsSolved { get; private set; }

    public void LoadLevel(LevelData levelData)
    {
        if (levelData == null)
        {
            Debug.LogError("LevelData is null");
            return;
        }

        currentLevel = levelData;
        moveCount = 0;
        undoStack.Clear();
        IsSolved = false;

        var initial = levelData.GetInitialTubeStates();

        // Make sure we have enough Tube components
        while (tubes.Count < initial.Length)
        {
            // In a real project you would instantiate prefabs instead.
            Debug.LogWarning("Not enough Tube references in LevelManager. Add more in the inspector or spawn dynamically.");
            break;
        }

        for (int i = 0; i < initial.Length && i < tubes.Count; i++)
        {
            tubes[i].LoadState(initial[i]);
            tubes[i].OnStateChanged -= OnTubeChanged; // prevent duplicates
            tubes[i].OnStateChanged += OnTubeChanged;
        }

        // Save initial state for undo (optional first snapshot)
        PushUndoState();
        OnMovesChanged?.Invoke(moveCount);
    }

    private void OnTubeChanged(Tube changedTube)
    {
        // Called after any successful pour
    }

    public bool TryPour(Tube from, Tube to)
    {
        if (IsSolved || from == null || to == null || from == to)
            return false;

        // Save state before the move
        PushUndoState();

        bool moved = from.PourInto(to);
        if (moved)
        {
            moveCount++;
            OnMovesChanged?.Invoke(moveCount);
            CheckWinCondition();
        }
        else
        {
            // Revert the undo push since move didn't happen
            if (undoStack.Count > 0) undoStack.Pop();
        }

        return moved;
    }

    public void Undo()
    {
        if (undoStack.Count <= 1) // keep at least the initial state
            return;

        undoStack.Pop(); // discard current
        var previous = undoStack.Peek();

        for (int i = 0; i < previous.Length && i < tubes.Count; i++)
        {
            tubes[i].LoadState(previous[i]);
        }

        moveCount = Mathf.Max(0, moveCount - 1);
        OnMovesChanged?.Invoke(moveCount);
        IsSolved = false;
    }

    private void PushUndoState()
    {
        var snapshot = new TubeState[tubes.Count];
        for (int i = 0; i < tubes.Count; i++)
        {
            snapshot[i] = tubes[i].GetState();
        }
        undoStack.Push(snapshot);
    }

    private void CheckWinCondition()
    {
        foreach (var tube in tubes)
        {
            if (tube.IsEmpty) continue;

            if (!tube.IsFull) return;

            // All layers must be the same color
            var first = tube.Layers[0];
            foreach (var layer in tube.Layers)
            {
                if (layer != first) return;
            }
        }

        // If we reached here, every non-empty tube is full mono-color
        IsSolved = true;
        OnWin?.Invoke();
        Debug.Log($"Level solved in {moveCount} moves!");
    }

    // Helper for procedural / debug
    public void ResetToInitial()
    {
        if (currentLevel == null) return;
        LoadLevel(currentLevel);
    }
}