import Foundation

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var selectedGoal: WellnessGoal = .energy
    @Published var selectedDiet: DietaryPreference = .omnivore
}
