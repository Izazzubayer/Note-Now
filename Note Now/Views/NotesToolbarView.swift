import SwiftUI

struct NotesToolbarView: View {
    @ObservedObject var viewModel: NotesViewModel
    @Binding var searchText: String
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            // Search and View Controls Row
            HStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(AppTheme.tertiary)
                    
                    TextField("Search notes", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .foregroundColor(AppTheme.primary)
                }
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(AppTheme.surface)
                .cornerRadius(AppTheme.CornerRadius.medium)
                
                Spacer()
                
                // View Mode Picker
                Menu {
                    ForEach(ViewMode.allCases, id: \.self) { mode in
                        Button(mode.rawValue) {
                            viewModel.selectedViewMode = mode
                        }
                    }
                } label: {
                    Image(systemName: viewModeIcon)
                        .foregroundColor(AppTheme.primary)
                        .padding(AppTheme.Spacing.sm)
                        .background(AppTheme.surface)
                        .cornerRadius(AppTheme.CornerRadius.small)
                }
                
                // Density Picker
                Menu {
                    ForEach(DensitySetting.allCases, id: \.self) { density in
                        Button(density.rawValue) {
                            viewModel.selectedDensity = density
                        }
                    }
                } label: {
                    Image(systemName: "list.bullet")
                        .foregroundColor(AppTheme.primary)
                        .padding(AppTheme.Spacing.sm)
                        .background(AppTheme.surface)
                        .cornerRadius(AppTheme.CornerRadius.small)
                }
            }
            
            // Filter and Sort Controls Row
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: AppTheme.Spacing.sm) {
                    // Sort Picker
                    Menu {
                        ForEach(SortOption.allCases, id: \.self) { option in
                            Button(option.rawValue) {
                                viewModel.selectedSortOption = option
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "arrow.up.arrow.down")
                            Text(viewModel.selectedSortOption.rawValue)
                        }
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.primary)
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(AppTheme.surface)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                    }
                    
                    // Age Group Filter
                    if let selectedGrouping = viewModel.selectedGrouping {
                        Button(selectedGrouping.rawValue) {
                            viewModel.selectedGrouping = nil
                        }
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.primary)
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(AppTheme.primary)
                        .foregroundColor(AppTheme.background)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                    }
                    
                    // Folder Filter
                    if let selectedFolder = viewModel.selectedFolder {
                        Button(selectedFolder) {
                            viewModel.selectedFolder = nil
                        }
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.primary)
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(AppTheme.primary)
                        .foregroundColor(AppTheme.background)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                    }
                    
                    // Tag Filters
                    ForEach(Array(viewModel.selectedTags), id: \.self) { tag in
                        Button(tag) {
                            viewModel.selectedTags.remove(tag)
                        }
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.primary)
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(AppTheme.primary)
                        .foregroundColor(AppTheme.background)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                    }
                    
                    // Clear All Filters
                    if hasActiveFilters {
                        Button("Clear All") {
                            clearAllFilters()
                        }
                        .font(AppTheme.Typography.caption)
                        .foregroundColor(AppTheme.secondary)
                        .padding(.horizontal, AppTheme.Spacing.md)
                        .padding(.vertical, AppTheme.Spacing.sm)
                        .background(AppTheme.surface)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.md)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.md)
        .padding(.vertical, AppTheme.Spacing.sm)
        .background(AppTheme.background)
    }
    
    private var viewModeIcon: String {
        switch viewModel.selectedViewMode {
        case .list:
            return "list.bullet"
        case .grid:
            return "square.grid.2x2"
        case .compact:
            return "list.dash"
        case .twoPane:
            return "sidebar.left"
        }
    }
    
    private var hasActiveFilters: Bool {
        viewModel.selectedGrouping != nil ||
        viewModel.selectedFolder != nil ||
        !viewModel.selectedTags.isEmpty
    }
    
    private func clearAllFilters() {
        viewModel.selectedGrouping = nil
        viewModel.selectedFolder = nil
        viewModel.selectedTags.removeAll()
    }
}

#Preview {
    NotesToolbarView(
        viewModel: NotesViewModel.preview,
        searchText: .constant("")
    )
    .appBackground()
}
