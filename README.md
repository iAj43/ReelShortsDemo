# Reel Shorts Demo (iOS)
Single Page Reel Shorts App

## Features
- Reel Video Feed (like Instagram / YouTube Shorts)
- Single AVPlayer (performance optimized)
- Smooth scrolling (no lag)
- Video caching for offline playback
- Background download support
- Picture-in-Picture (PiP)
- Clean Architecture (MVVM)
- Unit Testing (ViewModel)

## Tech Stack
- SwiftUI
- AVPlayer
- URLSession (background)
- Async/Await

## Architecture
- MVVM
- Repository Pattern
- Dependency Injection

## Performance Optimizations
- Single shared player
- Lazy loading
- Pagination + Preloading
- Thumbnail placeholder strategy

## Caching Strategy
- Videos saved to Documents directory
- File existence check before playback

## How to Run
1. Open project in Xcode
2. Run on real device (PiP supported)
3. Scroll to experience reels

## Screenshots
<img width="1419" height="2796" alt="Simulator Screenshot - iPhone 16e - 2026-04-16 at 01 48 31-portrait" src="https://github.com/user-attachments/assets/06d5583e-7ccb-4df4-a972-e178aba95453" />

