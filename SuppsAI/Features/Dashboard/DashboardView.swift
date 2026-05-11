import SwiftUI

struct DashboardView: View {
    @StateObject var viewModel: DashboardViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    hero

                    Text("Evidence-backed picks")
                        .font(.title2.bold())
                        .foregroundStyle(HotirghiniTheme.textPrimary)

                    ForEach(viewModel.featured) { supplement in
                        NavigationLink(value: supplement) {
                            SupplementRow(supplement: supplement)
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
        VStack(alignment: .leading, spacing: 16) {
            Text("HOTIRGHINI VERSION")
                .font(.caption.weight(.heavy))
                .tracking(1.6)
                .foregroundStyle(.black.opacity(0.75))
            Text(viewModel.heroTitle)
                .font(.largeTitle.bold())
                .foregroundStyle(.black)
            Text("Personalized supplement guidance with transparent evidence, safer timing, and label-aware recommendations.")
                .font(.body)
                .foregroundStyle(.black.opacity(0.75))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(HotirghiniTheme.gradient, in: RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
}

struct SupplementRow: View {
    let supplement: Supplement

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
                    Label(supplement.timing, systemImage: "clock.fill")
                }
                .font(.caption)
                .foregroundStyle(HotirghiniTheme.textSecondary)
            }
        }
    }
}

#Preview {
    DashboardView(viewModel: DashboardViewModel(repository: MockSupplementRepository()))
}
