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
            notes[index] = note
        }
    }
    
    func filteredNotes(searchText: String) -> [Note] {
        if searchText.isEmpty {
            return notes
        }
        
        return notes.filter { note in
            note.title.localizedCaseInsensitiveContains(searchText) ||
            note.body.localizedCaseInsensitiveContains(searchText)
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
