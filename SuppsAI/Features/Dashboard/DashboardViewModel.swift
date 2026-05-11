import Combine
import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var featured: [Supplement]
    @Published var profile: UserProfile
    @Published var stack: [Supplement]
    @Published var latestScan: ScanResult?

    private let appState: AppState

    init(repository: SupplementRepository, appState: AppState) {
        self.appState = appState
        featured = repository.featuredSupplements()
        profile = appState.profile
        stack = appState.stack
        latestScan = appState.latestScan
    }

    var heroTitle: String {
        "HOTIRGHINI stack for \(profile.goal.rawValue.lowercased())"
    }

    var readinessScore: Int {
        let evidenceBoost = stack.reduce(0) { $0 + $1.evidenceLevel.rank * 7 }
        let riskPenalty = latestScan.map { max(0, $0.riskScore / 4) } ?? 0
        return min(max(62 + evidenceBoost - riskPenalty, 1), 99)
    }

    func addToStack(_ supplement: Supplement) {
        appState.addToStack(supplement)
        stack = appState.stack
        profile = appState.profile
    }
}
