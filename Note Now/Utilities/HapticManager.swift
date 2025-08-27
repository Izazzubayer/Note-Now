import UIKit
import SwiftUI

// MARK: - Haptic Feedback Manager
class HapticManager {
    static let shared = HapticManager()
    
    // MARK: - Cached Haptic Generators
    private let lightImpactGenerator = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpactGenerator = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpactGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private let softImpactGenerator = UIImpactFeedbackGenerator(style: .soft)
    private let rigidImpactGenerator = UIImpactFeedbackGenerator(style: .rigid)
    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()
    
    private init() {
        // Prepare all generators for immediate use
        lightImpactGenerator.prepare()
        mediumImpactGenerator.prepare()
        heavyImpactGenerator.prepare()
        softImpactGenerator.prepare()
        rigidImpactGenerator.prepare()
        notificationGenerator.prepare()
        selectionGenerator.prepare()
    }
    
    // MARK: - Impact Haptics (Light, Medium, Heavy, Soft, Rigid)
    
    /// Light impact - for subtle interactions like button taps
    func lightImpact() {
        lightImpactGenerator.impactOccurred()
        lightImpactGenerator.prepare() // Prepare for next use
    }
    
    /// Medium impact - for moderate interactions like list item selection
    func mediumImpact() {
        mediumImpactGenerator.impactOccurred()
        mediumImpactGenerator.prepare() // Prepare for next use
    }
    
    /// Heavy impact - for significant interactions like deleting items
    func heavyImpact() {
        heavyImpactGenerator.impactOccurred()
        heavyImpactGenerator.prepare() // Prepare for next use
    }
    
    /// Soft impact - for gentle interactions like swiping
    func softImpact() {
        softImpactGenerator.impactOccurred()
        softImpactGenerator.prepare() // Prepare for next use
    }
    
    /// Rigid impact - for precise interactions like toggling switches
    func rigidImpact() {
        rigidImpactGenerator.impactOccurred()
        rigidImpactGenerator.prepare() // Prepare for next use
    }
    
    // MARK: - Notification Haptics
    
    /// Success notification - for successful actions like saving notes
    func successNotification() {
        notificationGenerator.notificationOccurred(.success)
        notificationGenerator.prepare() // Prepare for next use
    }
    
    /// Warning notification - for cautionary actions like unsaved changes
    func warningNotification() {
        notificationGenerator.notificationOccurred(.warning)
        notificationGenerator.prepare() // Prepare for next use
    }
    
    /// Error notification - for failed actions like save errors
    func errorNotification() {
        notificationGenerator.notificationOccurred(.error)
        notificationGenerator.prepare() // Prepare for next use
    }
    
    // MARK: - Selection Haptics
    
    /// Selection change - for changing selection states
    func selectionChanged() {
        selectionGenerator.selectionChanged()
        selectionGenerator.prepare() // Prepare for next use
    }
    
    // MARK: - Custom Haptic Patterns
    
    /// Double tap pattern - for special interactions
    func doubleTapPattern() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            impactFeedback.impactOccurred()
        }
    }
    
    /// Swipe pattern - for swipe actions
    func swipePattern() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .soft)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
    }
    
    /// Pin pattern - for pinning/unpinning notes
    func pinPattern() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .rigid)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
    }
    
    /// Delete pattern - for deletion actions
    func deletePattern() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
    }
    
    /// Save pattern - for saving actions
    func savePattern() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.prepare()
        notificationFeedback.notificationOccurred(.success)
    }
    
    /// Cancel pattern - for cancellation actions
    func cancelPattern() {
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.prepare()
        impactFeedback.impactOccurred()
    }
}

// MARK: - SwiftUI Haptic Modifiers
extension View {
    /// Add haptic feedback to any view interaction
    func hapticFeedback(_ haptic: @escaping () -> Void) -> some View {
        self.onTapGesture {
            haptic()
        }
    }
    
    /// Add haptic feedback to button taps
    func buttonHaptic() -> some View {
        self.onTapGesture {
            HapticManager.shared.lightImpact()
        }
    }
    
    /// Add haptic feedback to selection changes
    func selectionHaptic() -> some View {
        self.onTapGesture {
            HapticManager.shared.selectionChanged()
        }
    }
}
