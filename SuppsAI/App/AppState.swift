import Combine
import Foundation

@MainActor
final class AppState: ObservableObject {
    @Published var hasCompletedOnboarding: Bool
    @Published var profile: UserProfile
    @Published var stack: [Supplement]
    @Published var latestScan: ScanResult?
    @Published var scanHistory: [ScanResult]

    init(repository: SupplementRepository, hasCompletedOnboarding: Bool = false) {
        let profile = repository.sampleProfile()
        self.hasCompletedOnboarding = hasCompletedOnboarding
        self.profile = profile
        self.stack = profile.currentStack
        self.latestScan = repository.sampleScanResult()
        self.scanHistory = [repository.sampleScanResult()]
    }

    func completeOnboarding(goal: WellnessGoal, diet: DietaryPreference, caffeineSensitivity: SensitivityLevel) {
        profile.goal = goal
        profile.dietaryPreference = diet
        profile.caffeineSensitivity = caffeineSensitivity
        hasCompletedOnboarding = true
    }

    func record(scanResult: ScanResult) {
        latestScan = scanResult
        scanHistory.insert(scanResult, at: 0)
    }

    func addToStack(_ supplement: Supplement) {
        guard !stack.contains(where: { $0.id == supplement.id }) else { return }
        stack.append(supplement)
        profile.currentStack = stack
    }

    func removeFromStack(_ supplement: Supplement) {
        stack.removeAll { $0.id == supplement.id }
        profile.currentStack = stack
    }
}
