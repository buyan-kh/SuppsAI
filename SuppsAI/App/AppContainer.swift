import Foundation

@MainActor
final class AppContainer: ObservableObject {
    let repository: SupplementRepository
    let aiService: SuppsAIService

    init(repository: SupplementRepository = MockSupplementRepository(), aiService: SuppsAIService = MockSuppsAIService()) {
        self.repository = repository
        self.aiService = aiService
    }
}
