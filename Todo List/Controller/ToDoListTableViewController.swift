//
//  ToDoListTableViewController.swift
//  Created by Mansa Pratap Singh on 18/04/21.
//

import UIKit

class ToDoListTableViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Item.Plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadItems()
    }
//  Todo List
//
    
    func saveData() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func reloadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder =  PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print(error)
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "protoCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].content
        cell.accessoryType = itemArray[indexPath.row].isDone ? .checkmark: .none
        return cell
    }
    
    // MARK:- TableView Delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        saveData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Item", message: "Add New Item to list.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if textField.text != "" {
                var newItem = Item()
                newItem.content = textField.text!
                self.itemArray.append(newItem)
                self.saveData()
            }
        }
                
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Write New Item"
            textField =  alertTextField
            alertTextField.autocapitalizationType = .words
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
        }
}
