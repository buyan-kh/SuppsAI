import SwiftUI

@main
struct SuppsAIApp: App {
    @StateObject private var container = AppContainer()

    var body: some Scene {
        WindowGroup {
            RootTabView(container: container)
        }
    }
}
