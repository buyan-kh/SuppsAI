import Combine
import Foundation

@MainActor
final class AppContainer: ObservableObject {
    let repository: SupplementRepository
    let aiService: SuppsAIService
    let labelAnalyzer: LabelAnalyzer
    @Published var appState: AppState

    init(
        repository: SupplementRepository = MockSupplementRepository(),
        aiService: SuppsAIService = MockSuppsAIService(),
        labelAnalyzer: LabelAnalyzer = OfflineLabelAnalyzer(),
        hasCompletedOnboarding: Bool = false
    ) {
        self.repository = repository
        self.aiService = aiService
        self.labelAnalyzer = labelAnalyzer
        self.appState = AppState(repository: repository, hasCompletedOnboarding: hasCompletedOnboarding)
    }
}
