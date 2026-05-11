import SwiftUI

struct ScanLabelView: View {
    @StateObject var viewModel: ScanLabelViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    scannerCard
                    resultCard
                    alternativesCard
                }
                .padding(20)
            }
            .background(HotirghiniTheme.background.ignoresSafeArea())
            .navigationTitle("Label Scan")
        }
    }

    private var scannerCard: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "viewfinder.circle.fill")
                    .font(.system(size: 54))
                    .foregroundStyle(HotirghiniTheme.gradient)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Paste or scan label text")
                        .font(.headline)
                        .foregroundStyle(HotirghiniTheme.textPrimary)
                    Text("Offline analyzer runs end-to-end with seeded data.")
                        .font(.caption)
                        .foregroundStyle(HotirghiniTheme.textSecondary)
                }
                Spacer()
            }

            TextEditor(text: $viewModel.labelText)
                .frame(minHeight: 150)
                .scrollContentBackground(.hidden)
                .foregroundStyle(HotirghiniTheme.textPrimary)
                .padding(12)
                .background(Color.black.opacity(0.24), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(HotirghiniTheme.mint.opacity(0.2), lineWidth: 1)
                )

            Button(action: viewModel.analyze) {
                Label(viewModel.isAnalyzing ? "Analyzing…" : "Analyze label", systemImage: "wand.and.stars")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(HotirghiniTheme.accent)
        }
        .padding(24)
        .background(HotirghiniTheme.cardElevated, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(HotirghiniTheme.mint.opacity(0.14), lineWidth: 1)
        )
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
                        .tint(viewModel.scanResult.riskScore > 70 ? .red : HotirghiniTheme.accent)
                        .frame(width: 62)
                }

                Text(viewModel.aiExplanation)
                    .font(.subheadline)
                    .foregroundStyle(HotirghiniTheme.textSecondary)

                FlowTags(tags: viewModel.scanResult.ingredientHighlights)

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
                if let confirmation = viewModel.confirmationMessage {
                    Text(confirmation)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(HotirghiniTheme.mint)
                }
                ForEach(viewModel.scanResult.suggestedAlternatives) { supplement in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(supplement.name).bold()
                            Text(supplement.shortBenefit).font(.caption)
                        }
                        Spacer()
                        Button("Add") {
                            viewModel.addAlternativeToStack(supplement)
                        }
                        .buttonStyle(.bordered)
                        .tint(HotirghiniTheme.mint)
                    }
                    .foregroundStyle(HotirghiniTheme.textSecondary)
                }
            }
        }
    }
}

struct FlowTags: View {
    let tags: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(tags, id: \.self) { tag in
                Text(tag)
                    .font(.caption.weight(.bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .foregroundStyle(HotirghiniTheme.mint)
                    .background(HotirghiniTheme.mint.opacity(0.12), in: Capsule())
            }
        }
    }
}

#Preview {
    let repository = MockSupplementRepository()
    ScanLabelView(
        viewModel: ScanLabelViewModel(
            repository: repository,
            aiService: MockSuppsAIService(),
            labelAnalyzer: OfflineLabelAnalyzer(),
            appState: AppState(repository: repository, hasCompletedOnboarding: true)
        )
    )
}
