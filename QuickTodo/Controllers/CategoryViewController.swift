//
//  CategoryViewController.swift
//  QuickTodo
//
//  Created by Chinmay Deshpande on 04/06/19.
//  Copyright © 2019 Chinmay Deshpande. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()

        loadCategories()
    }
    
    //MARK:- TableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let item = categoryArray[indexPath.row]
        
        cell.textLabel?.text = item.name
    
        return cell
    }
    
    //MARK:- TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    //MARK:- Data Manipulation methods
    func saveCategory() {
        
        do {
            
            try context.save()
        }
        catch {
            
            print("Error saving context: \(error)")
        }
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
            
            categoryArray = try context.fetch(request)
        }
        catch {
            
            print("Error fetching data from the context: \(error)")
        }
        
        tableView.reloadData()  
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To-Do Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
        
            let newItem = Category(context: self.context)
            newItem.name = textField.text!
            self.categoryArray.append(newItem)
            
            self.saveCategory()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Insert a new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

//MARK:- SearchBar methods
extension CategoryViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        loadCategories(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            
            loadCategories()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
            }
        }
    }
}
