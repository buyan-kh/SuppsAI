import Foundation

@main
struct CoreSmokeTest {
    static func main() {
        let repository = MockSupplementRepository()
        let profile = repository.sampleProfile()
        let analyzer = OfflineLabelAnalyzer()
        let result = analyzer.analyze(
            labelText: "Ultra Pump Matrix\nCreatine monohydrate 5 g\nCaffeine proprietary energy blend",
            profile: profile,
            repository: repository
        )

        precondition(!repository.featuredSupplements().isEmpty, "Expected seeded supplements")
        precondition(result.riskScore > 0, "Expected positive risk score")
        precondition(!result.warnings.isEmpty, "Expected analyzer warnings")
        precondition(!result.suggestedAlternatives.isEmpty, "Expected suggested alternatives")
        print("Core smoke test passed with risk score \(result.riskScore) and \(result.suggestedAlternatives.count) alternatives")
    }
}
