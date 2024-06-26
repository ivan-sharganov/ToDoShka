import SwiftUI

struct TaskList: View {
    @State private var selectedTask: TodoItem? = nil
    @ObservedObject var cache: FileCache

    var body: some View {
        NavigationView {
            ZStack {

                List($cache.tasks) { $task in
                    TaskCell(task: $task)
                        .onTapGesture {
                            selectedTask = task
                        }
                }
                .scrollContentBackground(.hidden)
                .background(Color._background)
                .sheet(item: $selectedTask) { task in
                    TaskDetailView(task: $cache.tasks[$cache.tasks.firstIndex(where: { $0.id == task.id })!])
                }
                VStack {
                    Spacer()
                    Button(action: {
                        let task = TodoItem(text: "")
                        FileCache.shared.add(task: task)
                        selectedTask = task
                    }, label: {
                        ZStack {
                            Circle()
                                .fill(.blue)
                                .frame(width: 50, height: 50)
                                .shadow(radius: 5)
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)

                        }
                    })
                    .shadow(radius: 10)
                    .padding(.bottom, 30)
                }

            }
            .navigationTitle("Tasks")
        }

    }
}
