import SwiftUI

struct NoteCellView: View {
    let note: Note
    
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
            
            // Creation timestamp
            HStack {
                Image(systemName: "clock")
                    .font(.system(size: 12))
                    .appTertiaryText()
                
                Text(formattedTimestamp)
                    .font(AppTheme.Typography.footnote)
                    .appTertiaryText()
            }
            .accessibilityLabel("Created on \(formattedTimestamp)")
        }
        .padding(AppTheme.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(AppTheme.surface)
        .cornerRadius(AppTheme.CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .stroke(AppTheme.separator, lineWidth: 0.5)
        )
        .padding(.bottom, AppTheme.Spacing.sm)
    }
    
    private var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        
        return formatter.string(from: note.createdAt)
    }
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
