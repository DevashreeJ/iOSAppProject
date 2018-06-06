//
//  EventModel.swift
//  MAP_Project
//
//  Created by Devashree Devidas Jadhav on 5/4/18.
//  Copyright © 2018 Devashree Devidas Jadhav. All rights reserved.
//

import Foundation

class EventModel: NSObject {
    var date: String?
    var eventId: String?
    var eventimage: String?
    var eventname: String?
    var location: String?
    var time: String?
    var userId: String?
    
    init(date:String?, eventimage:String?, eventname:String?, location:String?, time:String?, userId: String?, eventId: String?) {
        self.date = date
        self.eventimage = eventimage
        self.eventname = eventname
        self.location = location
        self.time = time
        self.userId = userId
        self.eventId = eventId
    }
}
