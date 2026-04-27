import SwiftUI
import SwiftData

@main
struct NurseryConnectMVPApp: App {
    let container: ModelContainer

    init() {
        let schema = Schema([
            Child.self,
            DiaryEntry.self,
            AttendanceRecord.self
        ])

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to initialize SwiftData container: \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ChildrenListView()
                .modelContainer(container)
                .task {
                    SeedDataLoader.seedIfNeeded(context: container.mainContext)
                }
        }
    }
}
