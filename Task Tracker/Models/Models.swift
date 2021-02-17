//
//  Models.swift
//  Task Tracker
//

//

import Foundation
import RealmSwift

class User: Object {
    @objc dynamic var _id: String = ""
    @objc dynamic var _partition: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    let memberOf = RealmSwift.List<Project>()
    override static func primaryKey() -> String? {
        return "_id"
    }
}

class Project: EmbeddedObject {
    @objc dynamic var name: String? = nil
    @objc dynamic var partition: String? = nil
    convenience init(partition: String, name: String) {
        self.init()
        self.partition = partition
        self.name = name
    }
}

enum TaskStatus: String {
  case Open
  case InProgress
  case Complete
}

enum TaskPriority: String {
    case minor
    case normal
    case major
}
class Task: Object {
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    @objc dynamic var _partition: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var owner: String? = nil
    @objc dynamic var status: String = ""
    @objc dynamic var priority: String = ""
    override static func primaryKey() -> String? {
        return "_id"
    }

    var statusEnum: TaskStatus {
        get {
            return TaskStatus(rawValue: status) ?? .Open
        }
        set {
            status = newValue.rawValue
        }
    }
    
    var priorityEnum: TaskPriority {
        get {
            return TaskPriority(rawValue: priority) ?? .normal
        }
        set {
            priority = newValue.rawValue
        }
    }
    
    
    
    convenience init(partition: String, name: String) {
        self.init()
        self._partition = partition
        self.name = name
    }
}

struct Member {
    let id: String
    let name: String
    init(document: Document) {
        self.id = document["_id"]!!.stringValue!
        self.name = document["name"]!!.stringValue!
    }
}

