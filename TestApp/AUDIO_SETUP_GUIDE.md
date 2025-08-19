# Audio File Setup Guide

## How to Add Audio Files to Your Xcode Project

### Step 1: Add Audio File to Xcode Project
1. **Drag and Drop**: Drag your `calm_ambient.mp3` file into your Xcode project
2. **Target Membership**: Make sure to check your app target in the dialog that appears
3. **Copy Items**: Choose "Copy items if needed" and "Create groups"

### Step 2: Verify File is in Bundle
1. **Project Navigator**: Click on your project in the left sidebar
2. **Target**: Select your app target
3. **Build Phases**: Click on "Build Phases" tab
4. **Copy Bundle Resources**: Expand this section and verify `calm_ambient.mp3` is listed

### Step 3: Check File Path
The file should appear in your project like this:
```
TestApp/
├── TestApp/
│   ├── calm_ambient.mp3  ← Your audio file should be here
│   ├── Views/
│   ├── Models/
│   └── ...
```

### Step 4: Clean and Rebuild
1. **Product → Clean Build Folder** (Cmd+Shift+K)
2. **Product → Build** (Cmd+B)
3. **Run** your app again

## Common Issues and Solutions

### Issue: "Audio file not found in bundle"
**Solution**: The file isn't properly added to the app bundle
- Re-add the file to Xcode
- Check target membership
- Clean and rebuild

### Issue: "Failed to load audio file"
**Solution**: File format or corruption issue
- Verify the MP3 file plays in other apps
- Try converting to a different format (WAV, M4A)
- Check file size (should be reasonable, not 0 bytes)

### Issue: Still getting generated audio
**Solution**: The real file isn't being loaded
- Check console logs for "Successfully loaded audio file"
- Verify the filename matches exactly: `calm_ambient.mp3`

## Testing Audio Loading

When you run the app, check the console for these messages:
- ✅ `"Successfully loaded audio file: calm_ambient.mp3"` - File loaded successfully
- ❌ `"Audio file not found in bundle: calm_ambient.mp3"` - File not in bundle
- ❌ `"Failed to load audio file calm_ambient.mp3: [error]"` - File loading failed

## Alternative: Use Different Audio Format

If MP3 continues to cause issues, try:
1. Convert to WAV format
2. Update the extension in `musicOptions` dictionary
3. Update the `loadAudioFile` method to use `.wav` extension

## Need Help?

If you're still having issues:
1. Check the console output for specific error messages
2. Verify the file is actually in your app bundle
3. Try with a different audio file to isolate the issue
