//
//  PickerViewController.swift
//  FinalExamNitinPatel
//
//  Created by Xcode User on 2020-04-04.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    
    let mainDelegate = UIApplication.shared.delegate as! AppDelegate
    
    
    @IBOutlet var tfName : UITextField!
   
    @IBOutlet var sgAvatar : UISegmentedControl!
    
   @IBOutlet var pickerView : UIPickerView!
    
    @IBOutlet var lbAge : UILabel!
    
    @IBOutlet var lbId : UILabel!
    
    var avatarVal : String = ""
    var sid : Int = 0
    @IBOutlet var imageView: UIImageView!
    
    
    
    @IBAction func addPerson(sender : Any){
        
        let person : EntryData = EntryData()
        
        person.eid = 0;
        person.name = tfName.text
        person.age = Int(lbAge.text!)!
        person.avatar = avatarVal
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let returnCode = mainDelegate.insertIntoDatabase(person: person)
        
        mainDelegate.readDataFromDatabase()
        pickerView.reloadAllComponents()
        
        var returnMSG : String = "Person Added"
        
        if returnCode == false{
            returnMSG = "Person Not Added"
        }
        
        let alertController = UIAlertController(title: "SQLite add", message: returnMSG, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
        tfName.text = ""
        
        
    }
    
    
    
    ///
    
    @IBAction func updatePerson(sender : Any){
        
        let person : EntryData = EntryData()
        
        person.eid = sid
        person.name = tfName.text
        person.age = Int(lbAge.text!)!
        person.avatar = avatarVal
        
        let mainDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let returnCode = mainDelegate.updateIntoDatabase(person: person)
        
        var returnMSG : String = "Person Updated"
        
        mainDelegate.readDataFromDatabase()
        pickerView.reloadAllComponents()
        
        let alertController = UIAlertController(title: "SQLite Update", message: returnMSG, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
       //s pickerView.reloadAllComponents()
        if returnCode == false{
            returnMSG = "Person Not Updated"
        }
        
        
    }
    
    
    
    @IBAction func slider(sender : UISlider){
        lbAge.text = String(Int(sender.value))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    
    
    func updateAvatar(){
        
        let avatar = sgAvatar.selectedSegmentIndex
        //avatarVal = "avatar1.png"
        
        if avatar == 0{
            avatarVal = "avatar1.png"
        }
            
        else if avatar == 1{
            avatarVal = "avatar2.png"
        }
        else if avatar == 2{
            avatarVal = "avatar3.jpg"
        }
        else{
            avatarVal = "avatar1.png"
        }
        
    }
    
    
    @IBAction func avatarSegmentDidChange(sender : UISegmentedControl)
    {
        updateAvatar()
    }
    
    
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mainDelegate.people.count
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //how many columns
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        sid = mainDelegate.people[row].eid
        return "\(mainDelegate.people[row].name!)  |  \(mainDelegate.people[row].age)  |  \(mainDelegate.people[row].avatar!) | \(mainDelegate.people[row].eid)"
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let alertController = UIAlertController(title: mainDelegate.people[row].name, message: "\(mainDelegate.people[row].age)", preferredStyle: .alert)
        
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
        
        var name = mainDelegate.people[row].name!
        var age = mainDelegate.people[row].age
        var avatar = mainDelegate.people[row].avatar!
        
        tfName.text = name
        lbAge.text = "\(age)"
        
        imageView.image = UIImage(named: avatar)
        //lbId.text = "ID: \(sid)"
        
        
        
        
        
        
    }
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //pickerView.delegate = self
        //pickerView.dataSource = self
         mainDelegate.readDataFromDatabase()
        updateAvatar()
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
