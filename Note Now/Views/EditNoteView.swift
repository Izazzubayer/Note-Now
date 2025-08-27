import SwiftUI

struct EditNoteView: View {
    let note: Note
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var noteBody: String
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case title, body
    }
    
    init(note: Note, viewModel: NotesViewModel) {
        self.note = note
        self.viewModel = viewModel
        self._title = State(initialValue: note.title)
        self._noteBody = State(initialValue: note.body)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Full-bleed OLED black background
                AppTheme.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with timestamps
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        // Creation and modification timestamps
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            HStack {
                                Image(systemName: "clock")
                                    .font(.system(size: 14))
                                    .appTertiaryText()
                                
                                Text("Created • \(formattedDate(note.createdAt))")
                                    .font(AppTheme.Typography.footnote)
                                    .appTertiaryText()
                                
                                Spacer()
                            }
                            
                            HStack {
                                Image(systemName: "pencil")
                                    .font(.system(size: 14))
                                    .appTertiaryText()
                                
                                Text("Modified • \(formattedDate(note.lastModified))")
                                    .font(AppTheme.Typography.footnote)
                                    .appTertiaryText()
                                
                                Spacer()
                            }
                        }
                        .padding(.horizontal, AppTheme.Spacing.lg)
                        .padding(.top, AppTheme.Spacing.md)
                        
                        // Title field
                        TextField("Title", text: $title)
                            .font(AppTheme.Typography.title)
                            .fontWeight(.bold)
                            .appPrimaryText()
                            .textFieldStyle(PlainTextFieldStyle())
                            .focused($focusedField, equals: .title)
                            .onSubmit {
                                // Move focus to body field when Return is pressed
                                focusedField = .body
                            }
                            .submitLabel(.next)
                            .padding(.horizontal, AppTheme.Spacing.lg)
                            .accessibilityLabel("Note title")
                            .accessibilityHint("Edit the title for your note")
                    }
                    .padding(.bottom, AppTheme.Spacing.sm)
                    
                    // Body field
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                        TextEditor(text: $noteBody)
                            .font(AppTheme.Typography.body)
                            .appPrimaryText()
                            .focused($focusedField, equals: .body)
                            .scrollContentBackground(.hidden)
                            .padding(.horizontal, AppTheme.Spacing.lg)
                            .accessibilityLabel("Note content")
                            .accessibilityHint("Edit the content for your note")
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        HapticManager.shared.cancelPattern()
                        dismiss()
                    }
                    .font(AppTheme.Typography.body)
                    .appPrimaryText()
                    .accessibilityLabel("Cancel note editing")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        HapticManager.shared.savePattern()
                        saveNote()
                    }
                    .font(AppTheme.Typography.body)
                    .fontWeight(.semibold)
                    .appPrimaryText()
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && noteBody.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .accessibilityLabel("Save note changes")
                    .accessibilityHint("Saves the edited note")
                }
            }
        }
        .onAppear {
            // Focus title field on entry
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                focusedField = .title
            }
        }
        .gesture(
            // Swipe to dismiss keyboard
            DragGesture()
                .onEnded { value in
                    if value.translation.height > 100 {
                        focusedField = nil
                    }
                }
        )
        .preferredColorScheme(.dark) // Force dark mode for OLED black
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        
        return formatter.string(from: date)
    }
    
    private func saveNote() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBody = noteBody.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !trimmedTitle.isEmpty || !trimmedBody.isEmpty {
            var updatedNote = note
            updatedNote.title = trimmedTitle
            updatedNote.body = trimmedBody
            updatedNote.lastModified = Date()
            
            viewModel.updateNote(updatedNote)
            
            // Haptic feedback already triggered in Save button
            
            dismiss()
        }
    }
}

#Preview("Edit Note") {
    EditNoteView(note: Note.previewNotes[0], viewModel: NotesViewModel())
}
