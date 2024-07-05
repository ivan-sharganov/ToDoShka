import SwiftUI

struct TaskDetailView: View {
    @Binding var task: TodoItem
    @State private var text: String
    @State private var deadline: Date?
    @State private var priority: TodoItem.Priority
    @State private var showingDatePicker = false
    @State private var isEmptyTextfield = true
    @State private var selectedColor: Color
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.colorScheme) var colorScheme

    init(task: Binding<TodoItem>) {
        _task = task
        _text = State(initialValue: task.wrappedValue.text)
        _deadline = State(initialValue: task.wrappedValue.deadline)
        _priority = State(initialValue: task.wrappedValue.priority)
        _selectedColor = State(initialValue: Color(hex: task.wrappedValue.hexColor ?? "#FF0000" ))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {

                    TextField("Что надо сделать?", text: $text, axis: .vertical)

                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(12)
                        .background(Color._field)
                        .cornerRadius(16)
                        .padding(.horizontal)
                        .onAppear() {
                            isEmptyTextfield = text.isEmpty
                        }
                        .onChange(of: text) {
                            isEmptyTextfield = text.isEmpty
                        }
                    VStack {
                        Spacer()
                        PrioritySection(priority: $priority)
                            .frame(height: 48)
                        Spacer()
                        Divider()
                            .padding(.horizontal, 16)
                        Spacer()

                        DeadlineSection(deadline: $deadline, showingDatePicker: $showingDatePicker)
                            .frame(height: 48)
                        Divider()
                            .padding(.horizontal, 16)
                        Spacer()
                        ColorPickerView(selectedColor: $selectedColor).frame(height: 48)
                        Spacer()
                        if let safeDeadline = $deadline.wrappedValue ,
                           showingDatePicker  {
                            DatePicker(
                                "",
                                selection: Binding(
                                    get: {
                                        safeDeadline
                                    }, set: {
                                        deadline = $0
                                    }
                                ),
                                displayedComponents: .date
                            )
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding(.horizontal)
                        }
                    }
                    .scrollSection()

                    Button(action: {
                        FileCache.shared.removeTask(id: task.id)
                        presentationMode.wrappedValue.dismiss()

                    }) {
                        HStack {
                            Spacer()
                            Text("Удалить")
                                .foregroundColor(.red)

                            Spacer()
                        }
                    }
                    .frame(height: 48)
                    .scrollSection()
                    Spacer()
                }
            }
            .navigationTitle("Дело")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Отменить") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Сохранить") {
                    task = TodoItem(id: task.id, text: text, priority: priority, deadline: deadline, isDone: task.isDone, hexColor: selectedColor.toHex())
                    presentationMode.wrappedValue.dismiss()
                    let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("TodoCache.json")
                    try? FileCache.shared.saveTasks(url: url)
                }
                    .disabled(isEmptyTextfield)
            )
            .background(Color._background)
        }

    }
}


struct PrioritySection: View {
    @Binding var priority: TodoItem.Priority
    var body: some View {
        HStack {
            Text("Важность")
            Spacer()
            Picker("Важность", selection: $priority) {
                ForEach([TodoItem.Priority.low, TodoItem.Priority.regular, TodoItem.Priority.high], id: \.self) { priority in
                    Text(priority.description)
                        .foregroundColor(priority == .high ? .red : .primary)
                        .tag(priority)
                }
            }
            .frame(maxWidth: 120)
            .pickerStyle(SegmentedPickerStyle())

        }
        .padding(.horizontal)
    }

}


struct DeadlineSection: View {
    @Binding var deadline: Date?
    @Binding var showingDatePicker: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Toggle(isOn: Binding(
                get: { deadline != nil },
                set: { if $0 { deadline = Calendar.current.date(byAdding: .day, value: 1, to: Date())! } else { deadline = nil } }
            )) {
                VStack(alignment: .leading) {
                    Text("Сделать до")
                    Button(action: { showingDatePicker.toggle() }) {
                        if let deadline {
                            Text(deadline, style: .date)
                                .font(
                                    .system(size: 13)
                                    .bold()
                                )
                                .foregroundColor(.blue)
                        }
                    }
                }
            }

        }
        .padding(.horizontal)
    }
}

struct ScrollSectionModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color._field)
            .cornerRadius(16)
            .padding(.horizontal)
    }
}
extension View {
    func scrollSection() -> some View {
        self.modifier(ScrollSectionModifier())
    }
}

#Preview {
    ContentView()
}

