//
//  GoingModel.swift
//  MAP_Project
//
//  Created by Devashree Devidas Jadhav on 5/4/18.
//  Copyright © 2018 Devashree Devidas Jadhav. All rights reserved.
//

import Foundation
class GoingModel:NSObject {
    var eventName: String?
    var eventId: String?
    var eventLocation: String?
    var eventDate: String?
    var eventURL: String?
    
    init(eventName: String?, eventId: String?, eventLocation: String?, eventDate: String?, eventURL: String?) {
        self.eventName = eventName
        self.eventId = eventId
        self.eventLocation = eventLocation
        self.eventDate = eventDate
        self.eventURL = eventURL
    }
    
}

