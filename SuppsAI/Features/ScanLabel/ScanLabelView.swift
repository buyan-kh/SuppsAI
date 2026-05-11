import SwiftUI

struct ScanLabelView: View {
    @StateObject var viewModel: ScanLabelViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    cameraMock
                    resultCard
                    alternativesCard
                }
                .padding(20)
            }
            .background(HotirghiniTheme.background.ignoresSafeArea())
            .navigationTitle("Label Scan")
        }
    }

    private var cameraMock: some View {
        VStack(spacing: 16) {
            Image(systemName: "viewfinder.circle.fill")
                .font(.system(size: 72))
                .foregroundStyle(HotirghiniTheme.gradient)
            Text("Point your camera at a Supplement Facts panel")
                .font(.headline)
                .multilineTextAlignment(.center)
                .foregroundStyle(HotirghiniTheme.textPrimary)
            Button(action: viewModel.analyze) {
                Label(viewModel.isAnalyzing ? "Analyzing…" : "Analyze mock label", systemImage: "wand.and.stars")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(HotirghiniTheme.accent)
        }
        .padding(24)
        .background(HotirghiniTheme.cardElevated, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
    }

    private var resultCard: some View {
        HotirghiniCard {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(viewModel.scanResult.productName)
                            .font(.title3.bold())
                            .foregroundStyle(HotirghiniTheme.textPrimary)
                        Text("Risk score: \(viewModel.scanResult.riskScore)/100")
                            .foregroundStyle(HotirghiniTheme.textSecondary)
                    }
                    Spacer()
                    Gauge(value: Double(viewModel.scanResult.riskScore), in: 0...100) { EmptyView() }
                        .gaugeStyle(.accessoryCircularCapacity)
                        .tint(HotirghiniTheme.accent)
                        .frame(width: 58)
                }

                Text(viewModel.aiExplanation)
                    .font(.subheadline)
                    .foregroundStyle(HotirghiniTheme.textSecondary)

                ForEach(viewModel.scanResult.warnings, id: \.self) { warning in
                    Label(warning, systemImage: "exclamationmark.triangle.fill")
                        .foregroundStyle(.yellow)
                        .font(.subheadline)
                }
            }
        }
    }

    private var alternativesCard: some View {
        HotirghiniCard {
            VStack(alignment: .leading, spacing: 12) {
                Text("Cleaner alternatives")
                    .font(.headline)
                    .foregroundStyle(HotirghiniTheme.textPrimary)
                ForEach(viewModel.scanResult.suggestedAlternatives) { supplement in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(supplement.name).bold()
                            Text(supplement.shortBenefit).font(.caption)
                        }
                        Spacer()
                        EvidenceBadge(level: supplement.evidenceLevel)
                    }
                    .foregroundStyle(HotirghiniTheme.textSecondary)
                }
            }
        }
    }
}

#Preview {
    ScanLabelView(viewModel: ScanLabelViewModel(repository: MockSupplementRepository(), aiService: MockSuppsAIService()))
}
