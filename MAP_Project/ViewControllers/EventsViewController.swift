//
//  EventsViewController.swift
//  MAP_Project
//
//  Created by Devashree Devidas Jadhav on 4/29/18.
//  Copyright © 2018 Devashree Devidas Jadhav. All rights reserved.
//

import UIKit
import Firebase
import EventKit

class EventsViewController: UITableViewController {
    
    var events = [EventModel]()
    var goingtoevents = [GoingModel]()
    var eventStore = EKEventStore()
    var calendars:Array<EKCalendar> = []
    
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
        
        fetchGoingtoEvents {
            print("fetched going")
            tableView.reloadData()
        }
        
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  NewsTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier:"Identifier")
        
        var going =  Set<String>()
        var screenedFavourites = [GoingModel]()
        
        cell.imgUser.setImage(#imageLiteral(resourceName: "icons8-ok-32"), for: .normal)
        cell.imgUser.setImage(#imageLiteral(resourceName: "icons8-ok-24"), for: .selected)
        cell.imgUser.tag = indexPath.row
        cell.imgUser.addTarget(self, action: #selector(favourited(sender: )), for: UIControlEvents.touchUpInside)
        
        if(indexPath.row < goingtoevents.count)
        { print("going to event  ",goingtoevents[indexPath.row].eventName ?? "default value")}
        
        for goingtoevent in goingtoevents{
            print("inside for loop")
            print (goingtoevent.eventId ?? "default", events[indexPath.row].eventId ?? "default event")
            if(goingtoevent.eventId == events[indexPath.row].eventId)
            {
                print ("inside first if")
                if !going.contains(goingtoevent.eventId!) {
                    print ("inside second if")
                    // print ("favourited movie", movie.movieTitle ?? "default")
                    screenedFavourites.append(goingtoevent)
                    going.insert(goingtoevent.eventId!)
                }
            }
        }
        
        if(screenedFavourites.count==0)
        {
            print ("inside screened favourite")
            cell.imgUser.isSelected = false
        }
        else {
            cell.imgUser.isSelected = true
        }
        
        
        cell.labUerName.text = events[indexPath.row].eventname
        cell.labMessage.text = events[indexPath.row].location
        cell.labMessage.textColor = UIColor.blue
        cell.labTime.text = ("\((events[indexPath.row].date)!), \((events[indexPath.row].time)!)")
        
        
        
        return cell
    }
    @objc func favourited(sender:UIButton){
        
        if(sender.isSelected==true){
            print("deselected")
            sender.isSelected = false
            deletefavourite(index: sender.tag)
        }
        else{
            print("selected")
            sender.isSelected = true
            addfavouritestodatabase(index: sender.tag)
           
            
            let datestart = GetDateFromString(DateStr: events[sender.tag].date!)
            let calendar = Calendar.current
            let date = calendar.date(byAdding: .minute, value: 5, to: datestart)
            
            addEventToCalendar(title: events[sender.tag].eventname!, description: "Going to this event", startDate: date!, endDate: date!)
            
            showAlertVC(title: "Event Saved to Calendar")
        }
        
    }
    
    func showAlertVC(title: String) {
        let alertController = UIAlertController(title: title, message: "Task Completed!", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:{})
    }
    
    func GetDateFromString(DateStr: String)-> Date
    {
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        let DateArray = DateStr.components(separatedBy: "/")
        let components = NSDateComponents()
        components.year = Int(DateArray[2])!
        components.month = Int(DateArray[1])!
        components.day = Int(DateArray[0])!
        components.timeZone = TimeZone(abbreviation: "EDT+0:00")
        let date = calendar?.date(from: components as DateComponents)
        
        return date!
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async { () -> Void in
            let eventStore = EKEventStore()
            
            eventStore.requestAccess(to: .event, completion: { (granted, error) in
                if (granted) && (error == nil) {
                    let event = EKEvent(eventStore: eventStore)
                    event.title = title
                    event.startDate = startDate
                    event.endDate = endDate
                    event.notes = description
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    do {
                        try eventStore.save(event, span: .thisEvent)
                        print("saved")
                    } catch let e as NSError {
                        completion?(false, e)
                        return
                    }
                    completion?(true, nil)
                } else {
                    completion?(false, error as NSError?)
                }
            })
        }
    }
    
    
    func fetchGoingtoEvents(completed: @escaping () -> ()){
        
        goingtoevents.removeAll()
        
        let ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        ref.child("favourites").child(userID!).observe(.childAdded, with: { (snapshot) in
            let results = snapshot.value as? [String : AnyObject]
            let eName = results?["eventName"]
            let elocation = results?["eventImage"]
            let eId = results?["eventId"]
            let eventDate = results?["eventDate"]
            let eventURL = results?["eventURL"]
            let goingtoeventsfetched = GoingModel(eventName: eName as! String?, eventId: eId as! String?,
                                                  eventLocation:elocation as! String?, eventDate: eventDate as!String?, eventURL: eventURL as! String?)
            self.goingtoevents.append(goingtoeventsfetched)
            print(self.goingtoevents[0].eventName ?? "default")
            print(self.goingtoevents.count)
            DispatchQueue.main.async {
                completed()
            }
        })
        
    }
    
    fileprivate func addfavouritestodatabase(index :Int ) {
        
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let eventId = events[index].eventId
        let eventName = events[index].eventname
        let eventLocation = events[index].location
        let goingRef = ref.child("favourites").child(uid!).child(eventId!)
        let eventDate = events[index].date
        let eventURL = events[index].eventimage
        
        let values = ["eventId": eventId, "eventName": eventName ,"eventLocation":eventLocation,
                      "eventDate":eventDate, "eventURL":eventURL ] as [String : AnyObject]
        
        goingRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            
            if err != nil {
                print(err ?? "")
                return
            }
            
        })
        
    }
    
    fileprivate func deletefavourite(index :Int) {
        let ref = Database.database().reference()
        
        let uid = Auth.auth().currentUser?.uid
        
        let eventId = events[index].eventId
        let goingRef = ref.child("favourites").child(uid!).child(eventId!)
        goingRef.removeValue()
        
    }
    
    func checkIfUserIsLoggedIn() {
       
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func setupNavBar(){
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "icons8-add-property-26"), style: .plain, target: self, action: #selector(addEvent))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "logout-1-32"), style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.title = "My Options"
    }
    
    @objc func handleLogout() {
      
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        tabBarController?.tabBar.isHidden=true
        let loginController = LoginVC()
      
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    @objc func addEvent(){
        let addEventController = AddViewController()
        navigationController?.pushViewController(addEventController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Events you can go to"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapController = MapViewController()
        mapController.selectedEvent = events[indexPath.row]
        navigationController?.pushViewController(mapController, animated: true)
        
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user)
            }
            
        }, withCancel: nil)
    }
    
    
    
    
    func fetchEvents(completed: @escaping () -> ()){
        
        let ref = Database.database().reference()
        ref.child("events").observe(.childAdded, with: { (snapshot) in
            let results = snapshot.value as? [String : AnyObject]
            let date = results?["date"]
            let eventimage = results?["eventimage"]
            let eventname = results?["eventname"]
            let location = results?["location"]
            let time = results?["time"]
            let userId = results?["userId"]
            let eventId = results?["eventId"]
            let allEvents = EventModel(date: date as! String?, eventimage: eventimage as! String?,
                                       eventname:eventname as! String?, location:location as! String?, time:time as! String?, userId:userId as! String?, eventId:eventId as! String?)
            self.events.append(allEvents)
            self.tableView.insertRows(at: [IndexPath(row: self.events.count - 1, section: 0)], with: UITableViewRowAnimation.automatic)
            print(self.events[0].eventname ?? "default")
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
        
    }
    
    @objc private func handleTap(){
        //print("Tapped")
        
        let signUpController = SignUpViewController()
        //signUpController.myTopListViewController = self
        
        //signUpController.fetchUserProfile()
        
        self.present(signUpController, animated: true)
    }
    
}



