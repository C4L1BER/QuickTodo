//
//  ViewController.swift
//  QuickTodo
//
//  Created by Chinmay Deshpande on 02/06/19.
//  Copyright © 2019 Chinmay Deshpande. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [TodoItem]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let newItem = TodoItem()
        newItem.title = "One"
        newItem.done = true
        itemArray.append(newItem)
        
        let newItem2 = TodoItem()
        newItem2.title = "Two"
        itemArray.append(newItem2)
        
        let newItem3 = TodoItem()
        newItem3.title = "Three"
        itemArray.append(newItem3)
        
        let newItem4 = TodoItem()
        newItem4.title = "Four"
        itemArray.append(newItem4)
        
        /*if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            
            itemArray = items
        }*/
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print("Selected item: \(itemArray[indexPath.row])")
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To-Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //print(textField.text!)
            
            let newItem = TodoItem()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Insert a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

