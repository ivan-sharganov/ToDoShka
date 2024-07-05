import SwiftUI

struct TaskList: View {
    @State private var selectedTask: TodoItem? = nil
    @State private var showingDoneTasks = true
    @ObservedObject var cache: FileCache

    var body: some View {
        NavigationStack {
            ZStack {
                VStack{
                    DoneFilterView(tasks: $cache.tasks, showingDoneTasks: $showingDoneTasks)
                    List($cache.tasks) { $task in
                        if showingDoneTasks == true || !showingDoneTasks && !$task.wrappedValue.isDone {
                            // клетка показывается
                            // либо когда можно показать всех и она любая 
                            // либо когда НЕ показываем сделанную и она НЕ сделана
                            TaskCell(task: $task)
                                .onTapGesture {
                                    selectedTask = task
                                }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color._background)
                    .sheet(item: $selectedTask) { task in
                        TaskDetailView(task: $cache.tasks[$cache.tasks.firstIndex(where: { $0.id == task.id })!])
                    }
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
            .navigationTitle("Мои дела")
            .background(Color._background)
            .navigationBarItems(
                trailing: NavigationLink {
                    PortableView(tasks: $cache.tasks)
                } label: {
                    Image(systemName: "calendar")
                }


            )
            .background(Color._background)
        }
    }
}

struct DetailView: View {
    var body: some View {
        Text("Hello")
    }
}

struct DoneFilterView: View {
    @Binding var tasks: [TodoItem]
    @Binding var showingDoneTasks: Bool
    var body: some View {
        HStack {
            Label(
                title: { Text("Выполнено — \(tasks.filter({ $0.isDone }).count)")
                            .font(.system(size: 15))
                            .foregroundStyle(Color._labelTertiary) },
                icon: { }
            )
            Spacer()
            Button(action: {
                showingDoneTasks.toggle()
            }, label: {
                Text("Показать")
                    .font(.system(size: 15, weight: .bold))
            })
        }.padding(.horizontal)
    }
}
