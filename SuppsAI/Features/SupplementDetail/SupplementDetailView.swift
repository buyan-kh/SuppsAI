import SwiftUI

struct SupplementDetailView: View {
    @StateObject var viewModel: SupplementDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text(viewModel.supplement.category.rawValue)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(HotirghiniTheme.mint)
                        Spacer()
                        EvidenceBadge(level: viewModel.supplement.evidenceLevel)
                    }
                    Text(viewModel.supplement.name)
                        .font(.largeTitle.bold())
                        .foregroundStyle(HotirghiniTheme.textPrimary)
                    Text(viewModel.supplement.summary)
                        .foregroundStyle(HotirghiniTheme.textSecondary)
                }

                detailCard(title: "Suggested use", systemImage: "calendar") {
                    Label(viewModel.supplement.dosage, systemImage: "pills")
                    Label(viewModel.supplement.timing, systemImage: "clock")
                }

                detailCard(title: "Safety notes", systemImage: "shield.lefthalf.filled") {
                    ForEach(viewModel.supplement.safetyNotes, id: \.self) { note in
                        Label(note, systemImage: "checkmark.seal")
                    }
                }

                detailCard(title: "Interactions to check", systemImage: "exclamationmark.triangle") {
                    ForEach(viewModel.supplement.interactions, id: \.self) { interaction in
                        Label(interaction, systemImage: "info.circle")
                    }
                }
            }
            .padding(20)
        }
        .background(HotirghiniTheme.background.ignoresSafeArea())
        .navigationTitle("Guide")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func detailCard<Content: View>(title: String, systemImage: String, @ViewBuilder content: () -> Content) -> some View {
        HotirghiniCard {
            VStack(alignment: .leading, spacing: 12) {
                Label(title, systemImage: systemImage)
                    .font(.headline)
                    .foregroundStyle(HotirghiniTheme.textPrimary)
                VStack(alignment: .leading, spacing: 10) {
                    content()
                }
                .font(.subheadline)
                .foregroundStyle(HotirghiniTheme.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    NavigationStack {
        SupplementDetailView(
            viewModel: SupplementDetailViewModel(supplement: MockSupplementRepository.seedSupplements[0])
        )
    }
}
