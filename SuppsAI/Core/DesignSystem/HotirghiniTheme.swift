import SwiftUI

enum HotirghiniTheme {
    static let background = Color(red: 0.04, green: 0.06, blue: 0.12)
    static let card = Color(red: 0.09, green: 0.12, blue: 0.20)
    static let cardElevated = Color(red: 0.12, green: 0.16, blue: 0.28)
    static let accent = Color(red: 0.95, green: 0.37, blue: 0.16)
    static let mint = Color(red: 0.25, green: 0.90, blue: 0.72)
    static let textPrimary = Color.white
    static let textSecondary = Color.white.opacity(0.72)

    static let gradient = LinearGradient(
        colors: [accent, Color(red: 1.0, green: 0.66, blue: 0.24)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

struct HotirghiniCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(18)
            .background(HotirghiniTheme.card, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
            )
    }
}

struct EvidenceBadge: View {
    let level: EvidenceLevel

    var body: some View {
        Text(level.rawValue)
            .font(.caption.weight(.bold))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .foregroundStyle(.black)
            .background(badgeColor, in: Capsule())
    }

    private var badgeColor: Color {
        switch level {
        case .emerging: return .yellow
        case .moderate: return HotirghiniTheme.mint
        case .strong: return .green
        }
    }
}
