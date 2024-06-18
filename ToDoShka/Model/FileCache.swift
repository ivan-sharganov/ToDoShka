import Foundation

class FileCache {
    
    enum FileCacheError: Error {
        case errorSavingIntoFile
        case errorLoadingFromFile
        case errorAccessingFileDirectory
    }
    private init() {}
    
    private(set) static var tasks: [TodoItem] = []

    static func add(task: TodoItem) {
        if !self.tasks.contains(where: { $0.id == task.id }) {
            self.tasks.append(task)
        }
    }

    @discardableResult
    static func removeTask(id: String) -> TodoItem? {
        guard let task = self.tasks.first(where: { $0.id == id }) else {
            return nil
        }
        self.tasks.removeAll { $0.id == id }
        return task
    }

    static func saveTasks(url: URL) throws {
        let arrayOfDicts = self.tasks.compactMap({ $0.json })

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: arrayOfDicts, options: .prettyPrinted)
            try jsonData.write(to: url)
        } catch {
            throw FileCacheError.errorSavingIntoFile
        }
    }

    static func loadTasks(url: URL) throws {
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



