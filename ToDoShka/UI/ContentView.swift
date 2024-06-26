import SwiftUI

struct ContentView: View {
    @StateObject var cache = FileCache.shared
    var body: some View {
        TaskList(cache: cache)
    }
}

#Preview {
    ContentView()
}
