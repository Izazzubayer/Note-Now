import SwiftUI

struct NotesListView: View {
    @StateObject private var viewModel = NotesViewModel()
    @State private var searchText = ""
    @State private var showingCompose = false
    @State private var selectedNote: Note?
    @State private var showingEditNote = false
    @State private var showingSidebar = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Full-bleed OLED black background
                AppTheme.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with title
                    VStack(spacing: AppTheme.Spacing.md) {
                        // Large "Notes" title
                        Text("Notes")
                            .font(AppTheme.Typography.largeTitle)
                            .fontWeight(.bold)
                            .appPrimaryText()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, AppTheme.Spacing.lg)
                            .padding(.top, AppTheme.Spacing.md)
                        
                        // Search bar and sorting controls
                        HStack(spacing: AppTheme.Spacing.md) {
                            // Search bar
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(AppTheme.tertiary)
                                
                                TextField("Search notes", text: $searchText)
                                    .textFieldStyle(PlainTextFieldStyle())
                                    .foregroundColor(AppTheme.primary)
                                    .onChange(of: searchText) { _, newValue in
                                        // Debounce search to improve performance
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                            if searchText == newValue && !newValue.isEmpty {
                                                HapticManager.shared.lightImpact()
                                            }
                                        }
                                    }
                                    .onSubmit {
                                        // Trigger immediate search on submit
                                        HapticManager.shared.lightImpact()
                                    }
                            }
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.vertical, AppTheme.Spacing.sm)
                            .background(AppTheme.surface)
                            .cornerRadius(AppTheme.CornerRadius.medium)
                            
                            // Sort button
                            Menu {
                                ForEach(SortOption.allCases, id: \.self) { option in
                                    Button(option.rawValue) {
                                        HapticManager.shared.selectionChanged()
                                        viewModel.selectedSortOption = option
                                    }
                                }
                            } label: {
                                Image(systemName: "arrow.up.arrow.down")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(AppTheme.primary)
                            }
                        }
                        .padding(.horizontal, AppTheme.Spacing.lg)
                    }
                    .padding(.bottom, AppTheme.Spacing.md)
                    
                    // Notes content
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
                        List {
                            ForEach(viewModel.filteredNotes(searchText: searchText), id: \.id) { note in
                                NoteCellView(note: note)
                                    .onTapGesture {
                                        HapticManager.shared.mediumImpact()
                                        withAnimation(.easeInOut(duration: 0.2)) {
                                            selectedNote = note
                                            showingEditNote = true
                                        }
                                    }
                                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                        Button(note.isPinned ? "Unpin" : "Pin") {
                                            HapticManager.shared.pinPattern()
                                            viewModel.togglePin(note)
                                        }
                                        .tint(note.isPinned ? AppTheme.tertiary : AppTheme.primary)
                                    }
                                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                        Button("Delete", role: .destructive) {
                                            HapticManager.shared.deletePattern()
                                            viewModel.deleteNote(note)
                                        }
                                    }
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                    .listRowInsets(EdgeInsets(top: AppTheme.Spacing.sm, leading: AppTheme.Spacing.lg, bottom: AppTheme.Spacing.sm, trailing: AppTheme.Spacing.lg))
                            }
                        }
                        .listStyle(PlainListStyle())
                        .background(Color.clear)
                    }
                }
                
                // Floating Add button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        
                        AnimatedAddButton {
                            HapticManager.shared.mediumImpact()
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
                .transition(.move(edge: .bottom).combined(with: .opacity))
        }
        .animation(.easeInOut(duration: 0.3), value: showingCompose)
        .sheet(isPresented: $showingEditNote) {
            if let note = selectedNote {
                EditNoteView(note: note, viewModel: viewModel)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showingEditNote)
        .onChange(of: searchText) { _, _ in
            // Trigger view update when search text changes
        }
        .preferredColorScheme(.dark) // Force dark mode for OLED black
    }
}

#Preview {
    NotesListView()
}
