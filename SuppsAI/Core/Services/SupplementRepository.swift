import Foundation

protocol SupplementRepository {
    func featuredSupplements() -> [Supplement]
    func supplements(matching goal: WellnessGoal) -> [Supplement]
    func sampleProfile() -> UserProfile
    func sampleScanResult() -> ScanResult
}

struct MockSupplementRepository: SupplementRepository {
    private let supplements: [Supplement]

    init() {
        supplements = Self.seedSupplements
    }

    func featuredSupplements() -> [Supplement] {
        supplements.sorted { lhs, rhs in
            if lhs.isHotirghiniPick != rhs.isHotirghiniPick {
                return lhs.isHotirghiniPick && !rhs.isHotirghiniPick
            }
            return lhs.evidenceLevel.rank > rhs.evidenceLevel.rank
        }
    }

    func supplements(matching goal: WellnessGoal) -> [Supplement] {
        switch goal {
        case .energy:
            return supplements.filter { $0.category == .dailyFoundation || $0.category == .performance }
        case .muscle:
            return supplements.filter { $0.category == .performance || $0.category == .recovery }
        case .focus:
            return supplements.filter { $0.category == .focus || $0.tags.contains("nootropic") }
        case .sleep:
            return supplements.filter { $0.category == .sleep || $0.category == .recovery }
        case .longevity:
            return supplements.filter { $0.category == .dailyFoundation || $0.tags.contains("cellular") }
        }
    }

    func sampleProfile() -> UserProfile {
        UserProfile(
            name: "Alex",
            goal: .energy,
            dietaryPreference: .omnivore,
            caffeineSensitivity: .medium,
            currentStack: Array(featuredSupplements().prefix(3))
        )
    }

    func sampleScanResult() -> ScanResult {
        ScanResult(
            id: UUID(uuidString: "B96FB7A8-5823-49CE-9CD1-F2E585B6B6C2")!,
            productName: "Ultra Pump Matrix",
            riskScore: 68,
            ingredientHighlights: ["Creatine monohydrate", "Citrulline malate", "High-stim caffeine blend"],
            warnings: ["Caffeine amount is not fully disclosed", "Avoid late-day use if sleep is a goal"],
            suggestedAlternatives: Array(supplements.filter { $0.category == .performance }.prefix(2)),
            explanation: "This pre-workout is a moderate-risk fit because its stimulant blend is not transparent.",
            analyzedAt: Date()
        )
    }
}

extension MockSupplementRepository {
    static let seedSupplements: [Supplement] = [
        Supplement(
            id: UUID(uuidString: "0D94C61B-A833-40E6-9AE0-83F5242A5201")!,
            name: "Creatine Monohydrate",
            category: .performance,
            shortBenefit: "Strength, power, and lean mass support",
            summary: "One of the most researched performance supplements, useful for repeated high-intensity efforts and daily training consistency.",
            dosage: "3–5 g daily",
            timing: "Any time; pair with a meal for habit formation",
            evidenceLevel: .strong,
            safetyNotes: ["Hydrate consistently", "Discuss with a clinician if you have kidney disease"],
            interactions: ["No major common interactions for healthy adults"],
            tags: ["strength", "muscle", "cellular"],
            isHotirghiniPick: true
        ),
        Supplement(
            id: UUID(uuidString: "1F0B2670-4D8C-4AD4-A632-D5FF2C6B40A7")!,
            name: "Vitamin D3 + K2",
            category: .dailyFoundation,
            shortBenefit: "Foundational immune and bone support",
            summary: "A daily foundation pairing for users with low sun exposure or lab-confirmed vitamin D insufficiency.",
            dosage: "1,000–2,000 IU D3 daily unless labs suggest otherwise",
            timing: "With a fat-containing meal",
            evidenceLevel: .strong,
            safetyNotes: ["Confirm higher doses with lab work", "Avoid K2 without medical guidance if taking warfarin"],
            interactions: ["Warfarin and other vitamin K-sensitive therapies"],
            tags: ["foundation", "bones", "immune"],
            isHotirghiniPick: true
        ),
        Supplement(
            id: UUID(uuidString: "E5127E92-9C23-493A-8B58-6C06995BB628")!,
            name: "Magnesium Glycinate",
            category: .sleep,
            shortBenefit: "Relaxation and sleep routine support",
            summary: "A gentle magnesium form often used in evening wind-down stacks and recovery-focused routines.",
            dosage: "100–300 mg elemental magnesium",
            timing: "30–60 minutes before bed",
            evidenceLevel: .moderate,
            safetyNotes: ["Start low to assess GI tolerance", "Separate from certain antibiotics and thyroid medication"],
            interactions: ["Levothyroxine", "Tetracycline and quinolone antibiotics"],
            tags: ["sleep", "recovery", "calm"],
            isHotirghiniPick: true
        ),
        Supplement(
            id: UUID(uuidString: "6E041980-C9AA-4B27-AF9F-EC701BFF28A0")!,
            name: "Omega-3 EPA/DHA",
            category: .dailyFoundation,
            shortBenefit: "Heart, brain, and inflammation balance",
            summary: "A foundational fatty-acid supplement for people who do not regularly eat fatty fish.",
            dosage: "1–2 g combined EPA/DHA daily",
            timing: "With meals",
            evidenceLevel: .moderate,
            safetyNotes: ["Choose third-party tested products", "Ask a clinician before surgery or if using blood thinners"],
            interactions: ["Anticoagulants and antiplatelet drugs"],
            tags: ["heart", "brain", "foundation"],
            isHotirghiniPick: false
        ),
        Supplement(
            id: UUID(uuidString: "4423DA44-7EB8-4370-9C7E-5F2F4F04F0CC")!,
            name: "Citrulline Malate",
            category: .performance,
            shortBenefit: "Training pump and endurance support",
            summary: "A non-stimulant performance option often used before training for blood-flow and repeated-effort support.",
            dosage: "6–8 g before training",
            timing: "30–60 minutes pre-workout",
            evidenceLevel: .moderate,
            safetyNotes: ["Start lower if prone to GI discomfort", "Use caution with blood-pressure medication"],
            interactions: ["Nitrates and blood-pressure medication"],
            tags: ["pump", "training", "non-stim"],
            isHotirghiniPick: true
        ),
        Supplement(
            id: UUID(uuidString: "77C67FE9-E0C8-4219-A6E5-132CB11EE68D")!,
            name: "L-Theanine",
            category: .focus,
            shortBenefit: "Calm focus with or without caffeine",
            summary: "Commonly paired with coffee to smooth stimulation and support focused work sessions.",
            dosage: "100–200 mg",
            timing: "With caffeine or before deep work",
            evidenceLevel: .moderate,
            safetyNotes: ["May cause drowsiness in sensitive users"],
            interactions: ["Sedatives may increase drowsiness"],
            tags: ["nootropic", "focus", "calm"],
            isHotirghiniPick: false
        )
    ]
}
