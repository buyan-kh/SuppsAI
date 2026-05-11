import SwiftUI

struct RootTabView: View {
    @ObservedObject var container: AppContainer

    var body: some View {
        TabView {
            DashboardView(viewModel: DashboardViewModel(repository: container.repository))
                .tabItem { Label("Today", systemImage: "sparkles") }
            ScanLabelView(viewModel: ScanLabelViewModel(repository: container.repository, aiService: container.aiService))
                .tabItem { Label("Scan", systemImage: "viewfinder") }
            StackPlannerView(viewModel: StackPlannerViewModel(repository: container.repository))
                .tabItem { Label("Stack", systemImage: "calendar.badge.clock") }
            ProfileView(viewModel: ProfileViewModel(repository: container.repository))
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
        }
        .tint(HotirghiniTheme.accent)
    }
}

#Preview {
    RootTabView(container: AppContainer())
}
