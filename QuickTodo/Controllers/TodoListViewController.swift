//
//  ViewController.swift
//  QuickTodo
//
//  Created by Chinmay Deshpande on 02/06/19.
//  Copyright © 2019 Chinmay Deshpande. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [TodoItem]()
    var selectedCategory : Category? {
        
        didSet {
            
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    //MARK:- TableView DataSource methods
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
    
    //MARK:- TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //print("Selected item: \(itemArray[indexPath.row])")
        
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems()
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK:- Add new Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To-Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = TodoItem(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
            self.saveItems()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Insert a new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        
        do {
            
            try context.save()
        }
        catch {
            
            print("Error saving context: \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate.init(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else {
            
            request.predicate = categoryPredicate
        }
    
        do {
            
            itemArray = try context.fetch(request)
        }
        catch {
            
            print("Error fetching data from the context: \(error)")
        }
        
        tableView.reloadData()
    }
}

//MARK: - SearchBar methods
extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
            }
        }
    }
}



