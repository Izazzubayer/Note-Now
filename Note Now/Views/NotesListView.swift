import SwiftUI

struct NotesListView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var searchText = ""
    @State private var showingCompose = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Full-bleed OLED black background
                AppTheme.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with title and search
                    VStack(spacing: AppTheme.Spacing.md) {
                        // Large "Notes" title
                        Text("Notes")
                            .font(AppTheme.Typography.largeTitle)
                            .fontWeight(.bold)
                            .appPrimaryText()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, AppTheme.Spacing.lg)
                            .padding(.top, AppTheme.Spacing.md)
                        
                        // Search field
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(AppTheme.tertiary)
                                .font(.system(size: 17))
                            
                            TextField("Search notes", text: $searchText)
                                .font(AppTheme.Typography.body)
                                .appPrimaryText()
                                .textFieldStyle(PlainTextFieldStyle())
                            
                            if !searchText.isEmpty {
                                Button(action: {
                                    searchText = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(AppTheme.tertiary)
                                        .font(.system(size: 17))
                                }
                                .accessibilityLabel("Clear search")
                            }
                        }
                        .padding(AppTheme.Spacing.md)
                        .background(AppTheme.surface)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                        .padding(.horizontal, AppTheme.Spacing.lg)
                    }
                    .padding(.bottom, AppTheme.Spacing.md)
                    
                    // Notes list
                    if viewModel.filteredNotes(searchText: searchText).isEmpty {
                        // Empty state
                        VStack(spacing: AppTheme.Spacing.lg) {
                            Spacer()
                            
                            Image(systemName: "note.text")
                                .font(.system(size: 48, weight: .light))
                                .appTertiaryText()
                            
                            Text("No notes yet")
                                .font(AppTheme.Typography.title3)
                                .appPrimaryText()
                            
                            Text("Tap the + button to create your first note")
                                .font(AppTheme.Typography.body)
                                .appSecondaryText()
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                        }
                        .padding(.horizontal, AppTheme.Spacing.lg)
                    } else {
                        // Notes list
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(viewModel.filteredNotes(searchText: searchText)) { note in
                                    NoteCellView(note: note)
                                        .onTapGesture {
                                            // Handle note selection
                                        }
                                }
                            }
                            .padding(.horizontal, AppTheme.Spacing.lg)
                        }
                    }
                }
                
                // Floating Add button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        AnimatedAddButton {
                            withAnimation(AppTheme.Animation.spring) {
                                showingCompose = true
                            }
                        }
                        .padding(.trailing, AppTheme.Spacing.lg)
                        .padding(.bottom, AppTheme.Spacing.lg)
                    }
                }
            }
        }
        .sheet(isPresented: $showingCompose) {
            ComposeNoteView(viewModel: viewModel)
        }
        .preferredColorScheme(.dark) // Force dark mode for OLED black
    }
}

#Preview {
    NotesListView()
}
