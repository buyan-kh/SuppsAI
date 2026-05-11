import SwiftUI

struct StackPlannerView: View {
    @StateObject var viewModel: StackPlannerViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Plan the right supplement at the right time, with spacing reminders for common interaction risks.")
                        .font(.body)
                        .foregroundStyle(HotirghiniTheme.textSecondary)
                    stackSection(title: "Morning", icon: "sun.max.fill", items: viewModel.morning)
                    stackSection(title: "Evening", icon: "moon.stars.fill", items: viewModel.evening)
                }
                .padding(20)
            }
            .background(HotirghiniTheme.background.ignoresSafeArea())
            .navigationTitle("Stack Planner")
        }
    }

    private func stackSection(title: String, icon: String, items: [Supplement]) -> some View {
        HotirghiniCard {
            VStack(alignment: .leading, spacing: 14) {
                Label(title, systemImage: icon)
                    .font(.title3.bold())
                    .foregroundStyle(HotirghiniTheme.textPrimary)
                ForEach(items) { item in
                    HStack(alignment: .top) {
                        Circle().fill(HotirghiniTheme.accent).frame(width: 10, height: 10).padding(.top, 5)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name).font(.headline)
                            Text("\(item.dosage) • \(item.timing)").font(.caption)
                        }
                        Spacer()
                    }
                    .foregroundStyle(HotirghiniTheme.textSecondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    StackPlannerView(viewModel: StackPlannerViewModel(repository: MockSupplementRepository()))
}
