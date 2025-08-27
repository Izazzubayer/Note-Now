# Note Now

A native iOS Notes app built with SwiftUI that follows Apple's Human Interface Guidelines (HIG) with a true OLED black design and monochrome palette.

## Features

### 🎨 Design
- **True OLED Black Background** (#000000) for optimal battery life on OLED devices
- **Monochrome Palette** - Pure white, light grey, and dark grey only
- **HIG-Compliant** spacing, typography, and interaction patterns
- **Dynamic Type Support** with proper scaling and layout adaptation

### ✨ User Experience
- **Smooth Animations** - 60fps spring animations for the Add button morph
- **Haptic Feedback** - Light impact on tap and success feedback on save
- **Gesture Support** - Swipe to dismiss keyboard, intuitive interactions
- **Accessibility First** - Full VoiceOver support, WCAG AA contrast compliance

### 📱 Core Functionality
- **Notes List** - Clean, searchable list with creation timestamps
- **Add Note** - Floating action button with smooth morphing animation
- **Compose View** - Full-screen note creation with auto-focus
- **Search** - Real-time filtering across titles and content
- **Local Storage** - In-memory storage (ready for Core Data/SwiftData integration)

## Screenshots

### Notes List
- Full-bleed OLED black background
- Large "Notes" title with search field
- Vertically scrolling list of notes
- Each cell shows title, body preview, and creation timestamp
- Empty state with helpful guidance

### Compose Note
- Smooth morphing animation from Add button
- Title field with large, bold typography
- Multi-line body editor that grows with content
- Non-editable creation timestamp
- Cancel/Save actions with proper validation

## Technical Implementation

### Architecture
- **SwiftUI** - Modern declarative UI framework
- **MVVM Pattern** - Clean separation of concerns
- **ObservableObject** - Reactive data binding
- **@StateObject & @ObservedObject** - Proper lifecycle management

### Components
- `NotesListView` - Main list with search and empty states
- `NoteCellView` - Individual note display with truncation
- `ComposeNoteView` - Note creation with smooth transitions
- `AnimatedAddButton` - Morphing floating action button
- `NotesViewModel` - Data management and business logic

### Design System
- **Color Palette** - Monochrome with OLED black (#000000)
- **Typography** - SF Pro with Dynamic Type support
- **Spacing** - 8pt grid system following HIG
- **Animations** - Spring-based with proper easing curves

## Requirements

- **iOS 17.0+** - Latest SwiftUI features and APIs
- **Xcode 15.0+** - Modern development environment
- **Swift 5.9+** - Latest language features

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Izazzubayer/Note-Now.git
   ```

2. Open `Note Now.xcodeproj` in Xcode

3. Build and run on your device or simulator

## Project Structure

```
Note Now/
├── Models/
│   └── Note.swift                 # Data model with Codable support
├── Views/
│   ├── NotesListView.swift        # Main notes list with search
│   ├── NoteCellView.swift         # Individual note display
│   ├── ComposeNoteView.swift      # Note creation interface
│   └── AnimatedAddButton.swift    # Morphing add button
├── ViewModels/
│   └── NotesViewModel.swift       # Data management and business logic
├── Theme/
│   └── AppTheme.swift             # Design tokens and extensions
├── Preview Content/
│   └── PreviewData.swift          # Sample data for previews
├── Assets.xcassets/               # App icons and resources
└── Note_NowApp.swift              # App entry point
```

## Usage

### Creating Notes
1. Tap the floating + button (bottom-right)
2. Button smoothly morphs into compose view
3. Title field is automatically focused
4. Enter title and body content
5. Tap Save to create the note

### Managing Notes
- **Search** - Use the search field to filter notes
- **View** - Tap any note to view details (placeholder for future)
- **Delete** - Swipe left on notes to reveal delete action (future enhancement)

### Accessibility
- **VoiceOver** - Full screen reader support
- **Dynamic Type** - Text scales properly with system settings
- **High Contrast** - WCAG AA compliant contrast ratios
- **Haptic Feedback** - Tactile confirmation of actions

## Development

### Adding Features
1. Follow the existing MVVM architecture
2. Use the established design system tokens
3. Implement proper accessibility labels
4. Add previews for all new components

### Testing
- **Previews** - Comprehensive SwiftUI previews included
- **Dynamic Type** - Test with various text sizes
- **Accessibility** - Verify VoiceOver functionality
- **Performance** - Ensure 60fps animations

## Future Enhancements

- **Core Data Integration** - Persistent local storage
- **iCloud Sync** - Cross-device note synchronization
- **Rich Text** - Markdown support and formatting
- **Attachments** - Images, documents, and links
- **Categories** - Note organization and tagging
- **Export** - PDF, text, and sharing options

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Follow the existing code style and architecture
4. Add comprehensive previews and accessibility
5. Commit your changes (`git commit -m 'Add some amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## Design Principles

### Human Interface Guidelines
- **Clarity** - Clean, uncluttered interface
- **Deference** - Content takes precedence over chrome
- **Depth** - Subtle shadows and layering for hierarchy

### Accessibility
- **Perceivable** - High contrast, clear typography
- **Operable** - Full keyboard and gesture support
- **Understandable** - Intuitive interactions and feedback
- **Robust** - Works with assistive technologies

### Performance
- **60fps Animations** - Smooth, purposeful motion
- **Efficient Rendering** - Minimal view updates
- **Memory Management** - Proper lifecycle handling

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

**Izaz Zubayer** - [izazzubayer@gmail.com](mailto:izazzubayer@gmail.com)

**Project Link:** [https://github.com/Izazzubayer/Note-Now](https://github.com/Izazzubayer/Note-Now)

---

Built with ❤️ using SwiftUI and following Apple's Human Interface Guidelines
