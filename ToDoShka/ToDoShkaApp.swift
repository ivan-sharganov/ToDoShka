import SwiftUI
import CocoaLumberjackSwift

@main
struct ToDoShkaApp: App {
    
    var body: some Scene {
        return WindowGroup {

            ContentView().onAppear {
                DDLog.add(DDTTYLogger.sharedInstance!)
            }
        }
    }
}
