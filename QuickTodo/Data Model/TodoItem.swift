//
//  TodoItem.swift
//  QuickTodo
//
//  Created by Chinmay Deshpande on 05/06/19.
//  Copyright © 2019 Chinmay Deshpande. All rights reserved.
//

import Foundation
import RealmSwift

class TodoItem: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "todoItems")
}
