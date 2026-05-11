import SwiftUI

struct StackPlannerView: View {
    @StateObject var viewModel: StackPlannerViewModel
    @ObservedObject var appState: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    plannerHero
                    stackSection(title: "Morning", icon: "sun.max.fill", items: appState.stack.filter { $0.category != .sleep })
                    stackSection(title: "Evening", icon: "moon.stars.fill", items: appState.stack.filter { $0.category == .sleep || $0.category == .recovery })
                }
                .padding(20)
            }
            .background(HotirghiniTheme.background.ignoresSafeArea())
            .navigationTitle("Stack Planner")
        }
    }

    private var plannerHero: some View {
        HotirghiniCard {
            HStack(spacing: 16) {
                ZStack {
                    Circle().fill(HotirghiniTheme.accent.opacity(0.16))
                    Image(systemName: "calendar.badge.clock")
                        .font(.title)
                        .foregroundStyle(HotirghiniTheme.accent)
                }
                .frame(width: 64, height: 64)
                VStack(alignment: .leading, spacing: 6) {
                    Text("End-to-end stack control")
                        .font(.headline)
                        .foregroundStyle(HotirghiniTheme.textPrimary)
                    Text("Add alternatives from scans, then remove or time them here.")
                        .font(.subheadline)
                        .foregroundStyle(HotirghiniTheme.textSecondary)
                }
            }
        }
    }

    private func stackSection(title: String, icon: String, items: [Supplement]) -> some View {
        HotirghiniCard {
            VStack(alignment: .leading, spacing: 14) {
                Label(title, systemImage: icon)
                    .font(.title3.bold())
                    .foregroundStyle(HotirghiniTheme.textPrimary)
                if items.isEmpty {
                    Text("No items yet. Add a recommendation from Today or Scan.")
                        .font(.subheadline)
                        .foregroundStyle(HotirghiniTheme.textSecondary)
                }
                ForEach(items) { item in
                    HStack(alignment: .top) {
                        Circle().fill(HotirghiniTheme.accent).frame(width: 10, height: 10).padding(.top, 5)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name).font(.headline)
                            Text("\(item.dosage) • \(item.timing)").font(.caption)
                        }
                        Spacer()
                        Button {
                            viewModel.remove(item)
                        } label: {
                            Image(systemName: "minus.circle.fill")
                        }
                        .buttonStyle(.borderless)
                        .tint(.red.opacity(0.85))
                    }
                    .foregroundStyle(HotirghiniTheme.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    let repository = MockSupplementRepository()
    let appState = AppState(repository: repository, hasCompletedOnboarding: true)
    StackPlannerView(viewModel: StackPlannerViewModel(repository: repository, appState: appState), appState: appState)
}
