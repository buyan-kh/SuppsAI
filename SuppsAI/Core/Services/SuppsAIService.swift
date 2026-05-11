import Foundation

protocol SuppsAIService {
    func explain(scanText: String, profile: UserProfile) async throws -> String
}

struct MockSuppsAIService: SuppsAIService {
    func explain(scanText: String, profile: UserProfile) async throws -> String {
        "Based on \(profile.goal.rawValue.lowercased()), prioritize transparent labels, moderate stimulants, and evidence-backed basics before specialty blends."
    }
}
