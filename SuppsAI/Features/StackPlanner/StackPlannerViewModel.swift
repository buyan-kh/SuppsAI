import Foundation

@MainActor
final class StackPlannerViewModel: ObservableObject {
    @Published var morning: [Supplement]
    @Published var evening: [Supplement]

    init(repository: SupplementRepository) {
        let profile = repository.sampleProfile()
        morning = profile.currentStack.filter { $0.category != .sleep }
        evening = repository.featuredSupplements().filter { $0.category == .sleep || $0.category == .recovery }
    }
}
