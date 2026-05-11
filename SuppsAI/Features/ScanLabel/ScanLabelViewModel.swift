import Combine
import Foundation

@MainActor
final class ScanLabelViewModel: ObservableObject {
    @Published var labelText: String
    @Published var scanResult: ScanResult
    @Published var aiExplanation: String
    @Published var isAnalyzing = false
    @Published var confirmationMessage: String?

    private let repository: SupplementRepository
    private let aiService: SuppsAIService
    private let labelAnalyzer: LabelAnalyzer
    private let appState: AppState

    init(repository: SupplementRepository, aiService: SuppsAIService, labelAnalyzer: LabelAnalyzer, appState: AppState) {
        self.repository = repository
        self.aiService = aiService
        self.labelAnalyzer = labelAnalyzer
        self.appState = appState
        scanResult = appState.latestScan ?? repository.sampleScanResult()
        labelText = "Ultra Pump Matrix\nCreatine monohydrate 5 g\nCitrulline malate 6 g\nCaffeine anhydrous proprietary energy blend\nNatural flavors"
        aiExplanation = scanResult.explanation
    }

    func analyze() {
        isAnalyzing = true
        confirmationMessage = nil
        let offlineResult = labelAnalyzer.analyze(labelText: labelText, profile: appState.profile, repository: repository)
        scanResult = offlineResult
        aiExplanation = offlineResult.explanation
        appState.record(scanResult: offlineResult)

        Task {
            defer { isAnalyzing = false }
            do {
                let aiSummary = try await aiService.explain(scanText: labelText, profile: appState.profile)
                aiExplanation = "\(offlineResult.explanation) \(aiSummary)"
            } catch {
                aiExplanation = offlineResult.explanation
            }
        }
    }

    func addAlternativeToStack(_ supplement: Supplement) {
        appState.addToStack(supplement)
        confirmationMessage = "Added \(supplement.name) to your stack."
    }
}
