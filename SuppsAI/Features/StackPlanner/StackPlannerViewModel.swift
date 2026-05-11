import Combine
import Foundation

@MainActor
final class StackPlannerViewModel: ObservableObject {
    @Published var morning: [Supplement]
    @Published var evening: [Supplement]
    @Published var allStack: [Supplement]

    private let appState: AppState

    init(repository: SupplementRepository, appState: AppState) {
        self.appState = appState
        allStack = appState.stack
        morning = appState.stack.filter { $0.category != .sleep }
        evening = appState.stack.filter { $0.category == .sleep || $0.category == .recovery }
        if evening.isEmpty {
            evening = repository.featuredSupplements().filter { $0.category == .sleep || $0.category == .recovery }
        }
    }

    func remove(_ supplement: Supplement) {
        appState.removeFromStack(supplement)
        allStack = appState.stack
        morning = appState.stack.filter { $0.category != .sleep }
        evening = appState.stack.filter { $0.category == .sleep || $0.category == .recovery }
    }
}
