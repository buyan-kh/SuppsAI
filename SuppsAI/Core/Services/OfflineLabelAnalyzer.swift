import Foundation

protocol LabelAnalyzer {
    func analyze(labelText: String, profile: UserProfile, repository: SupplementRepository) -> ScanResult
}

struct OfflineLabelAnalyzer: LabelAnalyzer {
    func analyze(labelText: String, profile: UserProfile, repository: SupplementRepository) -> ScanResult {
        let normalized = labelText.lowercased()
        let containsHighStim = normalized.contains("caffeine") || normalized.contains("yohimbine") || normalized.contains("synephrine")
        let containsProprietaryBlend = normalized.contains("proprietary") || normalized.contains("matrix") || normalized.contains("blend")
        let containsCreatine = normalized.contains("creatine")
        let containsMagnesium = normalized.contains("magnesium")
        let containsThirdPartyTesting = normalized.contains("nsf") || normalized.contains("informed sport") || normalized.contains("third-party")

        var score = 18
        if containsHighStim { score += profile.caffeineSensitivity == .high ? 42 : 28 }
        if containsProprietaryBlend { score += 24 }
        if !containsThirdPartyTesting { score += 12 }
        if containsCreatine || containsMagnesium { score -= 8 }
        score = min(max(score, 5), 96)

        let highlights = buildHighlights(
            containsCreatine: containsCreatine,
            containsMagnesium: containsMagnesium,
            containsHighStim: containsHighStim,
            containsProprietaryBlend: containsProprietaryBlend,
            containsThirdPartyTesting: containsThirdPartyTesting
        )
        let warnings = buildWarnings(
            containsHighStim: containsHighStim,
            containsProprietaryBlend: containsProprietaryBlend,
            containsThirdPartyTesting: containsThirdPartyTesting,
            profile: profile
        )
        let alternatives = repository
            .supplements(matching: profile.goal)
            .filter { $0.evidenceLevel != .emerging }
            .prefix(3)

        return ScanResult(
            id: UUID(),
            productName: inferredProductName(from: labelText),
            riskScore: score,
            ingredientHighlights: highlights,
            warnings: warnings,
            suggestedAlternatives: Array(alternatives),
            explanation: explanation(for: score, profile: profile, warnings: warnings),
            analyzedAt: Date()
        )
    }

    private func buildHighlights(
        containsCreatine: Bool,
        containsMagnesium: Bool,
        containsHighStim: Bool,
        containsProprietaryBlend: Bool,
        containsThirdPartyTesting: Bool
    ) -> [String] {
        var highlights: [String] = []
        if containsCreatine { highlights.append("Creatine detected") }
        if containsMagnesium { highlights.append("Magnesium detected") }
        if containsHighStim { highlights.append("Stimulant ingredients detected") }
        if containsProprietaryBlend { highlights.append("Blend transparency issue") }
        if containsThirdPartyTesting { highlights.append("Third-party testing claim found") }
        return highlights.isEmpty ? ["No high-signal ingredients detected in sample text"] : highlights
    }

    private func buildWarnings(
        containsHighStim: Bool,
        containsProprietaryBlend: Bool,
        containsThirdPartyTesting: Bool,
        profile: UserProfile
    ) -> [String] {
        var warnings: [String] = []
        if containsHighStim {
            warnings.append(profile.caffeineSensitivity == .high ? "High caffeine sensitivity: avoid stimulant blends." : "Avoid late-day stimulant use if sleep matters.")
        }
        if containsProprietaryBlend {
            warnings.append("Proprietary blends hide exact ingredient amounts.")
        }
        if !containsThirdPartyTesting {
            warnings.append("No third-party testing claim found in the label text.")
        }
        return warnings.isEmpty ? ["No major label risks found in the mock analyzer."] : warnings
    }

    private func explanation(for score: Int, profile: UserProfile, warnings: [String]) -> String {
        if score >= 70 {
            return "This looks risky for \(profile.goal.rawValue.lowercased()) because \(warnings.joined(separator: " "))"
        } else if score >= 40 {
            return "This is a moderate-fit label. Use it only if dosing is transparent and timing matches your goal."
        } else {
            return "This label is a stronger fit for your current profile, but still verify medications, conditions, and dosing."
        }
    }

    private func inferredProductName(from labelText: String) -> String {
        labelText
            .split(separator: "\n")
            .first
            .map(String.init) ?? "Analyzed Supplement"
    }
}
