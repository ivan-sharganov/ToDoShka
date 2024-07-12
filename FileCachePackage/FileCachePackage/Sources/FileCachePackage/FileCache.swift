import Foundation

public class FileCache: ObservableObject {
    
    enum FileCacheError: Error {
        case errorSavingIntoFile
        case errorLoadingFromFile
        case errorAccessingFileDirectory
    }
    private init() {}
    public static let shared = FileCache()

    @Published public var tasks: [TodoItem] = [
        TodoItem(id: UUID().uuidString, text: "Задача 1", priority: .regular, deadline: Date(timeIntervalSince1970: 1), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: "#0EFFE0"),
        TodoItem(id: UUID().uuidString, text: "Задача 1", priority: .regular, deadline: Date(timeIntervalSince1970: 1), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: "#0EFFE0"),

        TodoItem(id: UUID().uuidString, text: "Задача 1", priority: .regular, deadline: Date(timeIntervalSince1970: 1), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: "#0EFFE0"),

        TodoItem(id: UUID().uuidString, text: "Задача 1", priority: .regular, deadline: Date(timeIntervalSince1970: 1), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: "#0EFFE0"),

        TodoItem(id: UUID().uuidString, text: "Задача 1", priority: .regular, deadline: Date(timeIntervalSince1970: 1), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: "#0EFFE0"),

        TodoItem(id: UUID().uuidString, text: "Задача 1", priority: .regular, deadline: Date(timeIntervalSince1970: 1), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: "#0EFFE0"),

        TodoItem(id: UUID().uuidString, text: "Задача 1", priority: .regular, deadline: Date(timeIntervalSince1970: 1), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: "#0EFFE0"),

        TodoItem(id: UUID().uuidString, text: "Задача 1", priority: .regular, deadline: Date(timeIntervalSince1970: 1), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: "#0EFFE0"),

        TodoItem(id: UUID().uuidString, text: "Задача 1", priority: .regular, deadline: Date(timeIntervalSince1970: 1), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: "#0EFFE0"),

        TodoItem(id: UUID().uuidString, text: "Задача 1", priority: .regular, deadline: Date(timeIntervalSince1970: 1), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: "#0EFFE0"),

        TodoItem(id: UUID().uuidString, text: "Задача 2", priority: .low, deadline: Date(timeIntervalSince1970: 2), isDone: false, creationDate: Date(), modificationDate: nil, hexColor: "#F0FF00"),
        TodoItem(id: UUID().uuidString, text: "Задача 3", priority: .high, deadline: Date(timeIntervalSince1970: 86400 * 2), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: "#00FFE0"),
        TodoItem(id: UUID().uuidString, text: "Задача 4", priority: .regular, deadline: Date(timeIntervalSince1970: 86400 * 3), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: nil),
        TodoItem(id: UUID().uuidString, text: "Задача 5", priority: .low, deadline: Date(timeIntervalSince1970: 86400 * 4), isDone: false, creationDate: Date(), modificationDate: nil, hexColor: "#FF0000"),
        TodoItem(id: UUID().uuidString, text: "Задача 6", priority: .high, deadline: Date(timeIntervalSince1970: 86400 * 5), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: nil),
        TodoItem(id: UUID().uuidString, text: "Задача 7", priority: .regular, deadline: Date(timeIntervalSince1970: 86400 * 6), isDone: false, creationDate: Date(), modificationDate: nil, hexColor: "#0EFFE0"),
        TodoItem(id: UUID().uuidString, text: "Задача 8", priority: .low, deadline: Date(timeIntervalSince1970: 86400 * 7), isDone: false, creationDate: Date(), modificationDate: nil, hexColor: nil),
        TodoItem(id: UUID().uuidString, text: "Задача 9", priority: .high, deadline: Date(timeIntervalSince1970: 86400 * 8), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: "#00FFE0"),
        TodoItem(id: UUID().uuidString, text: "Задача 10", priority: .regular, deadline: Date(timeIntervalSince1970: 86400 * 9), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: nil),
        TodoItem(id: UUID().uuidString, text: "Задача 11", priority: .low, deadline: Date(timeIntervalSince1970: 86400 * 10), isDone: false, creationDate: Date(), modificationDate: nil, hexColor: "#F0FF00"),
        TodoItem(id: UUID().uuidString, text: "Задача 12", priority: .high, deadline: Date(timeIntervalSince1970: 86400 * 11), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: nil),
        TodoItem(id: UUID().uuidString, text: "Задача 13", priority: .regular, deadline: Date(timeIntervalSince1970: 86400 * 12), isDone: false, creationDate: Date(), modificationDate: nil, hexColor: "#FF0000"),
        TodoItem(id: UUID().uuidString, text: "Задача 14", priority: .low, deadline: Date(timeIntervalSince1970: 86400 * 13), isDone: false, creationDate: Date(), modificationDate: nil, hexColor: "#0EFFE0"),
        TodoItem(id: UUID().uuidString, text: "Задача 15", priority: .high, deadline: Date(timeIntervalSince1970: 86400 * 14), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: nil),
        TodoItem(id: UUID().uuidString, text: "Задача 16", priority: .regular, deadline: Date(timeIntervalSince1970: 86400 * 15), isDone: false, creationDate: Date(), modificationDate: nil, hexColor: "#F0FF00"),
        TodoItem(id: UUID().uuidString, text: "Задача 17", priority: .low, deadline: Date(timeIntervalSince1970: 86400 * 16), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: nil),
        TodoItem(id: UUID().uuidString, text: "Задача 18", priority: .high, deadline: Date(timeIntervalSince1970: 86400 * 17), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: "#00FFE0"),
        TodoItem(id: UUID().uuidString, text: "Задача 19", priority: .regular, deadline: Date(timeIntervalSince1970: 86400 * 18), isDone: false, creationDate: Date(), modificationDate: nil, hexColor: nil),
        TodoItem(id: UUID().uuidString, text: "Задача 20", priority: .low, deadline: Date(timeIntervalSince1970: 86400 * 19), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: "#FF0000"),
        TodoItem(id: UUID().uuidString, text: "Задача 21", priority: .high, deadline: Date(timeIntervalSince1970: 86400 * 20), isDone: false, creationDate: Date(), modificationDate: nil, hexColor: nil),
        TodoItem(id: UUID().uuidString, text: "Задача 22", priority: .regular, deadline: Date(timeIntervalSince1970: 86400 * 21), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: "#0EFFE0"),
        TodoItem(id: UUID().uuidString, text: "Задача 23", priority: .low, deadline: Date(timeIntervalSince1970: 86400 * 22), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: "#F0FF00"),
        TodoItem(id: UUID().uuidString, text: "Задача 24", priority: .high, deadline: Date(timeIntervalSince1970: 86400 * 23), isDone: false, creationDate: Date(), modificationDate: nil, hexColor: nil),
        TodoItem(id: UUID().uuidString, text: "Задача 25", priority: .regular, deadline: Date(timeIntervalSince1970: 86400 * 24), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: nil),
        TodoItem(id: UUID().uuidString, text: "Задача 26", priority: .low, deadline: Date(timeIntervalSince1970: 86400 * 25), isDone: false, creationDate: Date(), modificationDate: nil, hexColor: "#00FFE0"),
        TodoItem(id: UUID().uuidString, text: "Задача 27", priority: .high, deadline: Date(timeIntervalSince1970: 86400 * 26), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: nil),
        TodoItem(id: UUID().uuidString, text: "Задача 28", priority: .regular, deadline: Date(timeIntervalSince1970: 86400 * 27), isDone: false, creationDate: Date(), modificationDate: nil, hexColor: "#FF0000"),
        TodoItem(id: UUID().uuidString, text: "Задача 29", priority: .low, deadline: Date(timeIntervalSince1970: 86400 * 28), isDone: true, creationDate: Date(), modificationDate: nil, hexColor: "#0EFFE0"),
        TodoItem(id: UUID().uuidString, text: "Задача 30", priority: .high, isDone: false, creationDate: Date(), modificationDate: nil, hexColor: "#F0FF00"),
        TodoItem(id: UUID().uuidString, text: "Задача 30", priority: .high, isDone: false, creationDate: Date(), modificationDate: nil, hexColor: "#F0FF00"),
        TodoItem(id: UUID().uuidString, text: "Задача 30", priority: .high, isDone: false, creationDate: Date(), modificationDate: nil, hexColor: "#F0FF00"),
        TodoItem(id: UUID().uuidString, text: "Задача 30", priority: .high, isDone: false, creationDate: Date(), modificationDate: nil, hexColor: "#F0FF00"),
        TodoItem(id: UUID().uuidString, text: "Задача 30", priority: .high, isDone: false, creationDate: Date(), modificationDate: nil, hexColor: "#F0FF00"),
    ]

    public func add(task: TodoItem) {
        if !self.tasks.contains(where: { $0.id == task.id }) {
            self.tasks.append(task)
        }
    }

    public func getTask(id: String) -> TodoItem? {
        guard let task = self.tasks.first(where: { $0.id == id }) else {
            return nil
        }
        return task
    }

    @discardableResult
    public func removeTask(id: String) -> TodoItem? {
        guard let task = self.tasks.first(where: { $0.id == id }) else {
            return nil
        }
        self.tasks.removeAll { $0.id == id }
        return task
    }

    public func saveTasks(url: URL) throws {
        let arrayOfDicts = self.tasks.compactMap({ $0.json })

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: arrayOfDicts, options: .prettyPrinted)
            try jsonData.write(to: url)
        } catch {
            throw FileCacheError.errorSavingIntoFile
        }
    }

    public func loadTasks(url: URL) throws {
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
