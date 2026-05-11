import Foundation

struct UserProfile: Hashable {
    var name: String
    var goal: WellnessGoal
    var dietaryPreference: DietaryPreference
    var caffeineSensitivity: SensitivityLevel
    var currentStack: [Supplement]
}

enum WellnessGoal: String, CaseIterable, Identifiable {
    case energy = "More Energy"
    case muscle = "Build Muscle"
    case focus = "Sharper Focus"
    case sleep = "Better Sleep"
    case longevity = "Longevity"

    var id: String { rawValue }
}

enum DietaryPreference: String, CaseIterable, Identifiable {
    case omnivore = "Omnivore"
    case vegetarian = "Vegetarian"
    case vegan = "Vegan"
    case glutenFree = "Gluten-free"

    var id: String { rawValue }
}

enum SensitivityLevel: String, CaseIterable, Identifiable {
    case low = "Low"
    case medium = "Medium"
    case high = "High"

    var id: String { rawValue }
}
