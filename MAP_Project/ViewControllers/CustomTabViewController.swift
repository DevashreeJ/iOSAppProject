//
//  CustomTabViewController.swift
//  MAP_Project
//
//  Created by Devashree Devidas Jadhav on 4/29/18.
//  Copyright © 2018 Devashree Devidas Jadhav. All rights reserved.
//

import UIKit

class CustomTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let userOptionscontroller = UserOptionsViewController()
        let zeroNavigationController = UINavigationController(rootViewController: userOptionscontroller)
        zeroNavigationController.tabBarItem.image = #imageLiteral(resourceName: "icons8-home-50")
        zeroNavigationController.title = "Home"
        
        let newsCotroller = NewsViewController()
        let oneNavigationController = UINavigationController(rootViewController: newsCotroller)
        oneNavigationController.tabBarItem.image = #imageLiteral(resourceName: "newspaper")
        oneNavigationController.title = "News"
        
        let cookingController = CookingTableViewController()
        let twoNavigationController = UINavigationController(rootViewController: cookingController)
        twoNavigationController.tabBarItem.image = #imageLiteral(resourceName: "cooking-food-in-a-hot-casserole")
        twoNavigationController.title = "Cook"
        
        let eventsController = EventsViewController()
        let threeNavigationController = UINavigationController(rootViewController: eventsController)
        threeNavigationController.tabBarItem.image = #imageLiteral(resourceName: "calendar")
        threeNavigationController.title = "Meet Up"
        
        let myEventsController = MyEvents()
        let fourNavigationController = UINavigationController(rootViewController: myEventsController)
        fourNavigationController.tabBarItem.image = #imageLiteral(resourceName: "event_personal")
        fourNavigationController.title = "My Events"
        
        viewControllers = [zeroNavigationController, oneNavigationController, twoNavigationController, threeNavigationController, fourNavigationController]
    }

}
