import SwiftUI

struct OnboardingView: View {
    @StateObject var viewModel: OnboardingViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Spacer()
            Text("Build your HOTIRGHINI stack")
                .font(.largeTitle.bold())
                .foregroundStyle(HotirghiniTheme.textPrimary)
            Text("Tell SuppsAI your goals and constraints so every recommendation starts with safety, evidence, and timing.")
                .foregroundStyle(HotirghiniTheme.textSecondary)
            Picker("Goal", selection: $viewModel.selectedGoal) {
                ForEach(WellnessGoal.allCases) { goal in
                    Text(goal.rawValue).tag(goal)
                }
            }
            .pickerStyle(.wheel)
            Button("Continue") {}
                .buttonStyle(.borderedProminent)
                .tint(HotirghiniTheme.accent)
            Spacer()
        }
        .padding(24)
        .background(HotirghiniTheme.background.ignoresSafeArea())
    }
}

#Preview {
    OnboardingView(viewModel: OnboardingViewModel())
}
