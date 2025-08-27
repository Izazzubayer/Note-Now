import Foundation

// MARK: - Preview Data
struct PreviewData {
    static let sampleNotes = [
        Note(title: "Meeting Notes", body: "Discuss Q4 strategy and budget allocation. Team needs to prepare presentations for stakeholders. Follow up on action items from last meeting."),
        Note(title: "Shopping List", body: "Milk, bread, eggs, vegetables, fruits, and some snacks for the weekend."),
        Note(title: "Project Ideas", body: "Consider building a productivity app that integrates with existing tools. Research market demand and potential competitors."),
        Note(title: "Daily Reflection", body: "Today was productive. Completed the main task ahead of schedule. Need to plan tomorrow's priorities."),
        Note(title: "Book Recommendations", body: "The Pragmatic Programmer, Clean Code, Design Patterns, and Refactoring are must-reads for developers."),
        Note(title: "Travel Plans", body: "Planning a trip to Japan next spring. Research best time to visit, places to see, and cultural etiquette."),
        Note(title: "Code Snippets", body: "Remember to use SwiftUI's @StateObject for view models and @ObservedObject for child views. Always implement proper accessibility labels."),
        Note(title: "Design Principles", body: "Follow Apple's Human Interface Guidelines. Use consistent spacing with the 8pt grid system. Ensure proper contrast ratios for accessibility.")
    ]
    
    static let emptyNotes: [Note] = []
    
    static let longNote = Note(
        title: "Very Long Note Title That Might Exceed Normal Length and Need Truncation",
        body: "This is a very long note body that contains multiple sentences and should demonstrate how the text truncation works in the UI. The note cell should handle this gracefully by showing only the first few lines and then truncating with ellipsis. This ensures that the UI remains clean and consistent regardless of content length. Users can tap on the note to see the full content in the detail view."
    )
    
    static let shortNote = Note(
        title: "Short",
        body: "Brief content."
    )
    
    static let emptyNote = Note(
        title: "",
        body: ""
    )
}

// MARK: - Preview Helpers
extension Note {
    static let previewNotes = PreviewData.sampleNotes
    static let previewEmptyNotes = PreviewData.emptyNotes
    static let previewLongNote = PreviewData.longNote
    static let previewShortNote = PreviewData.shortNote
    static let previewEmptyNote = PreviewData.emptyNote
}
