import Foundation

@MainActor
final class ScanLabelViewModel: ObservableObject {
    @Published var scanResult: ScanResult
    @Published var aiExplanation: String = "Tap Analyze to generate a concise label readout."
    @Published var isAnalyzing = false

    private let repository: SupplementRepository
    private let aiService: SuppsAIService

    init(repository: SupplementRepository, aiService: SuppsAIService) {
        self.repository = repository
        self.aiService = aiService
        scanResult = repository.sampleScanResult()
    }

    func analyze() {
        isAnalyzing = true
        Task {
            defer { isAnalyzing = false }
            do {
                aiExplanation = try await aiService.explain(scanText: scanResult.productName, profile: repository.sampleProfile())
            } catch {
                aiExplanation = "Unable to analyze right now. Confirm API configuration and try again."
            }
        }
    }
}
