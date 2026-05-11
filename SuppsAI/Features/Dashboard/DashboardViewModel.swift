import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {
    @Published var featured: [Supplement]
    @Published var profile: UserProfile

    init(repository: SupplementRepository) {
        featured = repository.featuredSupplements()
        profile = repository.sampleProfile()
    }

    var heroTitle: String {
        "HOTIRGHINI stack for \(profile.goal.rawValue.lowercased())"
    }
}
