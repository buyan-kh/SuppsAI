import SwiftUI

struct RootTabView: View {
    @ObservedObject var container: AppContainer
    @ObservedObject private var appState: AppState

    init(container: AppContainer) {
        self.container = container
        self._appState = ObservedObject(wrappedValue: container.appState)
    }

    var body: some View {
        Group {
            if appState.hasCompletedOnboarding {
                mainTabs
            } else {
                OnboardingView(
                    viewModel: OnboardingViewModel(profile: appState.profile),
                    onComplete: appState.completeOnboarding
                )
            }
        }
        .animation(.spring(response: 0.45, dampingFraction: 0.86), value: appState.hasCompletedOnboarding)
    }

    private var mainTabs: some View {
        TabView {
            DashboardView(viewModel: DashboardViewModel(repository: container.repository, appState: appState), appState: appState)
                .tabItem { Label("Today", systemImage: "sparkles") }
            ScanLabelView(viewModel: ScanLabelViewModel(repository: container.repository, aiService: container.aiService, labelAnalyzer: container.labelAnalyzer, appState: appState))
                .tabItem { Label("Scan", systemImage: "viewfinder") }
            StackPlannerView(viewModel: StackPlannerViewModel(repository: container.repository, appState: appState), appState: appState)
                .tabItem { Label("Stack", systemImage: "calendar.badge.clock") }
            ProfileView(viewModel: ProfileViewModel(appState: appState), appState: appState)
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
        .tint(HotirghiniTheme.accent)
    }
}

#Preview("First launch") {
    RootTabView(container: AppContainer())
}

#Preview("Completed onboarding") {
    RootTabView(container: AppContainer(hasCompletedOnboarding: true))
}
