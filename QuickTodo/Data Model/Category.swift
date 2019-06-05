//
//  Category.swift
//  QuickTodo
//
//  Created by Chinmay Deshpande on 05/06/19.
//  Copyright © 2019 Chinmay Deshpande. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    
    let todoItems = List<TodoItem>()
}
