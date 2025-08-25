# TestApp - Bhagavad Gita Reader

A SwiftUI iOS application that provides a beautiful interface for reading the Bhagavad Gita with Nepali translations and explanations.

## Features

### 🏠 Home Tab
- Main landing page with various features

### 📖 Gita Tab (Read Page)
- **Chapter Grid View**: Displays all chapters in a beautiful 2-column grid layout
- **Chapter Cards**: Each chapter shows the chapter number and sloka count
- **Chapter Detail View**: When a chapter is selected, shows:
  - Chapter header with number and total slokas
  - Sloka selector (horizontal scrollable buttons for chapters with multiple slokas)
  - Current sloka text in Sanskrit/Devanagari
  - Detailed explanation in Nepali
  - Navigation controls to move between slokas within a chapter

### ❤️ Favorites Tab
- Manage your favorite quotes and content

## Technical Details

### Data Structure
The app reads from `slokas_nepali.json` which contains:
- `id`: Chapter number
- `sloka`: Array of Sanskrit slokas
- `explanation`: Array of Nepali explanations (corresponding to each sloka)

### Architecture
- **Models**: `SlokaChapter`, `SlokaData`
- **ViewModels**: `SlokaViewModel` for data management
- **Views**: `ChapterGridView`, `ChapterDetailView`
- **Features**: Lazy loading, error handling, beautiful UI with gradients and shadows

### UI Design
- Modern card-based design with rounded corners and shadows
- Orange-to-red gradient theme for chapter numbers
- Responsive grid layout that adapts to different screen sizes
- Smooth animations and transitions
- Intuitive navigation with clear visual feedback

## Usage

1. **Navigate to Gita Tab**: Tap the "Gita" tab in the bottom navigation
2. **Select a Chapter**: Tap on any chapter card to view its contents
3. **Read Slokas**: Use the sloka selector buttons to navigate between different slokas within a chapter
4. **Close Chapter**: Tap the X button to return to the chapter grid

## Requirements

- iOS 15.0+
- SwiftUI
- Xcode 13.0+

## Installation

1. Clone the repository
2. Open `TestApp.xcodeproj` in Xcode
3. Build and run on your device or simulator

## Data Source

The slokas and explanations are sourced from authentic Bhagavad Gita translations and commentaries, providing users with both the original Sanskrit text and comprehensive Nepali explanations.
