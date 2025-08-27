import Foundation
import SwiftUI

@MainActor
class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var selectedSortOption: SortOption = .lastEdited
    @Published var selectedViewMode: ViewMode = .list
    @Published var selectedDensity: DensitySetting = .comfortable
    @Published var selectedGrouping: AgeGroup? = nil
    @Published var selectedFolder: String? = nil
    @Published var selectedTags: Set<String> = []
    
    init() {
        // Load sample notes for prototype
        notes = Note.previewNotes
    }
    
    func addNote(_ note: Note) {
        notes.insert(note, at: 0) // Add to top
    }
    
    func deleteNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes.remove(at: index)
        }
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            var updatedNote = note
            updatedNote.lastModified = Date()
            notes[index] = updatedNote
        }
    }
    
    func togglePin(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].isPinned.toggle()
            notes[index].lastModified = Date()
        }
    }
    
    func filteredNotes(searchText: String) -> [Note] {
        var filtered = notes
        
        // Apply search filter
        if !searchText.isEmpty {
            filtered = filtered.filter { note in
                note.title.localizedCaseInsensitiveContains(searchText) ||
                note.body.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        // Apply folder filter
        if let selectedFolder = selectedFolder {
            filtered = filtered.filter { $0.folder == selectedFolder }
        }
        
        // Apply tag filter
        if !selectedTags.isEmpty {
            filtered = filtered.filter { note in
                !note.tags.isDisjoint(with: selectedTags)
            }
        }
        
        // Apply age grouping
        if let selectedGrouping = selectedGrouping {
            filtered = filtered.filter { $0.ageGroup == selectedGrouping }
        }
        
        // Sort notes
        let sorted = sortNotes(filtered)
        
        // Always put pinned notes at the top
        return sorted.sorted { note1, note2 in
            if note1.isPinned != note2.isPinned {
                return note1.isPinned
            }
            return true
        }
    }
    
    private func sortNotes(_ notes: [Note]) -> [Note] {
        switch selectedSortOption {
        case .lastEdited:
            return notes.sorted { $0.lastModified > $1.lastModified }
        case .createdDate:
            return notes.sorted { $0.createdAt > $1.createdAt }
        case .titleAZ:
            return notes.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        case .titleZA:
            return notes.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedDescending }
        case .size:
            return notes.sorted { $0.size > $1.size }
        case .manual:
            return notes // Keep current order for manual sorting
        }
    }
    
    func clearAllNotes() {
        notes.removeAll()
    }
    
    // MARK: - Computed Properties
    var availableFolders: [String] {
        let folders = notes.compactMap { $0.folder }
        return Array(Set(folders)).sorted()
    }
    
    var availableTags: [String] {
        let allTags = notes.flatMap { $0.tags }
        return Array(Set(allTags)).sorted()
    }
    
    var recentNotes: [Note] {
        let calendar = Calendar.current
        let now = Date()
        let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        
        return notes.filter { note in
            note.lastModified >= oneWeekAgo
        }.sorted { $0.lastModified > $1.lastModified }
    }
}

// MARK: - Preview Helper
extension NotesViewModel {
    static var preview: NotesViewModel {
        let viewModel = NotesViewModel()
        viewModel.notes = Note.previewNotes
        return viewModel
    }
}
