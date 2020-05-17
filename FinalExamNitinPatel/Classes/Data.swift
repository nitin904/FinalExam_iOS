//
//  Data.swift
//  FinalExamNitinPatel
//
//  Created by Xcode User on 2020-04-04.
//  Copyright © 2020 Xcode User. All rights reserved.
//

import UIKit

class Data: NSObject {
    
    
    var id : Int?
    var name : String?
    var age : Int?
    var avatar : String?
    
    func initWithData(theRow i : Int, theName n : String, theAge a : Int, theAvatar av : String){
        id = i
        name = n
        age = a
        avatar = av
    }
    
    

}
