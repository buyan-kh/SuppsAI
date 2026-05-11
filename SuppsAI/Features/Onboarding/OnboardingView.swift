import SwiftUI

struct OnboardingView: View {
    @StateObject var viewModel: OnboardingViewModel
    let onComplete: (WellnessGoal, DietaryPreference, SensitivityLevel) -> Void

    var body: some View {
        ZStack {
            HotirghiniTheme.background.ignoresSafeArea()
            Circle()
                .fill(HotirghiniTheme.accent.opacity(0.34))
                .blur(radius: 70)
                .frame(width: 320, height: 320)
                .offset(x: 150, y: -260)
            Circle()
                .fill(HotirghiniTheme.mint.opacity(0.18))
                .blur(radius: 90)
                .frame(width: 360, height: 360)
                .offset(x: -150, y: 260)

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    hero
                    selectionCard(title: "Goal", systemImage: "target") {
                        segmentedPicker(selection: $viewModel.selectedGoal, values: WellnessGoal.allCases)
                    }
                    selectionCard(title: "Diet", systemImage: "leaf.fill") {
                        segmentedPicker(selection: $viewModel.selectedDiet, values: DietaryPreference.allCases)
                    }
                    selectionCard(title: "Caffeine sensitivity", systemImage: "bolt.heart.fill") {
                        segmentedPicker(selection: $viewModel.caffeineSensitivity, values: SensitivityLevel.allCases)
                    }
                    Button {
                        onComplete(viewModel.selectedGoal, viewModel.selectedDiet, viewModel.caffeineSensitivity)
                    } label: {
                        Label("Generate my stack", systemImage: "sparkles")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(HotirghiniTheme.accent)
                    .shadow(color: HotirghiniTheme.accent.opacity(0.4), radius: 18, y: 10)
                }
                .padding(24)
            }
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("HOTIRGHINI VERSION")
                .font(.caption.weight(.heavy))
                .tracking(1.8)
                .foregroundStyle(HotirghiniTheme.mint)
            Text("Build a supplement stack that actually fits you.")
                .font(.system(size: 44, weight: .black, design: .rounded))
                .minimumScaleFactor(0.75)
                .foregroundStyle(HotirghiniTheme.textPrimary)
            Text("Choose your goal and constraints. SuppsAI instantly turns seeded evidence, label-risk checks, and timing rules into a usable mock end-to-end flow.")
                .font(.body)
                .foregroundStyle(HotirghiniTheme.textSecondary)
        }
        .padding(.top, 44)
    }

    private func selectionCard<Content: View>(title: String, systemImage: String, @ViewBuilder content: () -> Content) -> some View {
        HotirghiniCard {
            VStack(alignment: .leading, spacing: 14) {
                Label(title, systemImage: systemImage)
                    .font(.headline)
                    .foregroundStyle(HotirghiniTheme.textPrimary)
                content()
            }
        }
    }

    private func segmentedPicker<Value: Hashable & Identifiable & RawRepresentable>(selection: Binding<Value>, values: [Value]) -> some View where Value.RawValue == String {
        Picker("", selection: selection) {
            ForEach(values) { value in
                Text(value.rawValue).tag(value)
            }
        }
        .pickerStyle(.menu)
        .tint(HotirghiniTheme.mint)
    }
}

#Preview {
    OnboardingView(viewModel: OnboardingViewModel()) { _, _, _ in }
}
