import Foundation

struct ScanResult: Identifiable, Hashable {
    let id: UUID
    let productName: String
    let riskScore: Int
    let ingredientHighlights: [String]
    let warnings: [String]
    let suggestedAlternatives: [Supplement]
    let explanation: String
    let analyzedAt: Date
}
