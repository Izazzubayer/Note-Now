import SwiftUI

struct NotesGridView: View {
    let notes: [Note]
    let density: DensitySetting
    let onNoteTap: (Note) -> Void
    
    private var columns: [GridItem] {
        let columnCount = density == .comfortable ? 2 : 3
        return Array(repeating: GridItem(.flexible(), spacing: AppTheme.Spacing.sm), count: columnCount)
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: AppTheme.Spacing.md) {
                ForEach(notes) { note in
                    NoteGridCellView(note: note, density: density)
                        .onTapGesture {
                            onNoteTap(note)
                        }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.sm)
        }
    }
}

struct NoteGridCellView: View {
    let note: Note
    let density: DensitySetting
    
    var body: some View {
        VStack(alignment: .leading, spacing: density == .comfortable ? AppTheme.Spacing.sm : AppTheme.Spacing.xs) {
            // Title
            Text(note.title.isEmpty ? "Untitled Note" : note.title)
                .font(density == .comfortable ? AppTheme.Typography.headline : AppTheme.Typography.subheadline)
                .appPrimaryText()
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            // Body preview
            if !note.body.isEmpty {
                Text(note.body)
                    .font(density == .comfortable ? AppTheme.Typography.body : AppTheme.Typography.caption)
                    .appSecondaryText()
                    .lineLimit(density == .comfortable ? 4 : 3)
                    .multilineTextAlignment(.leading)
            } else {
                Text("No content")
                    .font(density == .comfortable ? AppTheme.Typography.body : AppTheme.Typography.caption)
                    .appTertiaryText()
                    .italic()
            }
            
            Spacer()
            
            // Footer
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                // Tags
                if !note.tags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: AppTheme.Spacing.xs) {
                            ForEach(Array(note.tags), id: \.self) { tag in
                                Text(tag)
                                    .font(AppTheme.Typography.caption2)
                                    .appTertiaryText()
                                    .padding(.horizontal, AppTheme.Spacing.xs)
                                    .padding(.vertical, 2)
                                    .background(AppTheme.quaternary)
                                    .cornerRadius(AppTheme.CornerRadius.small)
                            }
                        }
                    }
                }
                
                // Timestamps
                HStack {
                    if note.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.system(size: 10))
                            .appPrimaryText()
                    }
                    
                    Text(note.lastModified, style: .relative)
                        .font(AppTheme.Typography.caption2)
                        .appTertiaryText()
                    
                    Spacer()
                    
                    if let folder = note.folder {
                        Text(folder)
                            .font(AppTheme.Typography.caption2)
                            .appTertiaryText()
                    }
                }
            }
        }
        .padding(density == .comfortable ? AppTheme.Spacing.md : AppTheme.Spacing.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(minHeight: density == .comfortable ? 200 : 150)
        .background(AppTheme.surface)
        .cornerRadius(AppTheme.CornerRadius.medium)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                .stroke(AppTheme.separator, lineWidth: 0.5)
        )
    }
}

#Preview {
    VStack {
        Text("Comfortable Density")
            .font(AppTheme.Typography.headline)
            .appPrimaryText()
        
        NotesGridView(
            notes: Note.previewNotes,
            density: .comfortable
        ) { note in
            print("Tapped note: \(note.title)")
        }
        
        Text("Compact Density")
            .font(AppTheme.Typography.headline)
            .appPrimaryText()
        
        NotesGridView(
            notes: Note.previewNotes,
            density: .compact
        ) { note in
            print("Tapped note: \(note.title)")
        }
    }
    .appBackground()
}
