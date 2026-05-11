import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel: DashboardViewModel
    @ObservedObject var appState: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    hero
                    metricsStrip

                    Text("Evidence-backed picks")
                        .font(.title2.bold())
                        .foregroundStyle(HotirghiniTheme.textPrimary)

                    ForEach(viewModel.featured) { supplement in
                        NavigationLink(value: supplement) {
                            SupplementRow(supplement: supplement) {
                                viewModel.addToStack(supplement)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
            .background(HotirghiniTheme.background.ignoresSafeArea())
            .navigationTitle("SuppsAI")
            .navigationDestination(for: Supplement.self) { supplement in
                SupplementDetailView(viewModel: SupplementDetailViewModel(supplement: supplement))
            }
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                Text("HOTIRGHINI VERSION")
                    .font(.caption.weight(.heavy))
                    .tracking(1.6)
                    .foregroundStyle(.black.opacity(0.75))
                Spacer()
                Text("\(viewModel.readinessScore)% ready")
                    .font(.caption.weight(.black))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.black.opacity(0.14), in: Capsule())
                    .foregroundStyle(.black)
            }
            Text(viewModel.heroTitle)
                .font(.system(size: 36, weight: .black, design: .rounded))
                .minimumScaleFactor(0.75)
                .foregroundStyle(.black)
            Text("Personalized supplement guidance with transparent evidence, safer timing, and label-aware recommendations.")
                .font(.body)
                .foregroundStyle(.black.opacity(0.75))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(HotirghiniTheme.gradient, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: HotirghiniTheme.accent.opacity(0.3), radius: 28, y: 14)
    }

    private var metricsStrip: some View {
        HStack(spacing: 12) {
            MetricPill(title: "Stack", value: "\(appState.stack.count)", icon: "pills.fill")
            MetricPill(title: "Goal", value: appState.profile.goal.rawValue, icon: "target")
            MetricPill(title: "Last scan", value: appState.latestScan.map { "\($0.riskScore) risk" } ?? "None", icon: "waveform.path.ecg")
        }
    }
}

struct MetricPill: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.caption2.weight(.bold))
                .foregroundStyle(HotirghiniTheme.mint)
            Text(value)
                .font(.caption.weight(.bold))
                .lineLimit(1)
                .foregroundStyle(HotirghiniTheme.textPrimary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(HotirghiniTheme.cardElevated.opacity(0.92), in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct SupplementRow: View {
    let supplement: Supplement
    let addAction: () -> Void

    var body: some View {
        HotirghiniCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(supplement.name)
                            .font(.headline)
                            .foregroundStyle(HotirghiniTheme.textPrimary)
                        Text(supplement.shortBenefit)
                            .font(.subheadline)
                            .foregroundStyle(HotirghiniTheme.textSecondary)
                    }
                    Spacer()
                    EvidenceBadge(level: supplement.evidenceLevel)
                }

                HStack {
                    Label(supplement.dosage, systemImage: "pills.fill")
                    Spacer()
                    Button(action: addAction) {
                        Label("Add", systemImage: "plus.circle.fill")
                            .font(.caption.weight(.bold))
                    }
                    .buttonStyle(.borderless)
                    .tint(HotirghiniTheme.mint)
                }
                .font(.caption)
                .foregroundStyle(HotirghiniTheme.textSecondary)
            }
        }
    }
}

#Preview {
    let repository = MockSupplementRepository()
    let appState = AppState(repository: repository, hasCompletedOnboarding: true)
    DashboardView(viewModel: DashboardViewModel(repository: repository, appState: appState), appState: appState)
}
