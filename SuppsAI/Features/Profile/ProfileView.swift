import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 10) {
                        Image(systemName: "person.crop.circle.fill.badge.checkmark")
                            .font(.system(size: 82))
                            .foregroundStyle(HotirghiniTheme.gradient)
                        Text(viewModel.profile.name)
                            .font(.largeTitle.bold())
                            .foregroundStyle(HotirghiniTheme.textPrimary)
                        Text(viewModel.profile.goal.rawValue)
                            .foregroundStyle(HotirghiniTheme.textSecondary)
                    }
                    profileCard
                    disclaimerCard
                }
                .padding(20)
            }
            .background(HotirghiniTheme.background.ignoresSafeArea())
            .navigationTitle("Profile")
        }
    }

    private var profileCard: some View {
        HotirghiniCard {
            VStack(alignment: .leading, spacing: 14) {
                settingRow("Diet", value: viewModel.profile.dietaryPreference.rawValue, icon: "fork.knife")
                settingRow("Caffeine", value: viewModel.profile.caffeineSensitivity.rawValue, icon: "cup.and.saucer.fill")
                settingRow("Stack items", value: "\(viewModel.profile.currentStack.count)", icon: "pills.fill")
            }
        }
    }

    private var disclaimerCard: some View {
        HotirghiniCard {
            Text("SuppsAI is an education and planning tool, not medical advice. Check all supplements with a qualified clinician, especially when pregnant, treating a condition, or taking medication.")
                .font(.footnote)
                .foregroundStyle(HotirghiniTheme.textSecondary)
        }
    }

    private func settingRow(_ title: String, value: String, icon: String) -> some View {
        HStack {
            Label(title, systemImage: icon)
            Spacer()
            Text(value).bold()
        }
        .foregroundStyle(HotirghiniTheme.textPrimary)
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel(repository: MockSupplementRepository()))
}
