//
//  Tasks.swift
//  Task Tracker
//
//

import Foundation

struct Tasks: Codable, Hashable {
    var Assignee: String?
    var Description: String?
    var Priority: String?
    var Reporter: String?
    var Status: String?
    var taskId: Int?
    var teamName: String?
    var Title: String?
    var userName: String?
    var plannedDate: String?
    
}
