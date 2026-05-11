import Foundation

struct Supplement: Identifiable, Hashable {
    let id: UUID
    let name: String
    let category: SupplementCategory
    let shortBenefit: String
    let summary: String
    let dosage: String
    let timing: String
    let evidenceLevel: EvidenceLevel
    let safetyNotes: [String]
    let interactions: [String]
    let tags: [String]
    let isHotirghiniPick: Bool
}

enum SupplementCategory: String, CaseIterable, Identifiable {
    case dailyFoundation = "Daily Foundation"
    case performance = "Performance"
    case recovery = "Recovery"
    case focus = "Focus"
    case sleep = "Sleep"

    var id: String { rawValue }
}

enum EvidenceLevel: String, CaseIterable {
    case emerging = "Emerging"
    case moderate = "Moderate"
    case strong = "Strong"

    var rank: Int {
        switch self {
        case .emerging: return 1
        case .moderate: return 2
        case .strong: return 3
        }
    }
}
