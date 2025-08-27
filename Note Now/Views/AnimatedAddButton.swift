import SwiftUI

struct AnimatedAddButton: View {
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // Haptic feedback on tap
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            // Trigger action
            action()
        }) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(AppTheme.background)
                .frame(width: 56, height: 56)
                .background(AppTheme.primary)
                .clipShape(Circle())
                .scaleEffect(isPressed ? 0.95 : 1.0)
                .shadow(
                    color: Color.black.opacity(0.3),
                    radius: isPressed ? 4 : 8,
                    x: 0,
                    y: isPressed ? 2 : 4
                )
        }
        .accessibilityLabel("Add new note")
        .accessibilityHint("Creates a new note")
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(AppTheme.Animation.easeInOut) {
                isPressed = pressing
            }
        }, perform: {})
    }
}

#Preview("Animated Add Button") {
    ZStack {
        AppTheme.background
            .ignoresSafeArea()
        
        AnimatedAddButton {
            print("Add button tapped")
        }
    }
}
