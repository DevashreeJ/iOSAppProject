//
//  User.swift
//  MAP_Project
//
//  Created by Devashree Devidas Jadhav on 4/28/18.
//  Copyright © 2018 Devashree Devidas Jadhav. All rights reserved.
//

import UIKit

class User: NSObject {
    var firstName: String?
    var lastName: String?
    var cityName: String?
    var profileurl: String?
    
    init(dictionary: [String: AnyObject]) {
        self.firstName = dictionary["firstname"] as? String
        self.lastName = dictionary["lastname"] as? String
        self.cityName = dictionary["cityName"] as? String
        self.profileurl = dictionary["profileurl"] as? String
    }
}

