import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    var title: String
    var body: String
    let createdAt: Date
    var isPinned: Bool
    var lastModified: Date
    
    init(title: String, body: String) {
        self.id = UUID()
        self.title = title
        self.body = body
        self.createdAt = Date()
        self.isPinned = false
        self.lastModified = Date()
    }
    
    init(id: UUID, title: String, body: String, createdAt: Date, isPinned: Bool = false, lastModified: Date? = nil) {
        self.id = id
        self.title = title
        self.body = body
        self.createdAt = createdAt
        self.isPinned = isPinned
        self.lastModified = lastModified ?? createdAt
    }
}

// MARK: - Preview Helpers
extension Note {
    static let sampleNotes = [
        Note(title: "Meeting Notes", body: "Discuss Q4 strategy and budget allocation. Team needs to prepare presentations for stakeholders. Follow up on action items from last meeting."),
        Note(title: "Shopping List", body: "Milk, bread, eggs, vegetables, fruits, and some snacks for the weekend."),
        Note(title: "Project Ideas", body: "Consider building a productivity app that integrates with existing tools. Research market demand and potential competitors."),
        Note(title: "Daily Reflection", body: "Today was productive. Completed the main task ahead of schedule. Need to plan tomorrow's priorities."),
        Note(title: "Book Recommendations", body: "The Pragmatic Programmer, Clean Code, Design Patterns, and Refactoring are must-reads for developers."),
        Note(title: "Travel Plans", body: "Planning a trip to Japan next spring. Research best time to visit, places to see, and cultural etiquette.")
    ]
}
