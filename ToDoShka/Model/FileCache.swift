import Foundation

class FileCache: ObservableObject {
    
    enum FileCacheError: Error {
        case errorSavingIntoFile
        case errorLoadingFromFile
        case errorAccessingFileDirectory
    }
    private init() {}
    static let shared = FileCache()

    @Published /*private(set)*/ var tasks: [TodoItem] = [
        TodoItem(text: "Купить сыр", isDone: true, hexColor: "#0EFFE0"),
        TodoItem(text: "Купить дом", hexColor: "#F0FF00"),
        TodoItem(text: "выкинуть сыр", isDone: true, hexColor: "#00FFE0"),
        TodoItem(text: "Купить сыр и очень много говорить гооворить гооовоооорить", isDone: true),
        TodoItem(text: "обновить сыр", isDone: true),
        TodoItem(text: "Купить сыр"),
        TodoItem(text: "продать сыр", isDone: true),
        TodoItem(text: "потерять сыр"),
        TodoItem(text: "помыть сыр"),
        TodoItem(text: "съесть сыр", isDone: true),
        TodoItem(text: "Купить сыр"),
    ]

    func add(task: TodoItem) {
        if !self.tasks.contains(where: { $0.id == task.id }) {
            self.tasks.append(task)
        }
    }

    func getTask(id: String) -> TodoItem? {
        guard let task = self.tasks.first(where: { $0.id == id }) else {
            return nil
        }
        return task
    }

    @discardableResult
     func removeTask(id: String) -> TodoItem? {
        guard let task = self.tasks.first(where: { $0.id == id }) else {
            return nil
        }
        self.tasks.removeAll { $0.id == id }
        return task
    }

     func saveTasks(url: URL) throws {
        let arrayOfDicts = self.tasks.compactMap({ $0.json })

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: arrayOfDicts, options: .prettyPrinted)
            try jsonData.write(to: url)
        } catch {
            throw FileCacheError.errorSavingIntoFile
        }
    }

     func loadTasks(url: URL) throws {
        let data = try Data(contentsOf: url)
        guard let loadedTasks = try JSONSerialization.jsonObject(with: data) as? [Any] else {
            throw FileCacheError.errorLoadingFromFile
        }

        var resultDict: [String: TodoItem] = [:]
        self.tasks.forEach {
            resultDict[$0.id] = $0
        }
        loadedTasks.compactMap({ TodoItem.parse(json: $0) }).forEach {
            resultDict[$0.id] = $0
        }
        self.tasks = Array(resultDict.values)
    }
}



