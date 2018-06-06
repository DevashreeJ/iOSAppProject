//
//  MyEvents.swift
//  MAP_Project
//
//  Created by Devashree Devidas Jadhav on 5/4/18.
//  Copyright © 2018 Devashree Devidas Jadhav. All rights reserved.
//

import UIKit
import Firebase

class MyEvents: UITableViewController {
    var events = [EventModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfUserIsLoggedIn()
        setupNavBar()
        
        let tableView = UITableView(frame: view.bounds, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        fetchEvents {
            print("fetched")
            tableView.reloadData()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapController = MapViewController()
        mapController.selectedEvent = events[indexPath.row]
        navigationController?.pushViewController(mapController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  NewsTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier:"Identifier")
        cell.labUerName.text = events[indexPath.row].eventname
        cell.labMessage.text = events[indexPath.row].location
        cell.labMessage.highlightedTextColor = UIColor.blue
        cell.imgUser.setImage(#imageLiteral(resourceName: "icons8-ok-24"), for: .normal)
        print(events[indexPath.row].location ?? "default Value")
        cell.labTime.text = ("\((events[indexPath.row].date)!), \((events[indexPath.row].time)!)")
        
        print(indexPath.row, cell.labUerName.text!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    override func tableView(_ tableView: UITableView, commit editingStyle:
        UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            tableView.beginUpdates()
            self.deleteEvent(eid: events[indexPath.row].eventId!)
            events.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Events"
    }
    func showAlertVC(title: String) {
        let alertController = UIAlertController(title: title, message: "Task Completed!", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:{})
    }
    
    func checkIfUserIsLoggedIn() {
        // if not sign in, display login screen!!!
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func getImageFromWeb(_ urlString: String, closure: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: urlString) else {
            return closure(nil)
        }
        let task = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                print("error: \(String(describing: error))")
                return closure(nil)
            }
            guard response != nil else {
                print("no response")
                return closure(nil)
            }
            guard data != nil else {
                print("no data")
                return closure(nil)
            }
            DispatchQueue.main.async {
                closure(UIImage(data: data!))
            }
        }; task.resume()
    }
    
    func setupNavBar(){
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "icons8-add-property-26"), style: .plain, target: self, action: #selector(addEvent))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "logout-1-32"), style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.title = "My Options"
    }
    
    @objc func handleLogout() {
        // Sign-out!!!
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        tabBarController?.tabBar.isHidden=true
        let loginController = LoginVC()
        // loginController.myTopListViewController = self
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    @objc func addEvent(){
        let addEventController = AddViewController()
        // loginController.myTopListViewController = self
        navigationController?.pushViewController(addEventController, animated: true)
    }
    
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        // fetch User info! Set up Navigation Bar!
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                //                self.navigationItem.title = dictionary["name"] as? String
                
                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user)
            }
            
        }, withCancel: nil)
    }
    
    
    fileprivate func deleteEvent(eid: String) {
        print(eid)
            let ref = Database.database().reference()
            let userID = Auth.auth().currentUser?.uid
            let eventReference =  ref.child("eventsbyspecificusers").child(userID!).child(eid)
            eventReference.removeValue()
            let allEventReference =  ref.child("events").child(eid)
            allEventReference.removeValue()
            showAlertVC(title: "Event Deleted")
        }   
    
    func fetchEvents(completed: @escaping () -> ()){
        
        events.removeAll()
        
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("eventsbyspecificusers").child(userID!).observe(.childAdded, with: { (snapshot) in
            let results = snapshot.value as? [String : AnyObject]
            let date = results?["date"]
            let eventimage = results?["eventImage"]
            let eventname = results?["eventname"]
            let location = results?["eventlocation"]
            let time = results?["time"]
            let userId = results?["userId"]
            let eventId = results?["eventId"]
            let allEvents = EventModel(date: date as! String?, eventimage: eventimage as! String?,
                                       eventname:eventname as! String?, location:location as! String?, time:time as! String?, userId:userId as! String?, eventId:eventId as! String?)
            self.events.append(allEvents)
            self.tableView.insertRows(at: [IndexPath(row: self.events.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
        //    print(self.events[0].eventname ?? "default")
            DispatchQueue.main.async {
                completed()
             }
          })
        }
    
   
    
    
    func setupNavBarWithUser(_ user: User) {
        
        let titleView = TitleView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        
        self.navigationItem.titleView = titleView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        titleView.isUserInteractionEnabled = true
        
        titleView.addGestureRecognizer(tap)
        
        if let profileImageUrl = user.profileurl {
            titleView.profileImageView.downloadImageUsingCacheWithLink(profileImageUrl)
            
        }
        titleView.nameLabel.text = user.firstName
        
        // fetchLists()
    }
    
    @objc private func handleTap(){
        //print("Tapped")
        
        let signUpController = SignUpViewController()
        //signUpController.myTopListViewController = self
        
        //signUpController.fetchUserProfile()
        
        self.present(signUpController, animated: true)
    }
}



