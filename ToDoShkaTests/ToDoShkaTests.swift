import XCTest
@testable import ToDoShka

final class TodoItemTests: XCTestCase {
    func testTodoItemInitialization() {
        let creationDate = Date()
        let task = TodoItem(
            id: "1",
            text: "Test Task",
            priority: .regular,
            deadline: nil,
            isDone: false,
            creationDate: creationDate,
            modificationDate: nil
        )

        XCTAssertEqual(task.id, "1")
        XCTAssertEqual(task.text, "Test Task")
        XCTAssertEqual(task.priority, .regular)
        XCTAssertNil(task.deadline)
        XCTAssertFalse(task.isDone)
        XCTAssertEqual(task.creationDate, creationDate)
        XCTAssertNil(task.modificationDate)
    }

    func testTodoItemJSONParsing() {
        let task = TodoItem(
            id: "1",
            text: "Test Task",
            priority: .high,
            deadline: nil,
            isDone: false,
            creationDate: Date(timeIntervalSince1970: 1),
            modificationDate: nil
        )
        guard let parsedTask = TodoItem.parse(json: task.json) else {
            XCTFail()
            return
        }
        XCTAssertEqual(task, parsedTask)
    }

}

class FileCacheTests: XCTestCase {
    func testFileCacheAddAndRemove() {
        let id = "test_id"
        let initialTasksCount = FileCache.tasks.count
        let task = TodoItem(id: id, text: "Test Task", priority: .regular, deadline: nil, isDone: false, creationDate: Date(timeIntervalSince1970: 1), modificationDate: nil)

        FileCache.add(task: task)
        XCTAssertEqual(FileCache.tasks.count, initialTasksCount + 1)

        FileCache.removeTask(id: id)
        XCTAssertEqual(FileCache.tasks.count, initialTasksCount)

    }

    func testAddDuplicateTodoItem() {
        let initialTasksCount = FileCache.tasks.count
        let task1 = TodoItem(
            id: "unique1",
            text: "Test Task 1",
            priority: .regular,
            deadline: nil,
            isDone: false,
            creationDate: Date(),
            modificationDate: nil
        )
        let task2 = TodoItem(
            id: "unique1",
            text: "Test Task 2",
            priority: .high,
            deadline: Date(),
            isDone: true,
            creationDate: Date(),
            modificationDate: Date()
        )

        FileCache.add(task: task1)
        FileCache.add(task: task2)

        XCTAssertEqual(FileCache.tasks.count, initialTasksCount + 1)
    }
    func testSaveToFile() {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("cache.json")
        let todo = TodoItem(
            id: "1",
            text: "Test Task",
            priority: .regular,
            deadline: nil,
            isDone: false,
            creationDate: Date(),
            modificationDate: nil
        )

        FileCache.add(task: todo)

        do {
            try FileCache.saveTasks(url: url)
            XCTAssertTrue(FileManager.default.fileExists(atPath: url.path))
        } catch {
            XCTFail("Saving to file failed")
        }
    }

    func testSaveAndLoadFromCache() {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("cache.json")

        let task1 = TodoItem(
            id: "unique1",
            text: "Test Task 1",
            priority: .regular,
            deadline: nil,
            isDone: false,
            creationDate: Date(),
            modificationDate: nil
        )
        let task2 = TodoItem(
            id: "unique1",
            text: "Test Task 2",
            priority: .high,
            deadline: Date(),
            isDone: true,
            creationDate: Date(timeIntervalSince1970: 2),
            modificationDate: Date()
        )

        FileCache.add(task: task1)
        FileCache.add(task: task2)
        let tasksBefore = FileCache.tasks.sorted(by: { $0.id < $1.id })
        try! FileCache.saveTasks(url: url)
        try! FileCache.loadTasks(url: url)
        let tasksAfter = FileCache.tasks.sorted(by: { $0.id < $1.id })

        XCTAssertEqual(tasksBefore.map { $0.id }, tasksAfter.map { $0.id })

    }
}
