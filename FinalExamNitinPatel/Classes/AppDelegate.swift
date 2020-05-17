//
//  AppDelegate.swift
//  FinalExamNitinPatel
//
//  Created by Xcode User on 2020-04-04.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit
import SQLite3

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var databaseName : String? = "FinalExamDatabase.db"
    var databasePath : String?
    var people : [EntryData] = []


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        //find document folder to save database file in document folder
        let documentPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        //first index is doument dir
        let documentDir = documentPaths[0]
        //appened database name
        databasePath = documentDir.appending("/" + databaseName!) //obj-C has appended path component which automatically insert / for us
        
        //check file exist or not
        //meaning running for 1st time or not
        //if 1st time we need to copy database in document folder
        
        
        
        
        
        checkAndCreateDatabase()
        
        readDataFromDatabase()
        
        
        return true
    }
    
    
    //read data from datbase
    func readDataFromDatabase() {
        
        //empty out people array to avoid duplicate data
        people.removeAll()
        
        //need a variable to point database object
        var db : OpaquePointer? = nil
        
        //open connection to database
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            print("Successfully open connection at \(self.databasePath)")
            //setup query
            //1. we need query statement - of type OpaquePointer
            
            var queryStatement : OpaquePointer? = nil
            
            var queryStatementString : String = "select * from entries"
            
            //malloc memory for querystatement and embedded querystring inside
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    
                    //extract row - embedded it into data object - then put dataobject into people array
                    let id : Int = Int(sqlite3_column_int(queryStatement, 0))
                    let cname = sqlite3_column_text(queryStatement, 1)
                    let age : Int = Int(sqlite3_column_int(queryStatement, 2))
                    let cavatar = sqlite3_column_text(queryStatement, 3)
                    
                    
                    //convert them into regular string - they are cstrings
                    let name = String(cString: cname!)
                    let avatar = String(cString: cavatar!)
                    
                    // embedded it to data object
                    let data : EntryData = EntryData()
                    data.eid = id
                    data.name = name
                    data.age = age
                    data.avatar = avatar
                    //add to people array
                    people.append(data)
                    
                    
                    print("Query result...")
                    print("\(id) | \(name) | \(age) | \(avatar)")
                    
                   
                    
                }
                
                 sqlite3_finalize(queryStatement)
                
                
            }
            else{
                print("Select statement not working")
            }
            
            sqlite3_close(db)
            
        }
        else{
            print("Unable to open database")
        }
        
    }
    
    
    
    
    //insert into database
    func insertIntoDatabase(person : EntryData) -> Bool{
        
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            var insertStatement : OpaquePointer? = nil
            var insertStatementString : String = "insert into entries values (NULL, ?, ?, ?)"
            
            if sqlite3_prepare(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                
                //name email is string - convert string to NSString and string to cstring
                
                let nameStr = person.name as NSString
                let ageInt = person.age as NSInteger
                let avatarStr = person.avatar as NSString
                
                
                sqlite3_bind_text(insertStatement, 1, nameStr.utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 2, Int32(ageInt))
                sqlite3_bind_text(insertStatement, 3, avatarStr.utf8String, -1, nil)
                
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                        let rowID = sqlite3_last_insert_rowid(db)
                        print("Success Insert \(rowID) \(nameStr) \(ageInt) \(avatarStr)")
                }
                else{
                    print("could not insert row")
                    returnCode = false
                }
                
                
                sqlite3_finalize(insertStatement)
                
            }
            else{
                print("insert not working")
                returnCode = false
            }
            
            sqlite3_close(db)
            
        }
        else{
            print("unable to open database")
            returnCode = false
        }
        
        
        
        
        return returnCode
        
    }
    
    
    
    
    
    //update Person
    func updateIntoDatabase(person : EntryData) -> Bool{
        
        var db : OpaquePointer? = nil
        var returnCode : Bool = true
        
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            var updateStatement : OpaquePointer? = nil
            var updateStatementString : String = "update entries set Name = ?, Age = ?, Avatar = ? where ID = \(person.eid)"
            
            if sqlite3_prepare(db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                
                //name email is string - convert string to NSString and string to cstring
                
                let id = person.eid as NSInteger
                let nameStr = person.name as NSString
                let ageInt = person.age as NSInteger
                let avatarStr = person.avatar as NSString
                
                
                sqlite3_bind_int(updateStatement, 4, Int32(id))
                sqlite3_bind_text(updateStatement, 1, nameStr.utf8String, -1, nil)
                sqlite3_bind_int(updateStatement, 2, Int32(ageInt))
                sqlite3_bind_text(updateStatement, 3, avatarStr.utf8String, -1, nil)
                
                
                if sqlite3_step(updateStatement) == SQLITE_DONE {
                    let rowID = sqlite3_last_insert_rowid(db)
                    print("Success Update \(rowID) \(nameStr) \(ageInt) \(avatarStr)")
                }
                else{
                    print("could not update row")
                    returnCode = false
                }
                
                
                sqlite3_finalize(updateStatement)
                
            }
            else{
                print("update not working")
                returnCode = false
            }
            
            sqlite3_close(db)
            
        }
        else{
            print("unable to open database")
            returnCode = false
        }
        
        
        
        
        return returnCode
        
    }
    
    
    
    
    //delete method
    func deleteFromDatabase(id : Int){
        
        var db : OpaquePointer? = nil
        //var returnCode : Bool = true
        
        
        if sqlite3_open(self.databasePath, &db) == SQLITE_OK {
            
            var deleteStatement : OpaquePointer? = nil
            let deleteStatementString : String = "delete from entries where ID = \(id)"
            
            if sqlite3_prepare(db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
                
               
                if sqlite3_step(deleteStatement) == SQLITE_DONE {
                    //let rowID = sqlite3_last_insert_rowid(db)
                    print("Success delete")
                }
                else{
                    print("could not delete row")
                   // returnCode = false
                }
                
                
                sqlite3_finalize(deleteStatement)
                
            }
            else{
                print("update not working")
                //returnCode = false
            }
            
            sqlite3_close(db)
            
        }
        else{
            print("unable to open database")
            //returnCode = false
        }
        
        
        
        
        //return returnCode
        
        
        
        
    }
    
    
    
    

    
    //method to check database file in document dir - if not create
    func checkAndCreateDatabase(){
        
        
        var success = false
        
        let fileManager = FileManager.default
        
        success = fileManager.fileExists(atPath: databasePath!)
        
        //if database exists - exit out from method
        if success {
            return
        }
        //else for 1st time - we need to copy it
            
          let databasePathFromApp = Bundle.main.resourcePath?.appending("/" + databaseName!)
        
        
         try? fileManager.copyItem(atPath: databasePathFromApp!, toPath: databasePath!)
        
        return
    
    }
    
    
    
    
    
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

