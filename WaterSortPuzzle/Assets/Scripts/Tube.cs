// Assets/Scripts/Tube.cs
// Core Tube logic for Water Sort Puzzle.
// Attach to a GameObject that represents one tube/vial.
// Keeps pure data + rules. Visuals in TubeVisual.cs.

using System;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class TubeState
{
    public List<ColorID> layers = new List<ColorID>(); // index 0 = bottom, last = top
}

public class Tube : MonoBehaviour
{
    public int Capacity = 4;

    [SerializeField] private List<ColorID> layers = new List<ColorID>(); // runtime data

    public IReadOnlyList<ColorID> Layers => layers;

    public bool IsEmpty => layers.Count == 0;

    public ColorID? TopColor => IsEmpty ? (ColorID?)null : layers[layers.Count - 1];

    public int FillCount => layers.Count;

    public bool IsFull => layers.Count >= Capacity;

    public event Action<Tube> OnStateChanged;

    /// <summary>
    /// Returns how many layers of the current top color can be poured (consecutive from top).
    /// </summary>
    public int GetPourableAmount()
    {
        if (IsEmpty) return 0;
        var top = TopColor.Value;
        int count = 0;
        for (int i = layers.Count - 1; i >= 0; i--)
        {
            if (layers[i] == top) count++;
            else break;
        }
        return count;
    }

    public bool CanPourInto(Tube other)
    {
        if (IsEmpty) return false;
        if (other.IsFull) return false;
        if (other.IsEmpty) return true;
        return other.TopColor == this.TopColor;
    }

    /// <summary>
    /// Pours as many layers as possible from this tube into the destination.
    /// Returns true if any layers were moved.
    /// </summary>
    public bool PourInto(Tube other)
    {
        if (!CanPourInto(other)) return false;

        int available = GetPourableAmount();
        int space = other.Capacity - other.layers.Count;
        int toMove = Mathf.Min(available, space);

        if (toMove <= 0) return false;

        var color = TopColor.Value;

        // Remove from this (top down)
        for (int i = 0; i < toMove; i++)
        {
            layers.RemoveAt(layers.Count - 1);
        }

        // Add to other (on top)
        for (int i = 0; i < toMove; i++)
        {
            other.layers.Add(color);
        }

        OnStateChanged?.Invoke(this);
        other.OnStateChanged?.Invoke(other);

        return true;
    }

    /// <summary>
    /// Completely replace the tube contents (used for loading levels / undo).
    /// </summary>
    public void SetLayers(IEnumerable<ColorID> newLayers)
    {
        layers.Clear();
        if (newLayers != null)
            layers.AddRange(newLayers);

        if (layers.Count > Capacity)
            layers.RemoveRange(Capacity, layers.Count - Capacity);

        OnStateChanged?.Invoke(this);
    }

    public TubeState GetState()
    {
        return new TubeState { layers = new List<ColorID>(layers) };
    }

    public void LoadState(TubeState state)
    {
        SetLayers(state?.layers);
    }

    // Editor / debug helper
    private void OnValidate()
    {
        if (layers.Count > Capacity)
            layers.RemoveRange(Capacity, layers.Count - Capacity);
    }
}

public enum ColorID
{
    None = 0,
    Red = 1,
    Blue = 2,
    Green = 3,
    Yellow = 4,
    Purple = 5,
    Cyan = 6,
    Orange = 7,
    Magenta = 8,
    // Extend as needed. Keep values stable for serialization.
}
