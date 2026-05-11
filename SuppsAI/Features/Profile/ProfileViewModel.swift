import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile

    init(repository: SupplementRepository) {
        profile = repository.sampleProfile()
    }
}
