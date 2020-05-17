//
//  TableViewController.swift
//  FinalExamNitinPatel
//
//  Created by Xcode User on 2020-04-04.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var tableView : UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDelegate.people.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SiteCell ?? SiteCell(style: .default, reuseIdentifier: "cell")
        
        let rowNum = indexPath.row
        
        tableCell.primaryLabel.text = mainDelegate.people[rowNum].name
        //tableCell.secondaryLabel.text = mainDelegate.people[rowNum].age
        tableCell.secondaryLabel.text = "age"
        tableCell.myImageView.image = UIImage(named: (mainDelegate.people[rowNum].avatar ?? nil)!)
        
        tableCell.accessoryType = .disclosureIndicator
        
        return tableCell
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //find row num
        let rowNum = indexPath.row
        
        
        let alertController = UIAlertController(title: mainDelegate.people[rowNum].name, message: "mainDelegate.people[rowNum].age", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
        
    }
    
    //right swipe
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        var sid = mainDelegate.people[indexPath.row].eid
        let delete = UITableViewRowAction(style: .normal, title: "Delete", handler:
        {action, index in
            print("Delete Button Tapped")
            //let person : Data = Data.init()
            let mainDelegate = UIApplication.shared.delegate as! AppDelegate
            mainDelegate.deleteFromDatabase(id: sid)
            mainDelegate.readDataFromDatabase()
            tableView.reloadData()
            
        })
        delete.backgroundColor = .red
        
        return [delete]
    }
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        mainDelegate.readDataFromDatabase()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}




