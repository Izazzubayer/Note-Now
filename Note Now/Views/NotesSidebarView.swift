import SwiftUI

struct NotesSidebarView: View {
    @ObservedObject var viewModel: NotesViewModel
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Header
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("Filters")
                    .font(AppTheme.Typography.headline)
                    .appPrimaryText()
                
                Text("Organize your notes")
                    .font(AppTheme.Typography.caption)
                    .appSecondaryText()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, AppTheme.Spacing.md)
            
            // Recent Section
            if !viewModel.recentNotes.isEmpty {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text("Recent")
                        .font(AppTheme.Typography.subheadline)
                        .appPrimaryText()
                        .padding(.horizontal, AppTheme.Spacing.md)
                    
                    ForEach(viewModel.recentNotes.prefix(5)) { note in
                        Button {
                            // TODO: Navigate to note
                        } label: {
                            HStack {
                                Text(note.title.isEmpty ? "Untitled Note" : note.title)
                                    .font(AppTheme.Typography.caption)
                                    .appSecondaryText()
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                Text(note.lastModified, style: .relative)
                                    .font(AppTheme.Typography.caption2)
                                    .appTertiaryText()
                            }
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.vertical, AppTheme.Spacing.xs)
                            .background(AppTheme.surface)
                            .cornerRadius(AppTheme.CornerRadius.small)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            // Age Groups
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("Time")
                    .font(AppTheme.Typography.subheadline)
                    .appPrimaryText()
                    .padding(.horizontal, AppTheme.Spacing.md)
                
                ForEach(AgeGroup.allCases, id: \.self) { group in
                    Button {
                        viewModel.selectedGrouping = viewModel.selectedGrouping == group ? nil : group
                    } label: {
                        HStack {
                            Text(group.rawValue)
                                .font(AppTheme.Typography.caption)
                                .foregroundColor(viewModel.selectedGrouping == group ? AppTheme.background : AppTheme.secondary)
                            
                            Spacer()
                            
                            if viewModel.selectedGrouping == group {
                                Image(systemName: "checkmark")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.background)
                            }
                        }
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(viewModel.selectedGrouping == group ? AppTheme.primary : AppTheme.surface)
                        .cornerRadius(AppTheme.CornerRadius.small)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            
            // Folders
            if !viewModel.availableFolders.isEmpty {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text("Folders")
                        .font(AppTheme.Typography.subheadline)
                        .appPrimaryText()
                        .padding(.horizontal, AppTheme.Spacing.md)
                    
                    ForEach(viewModel.availableFolders, id: \.self) { folder in
                        Button {
                            viewModel.selectedFolder = viewModel.selectedFolder == folder ? nil : folder
                        } label: {
                            HStack {
                                Image(systemName: "folder")
                                    .font(.caption)
                                    .foregroundColor(AppTheme.tertiary)
                                
                                Text(folder)
                                    .font(AppTheme.Typography.caption)
                                    .foregroundColor(viewModel.selectedFolder == folder ? AppTheme.background : AppTheme.secondary)
                                
                                Spacer()
                                
                                if viewModel.selectedFolder == folder {
                                    Image(systemName: "checkmark")
                                        .font(.caption)
                                        .foregroundColor(AppTheme.background)
                                }
                            }
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.vertical, AppTheme.Spacing.sm)
                            .background(viewModel.selectedFolder == folder ? AppTheme.primary : AppTheme.surface)
                            .cornerRadius(AppTheme.CornerRadius.small)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            
            // Tags
            if !viewModel.availableTags.isEmpty {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text("Tags")
                        .font(AppTheme.Typography.subheadline)
                        .appPrimaryText()
                        .padding(.horizontal, AppTheme.Spacing.md)
                    
                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 80), spacing: AppTheme.Spacing.xs)
                    ], spacing: AppTheme.Spacing.xs) {
                        ForEach(viewModel.availableTags, id: \.self) { tag in
                            Button {
                                if viewModel.selectedTags.contains(tag) {
                                    viewModel.selectedTags.remove(tag)
                                } else {
                                    viewModel.selectedTags.insert(tag)
                                }
                            } label: {
                                Text(tag)
                                    .font(AppTheme.Typography.caption2)
                                    .foregroundColor(viewModel.selectedTags.contains(tag) ? AppTheme.background : AppTheme.secondary)
                                    .padding(.horizontal, AppTheme.Spacing.sm)
                                    .padding(.vertical, AppTheme.Spacing.xs)
                                    .background(viewModel.selectedTags.contains(tag) ? AppTheme.primary : AppTheme.surface)
                                    .cornerRadius(AppTheme.CornerRadius.small)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.md)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, AppTheme.Spacing.md)
        .background(AppTheme.background)
    }
}

#Preview {
    NotesSidebarView(viewModel: NotesViewModel.preview)
        .appBackground()
}
