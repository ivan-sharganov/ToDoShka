import SwiftUI

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
