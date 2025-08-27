import SwiftUI

// MARK: - Color Theme
struct AppTheme {
    // MARK: - Colors (Monochrome Palette)
    static let background = Color(red: 0, green: 0, blue: 0) // #000000 - True OLED Black
    static let surface = Color(red: 0.06, green: 0.06, blue: 0.06) // #0F0F0F - Very Dark Grey
    static let primary = Color.white // #FFFFFF - Pure White
    static let secondary = Color(red: 0.9, green: 0.9, blue: 0.9) // #E6E6E6 - Light Grey
    static let tertiary = Color(red: 0.6, green: 0.6, blue: 0.6) // #999999 - Medium Grey
    static let quaternary = Color(red: 0.4, green: 0.4, blue: 0.4) // #666666 - Dark Grey
    static let separator = Color(red: 0.2, green: 0.2, blue: 0.2) // #333333 - Very Dark Grey
    
    // MARK: - Typography
    struct Typography {
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .default)
        static let title = Font.system(size: 28, weight: .bold, design: .default)
        static let title2 = Font.system(size: 22, weight: .bold, design: .default)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .default)
        static let headline = Font.system(size: 17, weight: .semibold, design: .default)
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        static let callout = Font.system(size: 16, weight: .regular, design: .default)
        static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
        static let footnote = Font.system(size: 13, weight: .regular, design: .default)
        static let caption = Font.system(size: 12, weight: .regular, design: .default)
        static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
    }
    
    // MARK: - Spacing (8pt Grid System)
    struct Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
    }
    
    // MARK: - Animation
    struct Animation {
        static let spring = SwiftUI.Animation.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)
        static let easeOut = SwiftUI.Animation.easeOut(duration: 0.3)
        static let easeInOut = SwiftUI.Animation.easeInOut(duration: 0.3)
    }
}

// MARK: - View Extensions
extension View {
    func appBackground() -> some View {
        self.background(AppTheme.background)
    }
    
    func appSurface() -> some View {
        self.background(AppTheme.surface)
    }
    
    func appPrimaryText() -> some View {
        self.foregroundColor(AppTheme.primary)
    }
    
    func appSecondaryText() -> some View {
        self.foregroundColor(AppTheme.secondary)
    }
    
    func appTertiaryText() -> some View {
        self.foregroundColor(AppTheme.tertiary)
    }
}
