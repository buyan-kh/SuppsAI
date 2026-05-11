import Combine
import Foundation

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var selectedGoal: WellnessGoal
    @Published var selectedDiet: DietaryPreference
    @Published var caffeineSensitivity: SensitivityLevel

    init(profile: UserProfile = MockSupplementRepository().sampleProfile()) {
        selectedGoal = profile.goal
        selectedDiet = profile.dietaryPreference
        caffeineSensitivity = profile.caffeineSensitivity
    }
}
