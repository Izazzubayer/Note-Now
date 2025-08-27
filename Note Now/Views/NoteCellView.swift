import SwiftUI

struct NoteCellView: View {
    let note: Note
    
    // MARK: - Cached Properties
    private var formattedTimestamp: String {
        NoteCellView.dateFormatter.string(from: note.createdAt)
    }
    
    private var formattedLastModified: String {
        NoteCellView.shortDateFormatter.string(from: note.lastModified)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            // Title
            Text(note.title.isEmpty ? "Untitled Note" : note.title)
                .font(AppTheme.Typography.headline)
                .appPrimaryText()
                .lineLimit(1)
                .accessibilityLabel("Note title: \(note.title.isEmpty ? "Untitled Note" : note.title)")
            
            // Body preview (first line, truncated)
            if !note.body.isEmpty {
                Text(note.body)
                    .font(AppTheme.Typography.body)
                    .appSecondaryText()
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .accessibilityLabel("Note content: \(note.body)")
            } else {
                Text("No content")
                    .font(AppTheme.Typography.body)
                    .appTertiaryText()
                    .italic()
                    .accessibilityLabel("Note has no content")
            }
            
            // Timestamps and pin status
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                // Creation date and pin status
                HStack {
                    if note.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.system(size: 12))
                            .appPrimaryText()
                    }
                    
                    Image(systemName: "clock")
                        .font(.system(size: 12))
                        .appTertiaryText()
                    
                    Text(formattedTimestamp)
                        .font(AppTheme.Typography.footnote)
                        .appTertiaryText()
                    
                    Spacer()
                }
                
                // Modified date (if different from creation)
                if note.lastModified != note.createdAt {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .font(.system(size: 12))
                            .appTertiaryText()
                        
                        Text("Modified \(formattedLastModified)")
                            .font(AppTheme.Typography.footnote)
                            .appTertiaryText()
                        
                        Spacer()
                    }
                }
            }
            .accessibilityLabel("Created on \(formattedTimestamp)\(note.isPinned ? ", pinned" : "")")
        }
        .padding(AppTheme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.surface)
        .cornerRadius(AppTheme.CornerRadius.medium)

        .padding(.bottom, AppTheme.Spacing.sm)
    }
    
}

// MARK: - Static Date Formatters (Cached)
extension NoteCellView {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter
    }()
    
    private static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter
    }()
}

#Preview("Note Cell") {
    VStack(spacing: AppTheme.Spacing.md) {
        NoteCellView(note: Note.previewNotes[0])
        NoteCellView(note: Note.previewNotes[1])
        NoteCellView(note: Note.previewEmptyNote)
    }
    .padding()
    .appBackground()
}

#Preview("Note Cell - Large Text") {
    VStack(spacing: AppTheme.Spacing.md) {
        NoteCellView(note: Note.previewNotes[0])
        NoteCellView(note: Note.previewNotes[1])
    }
    .padding()
    .appBackground()
    .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
}
