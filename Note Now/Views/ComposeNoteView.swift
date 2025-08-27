import SwiftUI

struct ComposeNoteView: View {
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var noteBody = ""
    @State private var isTitleFocused = true
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case title, body
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Full-bleed OLED black background
                AppTheme.background
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header with timestamp
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        // Creation timestamp (non-editable)
                        HStack {
                            Image(systemName: "clock")
                                .font(.system(size: 14))
                                .appTertiaryText()
                            
                            Text("Created • \(formattedTimestamp)")
                                .font(AppTheme.Typography.footnote)
                                .appTertiaryText()
                            
                            Spacer()
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
                            .padding(.horizontal, AppTheme.Spacing.lg)
                            .accessibilityLabel("Note title")
                            .accessibilityHint("Enter the title for your note")
                    }
                    .padding(.bottom, AppTheme.Spacing.lg)
                    
                    // Body field
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                        TextEditor(text: $noteBody)
                            .font(AppTheme.Typography.body)
                            .appPrimaryText()
                            .focused($focusedField, equals: .body)
                            .scrollContentBackground(.hidden)
                            .padding(.horizontal, AppTheme.Spacing.lg)
                            .accessibilityLabel("Note content")
                            .accessibilityHint("Enter the content for your note")
                    }
                    
                    Spacer()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(AppTheme.Typography.body)
                    .appPrimaryText()
                    .accessibilityLabel("Cancel note creation")
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveNote()
                    }
                    .font(AppTheme.Typography.body)
                    .fontWeight(.semibold)
                    .appPrimaryText()
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && noteBody.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .accessibilityLabel("Save note")
                    .accessibilityHint("Saves the current note")
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
    
    private var formattedTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        
        return formatter.string(from: Date())
    }
    
    private func saveNote() {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBody = noteBody.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !trimmedTitle.isEmpty || !trimmedBody.isEmpty {
            let note = Note(title: trimmedTitle, body: trimmedBody)
            viewModel.addNote(note)
            
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            dismiss()
        }
    }
}

#Preview("Compose Note") {
    ComposeNoteView(viewModel: NotesViewModel())
}

#Preview("Compose Note - Large Text") {
    ComposeNoteView(viewModel: NotesViewModel())
        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
}
