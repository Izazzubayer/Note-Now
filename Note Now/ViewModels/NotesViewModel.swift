import Foundation
import SwiftUI

@MainActor
class NotesViewModel: ObservableObject {
    @Published var notes: [Note] = []
    @Published var selectedSortOption: SortOption = .lastEdited {
        didSet {
            if oldValue != selectedSortOption {
                HapticManager.shared.selectionChanged()
                _clearFilterCache() // Clear cache when sort option changes
            }
        }
    }
    @Published var selectedViewMode: ViewMode = .list {
        didSet {
            if oldValue != selectedViewMode {
                HapticManager.shared.selectionChanged()
                _clearFilterCache() // Clear cache when view mode changes
            }
        }
    }
    @Published var selectedDensity: DensitySetting = .comfortable {
        didSet {
            if oldValue != selectedDensity {
                HapticManager.shared.selectionChanged()
                _clearFilterCache() // Clear cache when density changes
            }
        }
    }
    @Published var selectedGrouping: AgeGroup? = nil {
        didSet {
            if oldValue != selectedGrouping {
                HapticManager.shared.selectionChanged()
                _clearFilterCache() // Clear cache when grouping changes
            }
        }
    }
    @Published var selectedFolder: String? = nil {
        didSet {
            if oldValue != selectedFolder {
                HapticManager.shared.selectionChanged()
                _clearFilterCache() // Clear cache when folder changes
            }
        }
    }
    @Published var selectedTags: Set<String> = [] {
        didSet {
            if oldValue != selectedTags {
                HapticManager.shared.selectionChanged()
                _clearFilterCache() // Clear cache when tags change
            }
        }
    }
    
    init() {
        // Load sample notes for prototype
        notes = Note.previewNotes
    }
    
    func addNote(_ note: Note) {
        notes.insert(note, at: 0) // Add to top
        
        // Clear cache when notes change
        _clearFilterCache()
        
        // Haptic feedback for adding note
        HapticManager.shared.successNotification()
    }
    
    func deleteNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes.remove(at: index)
            
            // Clear cache when notes change
            _clearFilterCache()
            
            // Haptic feedback for deletion
            HapticManager.shared.deletePattern()
        }
    }
    
    func updateNote(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            var updatedNote = note
            updatedNote.lastModified = Date()
            notes[index] = updatedNote
            
            // Clear cache when notes change
            _clearFilterCache()
            
            // Haptic feedback for updating note
            HapticManager.shared.successNotification()
        }
    }
    
    func togglePin(_ note: Note) {
        if let index = notes.firstIndex(where: { $0.id == note.id }) {
            notes[index].isPinned.toggle()
            notes[index].lastModified = Date()
            
            // Clear cache when notes change
            _clearFilterCache()
            
            // Haptic feedback for pin/unpin
            HapticManager.shared.pinPattern()
        }
    }
    
    // MARK: - Cached Filtered Notes
    private var _cachedFilteredNotes: [Note] = []
    private var _lastSearchText: String = ""
    private var _lastFilters: String = ""
    
    func filteredNotes(searchText: String) -> [Note] {
        #if DEBUG
        let startTime = CFAbsoluteTimeGetCurrent()
        #endif
        
        // Create a cache key for current filters (more efficient string construction)
        let currentFilters = "\(searchText)_\(selectedFolder ?? "nil")_\(selectedTags.isEmpty ? "nil" : selectedTags.sorted().joined(separator: ","))_\(selectedGrouping?.rawValue ?? "nil")_\(selectedSortOption.rawValue)"
        
        // Return cached result if filters haven't changed
        if currentFilters == _lastFilters && searchText == _lastSearchText {
            #if DEBUG
            print("📱 Note filtering: Cache hit - \(String(format: "%.4f", (CFAbsoluteTimeGetCurrent() - startTime) * 1000))ms")
            #endif
            return _cachedFilteredNotes
        }
        
        // Update cache keys
        _lastSearchText = searchText
        _lastFilters = currentFilters
        
        var filtered = notes
        
        // Apply search filter (optimized with early exit)
        if !searchText.isEmpty {
            let searchLower = searchText.lowercased()
            filtered = filtered.filter { note in
                note.title.lowercased().contains(searchLower) ||
                note.body.lowercased().contains(searchLower)
            }
        }
        
        // Apply folder filter (early exit if no folder selected)
        if let selectedFolder = selectedFolder {
            filtered = filtered.filter { $0.folder == selectedFolder }
        }
        
        // Apply tag filter (early exit if no tags selected)
        if !selectedTags.isEmpty {
            filtered = filtered.filter { note in
                !note.tags.isDisjoint(with: selectedTags)
            }
        }
        
        // Apply age grouping (early exit if no grouping selected)
        if let selectedGrouping = selectedGrouping {
            filtered = filtered.filter { $0.ageGroup == selectedGrouping }
        }
        
        // Sort notes
        let sorted = sortNotes(filtered)
        
        // Always put pinned notes at the top (optimized with single pass)
        let (pinnedNotes, unpinnedNotes) = sorted.reduce(into: ([Note](), [Note]())) { result, note in
            if note.isPinned {
                result.0.append(note)
            } else {
                result.1.append(note)
            }
        }
        
        _cachedFilteredNotes = pinnedNotes + unpinnedNotes
        
        #if DEBUG
        let endTime = CFAbsoluteTimeGetCurrent()
        print("📱 Note filtering: \(filtered.count) notes filtered in \(String(format: "%.4f", (endTime - startTime) * 1000))ms")
        #endif
        
        return _cachedFilteredNotes
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
        
        // Clear cache when notes change
        _clearFilterCache()
        
        // Haptic feedback for clearing all notes
        HapticManager.shared.heavyImpact()
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
    
    // MARK: - Private Methods
    private func _clearFilterCache() {
        _cachedFilteredNotes.removeAll()
        _lastSearchText = ""
        _lastFilters = ""
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
