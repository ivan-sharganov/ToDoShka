import Foundation

public struct TodoItem: Identifiable {

    public enum Priority: String { // Содержит обязательное поле важность, должно быть enum, может иметь три варианта — «неважная», «обычная» и «важная»
        case low
        case regular
        case high

        public var description: String {
            switch self {
            case .low: "↓"
            case .regular: "нет"
            case .high: "!!"
            }
        }

        public var intValue: Int {
            switch self {
            case .low: 0
            case .regular: 1
            case .high: 2
            }
        }
    }

    public let id: String                        // Содержит уникальный идентификатор id, если не задан пользователем — генерируется (UUID().uuidString)
    public let text: String                      // Содержит обязательное строковое поле — text
    public let priority: Priority
    public let deadline: Date?                   // Содержит дедлайн, может быть не задан, если задан — дата
    public let isDone: Bool                      // Содержит флаг того, что задача сделана
    public let creationDate: Date                // Содержит две даты — дата создания задачи (обязательна) и дата изменения (опциональна)
    public let modificationDate: Date?
    public let hexColor: String?

    public init(
        id: String = UUID().uuidString,
        text: String,
        priority: Priority = .regular,
        deadline: Date? = nil,
        isDone: Bool = false,
        creationDate: Date = Date(),
        modificationDate: Date? = nil,
        hexColor: String? = nil
    ) {

        self.id = id
        self.text = text
        self.priority = priority
        self.deadline = deadline
        self.isDone = isDone
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.hexColor = hexColor
    }
}

    // MARK: - JSON Parsing

public extension TodoItem {

    public var json: Any {
        var dict: [String: Any] = [:]
        dict["id"] = self.id
        dict["text"] = self.text
        dict["priority"] = self.priority == .regular ? nil : self.priority.rawValue
        dict["deadline"] = self.deadline?.timeIntervalSince1970
        dict["isDone"] = self.isDone
        dict["creationDate"] = self.creationDate.timeIntervalSince1970
        dict["modificationDate"] = self.modificationDate?.timeIntervalSince1970
        dict["hexColor"] = self.hexColor
        return dict
    }

    public static func parse(json: Any) -> TodoItem? {
        guard let dict = json as? [String: Any] else {
            print("🟥 failed to parse json to dict")
            return nil
        }
        guard let text = dict["text"] as? String,
              let isDone = dict["isDone"] as? Bool,
              let creationDate = (dict["creationDate"] as? TimeInterval).flatMap(Date.init(timeIntervalSince1970:)) else {
            print("🟥 missing required fields")
            return nil
        }

        let priority = (dict["priority"] as? String).flatMap(Priority.init(rawValue:)) ?? .regular
        let deadline = (dict["deadline"] as? TimeInterval).flatMap(Date.init(timeIntervalSince1970:))
        let modificationDate = (dict["modificationDate"] as? TimeInterval).flatMap(Date.init(timeIntervalSince1970:))
        let hexColor = dict["hexColor"] as? String
        let id = dict["id"] as? String
        let item = TodoItem(
            id: id ?? UUID().uuidString,
            text: text,
            priority: priority,
            deadline: deadline,
            isDone: isDone,
            creationDate: creationDate,
            modificationDate: modificationDate,
            hexColor: hexColor
        )
        return item
    }

    public func withToggledIsDone() -> TodoItem {
        return TodoItem(
            id: self.id,
            text: self.text,
            priority: self.priority,
            deadline: self.deadline,
            isDone: !self.isDone,
            creationDate: self.creationDate,
            modificationDate: self.modificationDate,
            hexColor: self.hexColor
        )
    }
    public func withIsDone(_ isDone: Bool) -> TodoItem {
        return TodoItem(
            id: self.id,
            text: self.text,
            priority: self.priority,
            deadline: self.deadline,
            isDone: isDone,
            creationDate: self.creationDate,
            modificationDate: self.modificationDate,
            hexColor: self.hexColor
        )
    }
}

extension TodoItem: Equatable {
    public static func == (lhs: TodoItem, rhs: TodoItem) -> Bool {
        return lhs.id == rhs.id &&
        lhs.text == rhs.text &&
        lhs.priority == rhs.priority &&
        lhs.deadline == rhs.deadline &&
        lhs.isDone == rhs.isDone &&
        lhs.creationDate == rhs.creationDate &&
        lhs.modificationDate == rhs.modificationDate &&
        lhs.hexColor == rhs.hexColor
    }
}
