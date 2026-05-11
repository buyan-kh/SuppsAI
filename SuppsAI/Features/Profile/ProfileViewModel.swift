import Combine
import Foundation

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile
    @Published var stackCount: Int
    @Published var scanCount: Int

    init(appState: AppState) {
        profile = appState.profile
        stackCount = appState.stack.count
        scanCount = appState.scanHistory.count
    }
}
