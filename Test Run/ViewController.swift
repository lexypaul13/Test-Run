//
//  ViewController.swift
//  Test Run
//
//  Created by Alex Paul on 2/9/22.
//

import UIKit

class ViewController: UIViewController{
    let networkService = NetworkService.shared
    var names = [String]()
    var tags =  [String]()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        getNamesAndTags()
        // Do any additional setup after loading the view.
    }
    
    func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func actionOnAddNewName(_ sender: UIButton) {
        if let text = nameTextField.text, text != "" {
            self.view.endEditing(true)
            self.addData(name: text)
        }
    }
    
    
    func addData(name: String) {
        networkService.addData(name: name, completion: {  [weak self] (err)  in
            guard let self = self else { return}
            if let error = err {
                print("Failed to fetch courses:", error)
                return
            }
            self.nameTextField.text = ""
            self.getNamesAndTags()
        })
    }
    
    
    func getNamesAndTags(){
        names = [String]()
        tags =  [String]()
        networkService.getJSON {  [weak self] (results,err)  in
            guard let self = self else { return}
            if let error = err {
                print("Failed to fetch courses:", error)
                return
            }
            
            guard let results = results else {return}

            for result in results {
                let name = result.properties.name.title.first?.text.content ?? ""
                let tag = result.properties.tags.multiSelect.map { $0.name }
                self.names.append(name)
                self.tags.append(tag.joined(separator: ", "))
            }
            print(self.names)
            self.tableView.reloadData()
        }

    }

}
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ProductsTableViewCell
        cell.nameLabel.text = names[indexPath.row]
        cell.tagsLabel.text = tags[indexPath.row]
        
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    
}
