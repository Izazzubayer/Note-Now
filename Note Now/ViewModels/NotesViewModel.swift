import Foundation
import SwiftUI

@MainActor
class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    
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
        let filtered = searchText.isEmpty ? notes : notes.filter { note in
            note.title.localizedCaseInsensitiveContains(searchText) ||
            note.body.localizedCaseInsensitiveContains(searchText)
        }
        
        // Sort: pinned notes first, then by last modified date
        return filtered.sorted { note1, note2 in
            if note1.isPinned != note2.isPinned {
                return note1.isPinned
            }
            return note1.lastModified > note2.lastModified
        }
    }
    
    func clearAllNotes() {
        notes.removeAll()
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
