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
