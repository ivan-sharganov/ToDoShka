import SwiftUI

struct TaskCell: View {
    @Binding var task: TodoItem
    @State var isDone: Bool

    init(task: Binding<TodoItem>) {
        _task = task
        _isDone = State(initialValue: task.wrappedValue.isDone)
    }
    var body: some View {
        HStack {
            Button(action: {
                let isDone = !task.isDone
                task = TodoItem(
                    id: task.id,
                    text: task.text,
                    priority: task.priority,
                    deadline: task.deadline,
                    isDone: isDone,
                    creationDate: task.creationDate,
                    modificationDate: task.modificationDate,
                    hexColor: task.hexColor
                )
            }) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(task.isDone ? .green : task.priority == .high ? .red : .gray)
            }
            .buttonStyle(BorderlessButtonStyle())

            Spacer().frame(maxWidth: 10)
            Text((task.priority == .high ? "‼️" : "") + task.text)
                .font(.system(size: 17))
            Spacer()
            if let hex = task.hexColor {
                Circle()
                    .fill(Color(hex: hex))
                    .frame(width: 10, height: 10)
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            }
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .frame(height: 48)
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button(action: {

            }, label: {
                Image(systemName: "checkmark.circle.fill")
            })
            .tint(.green)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(action: {
                FileCache.shared.removeTask(id: task.id)
            }, label: {
                Image(systemName: "trash")
            })
            .tint(.red)
            Button(action: {

            }, label: {
                Image(systemName: "info.circle.fill")
            })
        }
    }
}
