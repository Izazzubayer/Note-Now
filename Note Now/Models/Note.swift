import Foundation

struct Note: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var body: String
    let createdAt: Date
    var isPinned: Bool
    var lastModified: Date
    var tags: Set<String>
    var folder: String?
    
    init(title: String, body: String) {
        self.id = UUID()
        self.title = title
        self.body = body
        self.createdAt = Date()
        self.isPinned = false
        self.lastModified = Date()
        self.tags = []
        self.folder = nil
    }
    
    init(id: UUID, title: String, body: String, createdAt: Date, isPinned: Bool = false, lastModified: Date? = nil, tags: Set<String> = [], folder: String? = nil) {
        self.id = id
        self.title = title
        self.body = body
        self.createdAt = createdAt
        self.isPinned = isPinned
        self.lastModified = lastModified ?? createdAt
        self.tags = tags
        self.folder = folder
    }
    
    // MARK: - Computed Properties
    var size: Int {
        return title.count + body.count
    }
    
    var ageGroup: AgeGroup {
        // Cache calendar instance for better performance
        let calendar = Calendar.current
        let now = Date()
        
        // Use more efficient date comparison methods
        if calendar.isDateInToday(createdAt) {
            return .today
        } else if calendar.isDateInYesterday(createdAt) {
            return .yesterday
        } else {
            // More efficient week comparison
            let weekOfYear = calendar.component(.weekOfYear, from: createdAt)
            let currentWeekOfYear = calendar.component(.weekOfYear, from: now)
            let year = calendar.component(.year, from: createdAt)
            let currentYear = calendar.component(.year, from: now)
            
            if year == currentYear && weekOfYear == currentWeekOfYear {
                return .thisWeek
            } else {
                return .older
            }
        }
    }
}

// MARK: - Age Group Enum
enum AgeGroup: String, CaseIterable {
    case today = "Today"
    case yesterday = "Yesterday"
    case thisWeek = "This Week"
    case older = "Older"
}

// MARK: - Sort Options
enum SortOption: String, CaseIterable {
    case lastEdited = "Last Edited"
    case createdDate = "Created Date"
    case titleAZ = "Title A→Z"
    case titleZA = "Title Z→A"
    case size = "Size"
    case manual = "Manual"
}

// MARK: - View Modes
enum ViewMode: String, CaseIterable {
    case list = "List"
    case grid = "Grid"
    case compact = "Compact"
    case twoPane = "Two Pane"
}

// MARK: - Density Settings
enum DensitySetting: String, CaseIterable {
    case comfortable = "Comfortable"
    case compact = "Compact"
}


