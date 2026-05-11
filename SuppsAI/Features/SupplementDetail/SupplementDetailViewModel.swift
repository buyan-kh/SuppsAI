import Foundation

@MainActor
final class SupplementDetailViewModel: ObservableObject {
    let supplement: Supplement

    init(supplement: Supplement) {
        self.supplement = supplement
    }
}
