//
//  NewsViewController.swift
//  MAP_Project
//
//  Created by Devashree Devidas Jadhav on 4/29/18.
//  Copyright © 2018 Devashree Devidas Jadhav. All rights reserved.
//

import UIKit
import Firebase

/*
 if let url = URL(string: "https://www.hackingwithswift.com") {
 UIApplication.shared.open(url, options: [:])
 }*/

class NewsViewController: UITableViewController {

    var newsList : NewsList?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        checkIfUserIsLoggedIn()
        setupNavBar()
        
        let tableView = UITableView(frame: view.bounds, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        //self.tableView.sectionHeaderHeight = 100
        

        downloadJSON {
            print("News downloaded")
             tableView.reloadData()
        }
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CustomTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier:"Identifier")
        let str = newsList?.articles![indexPath.row].title!
        cell.textLabel?.text = str
        let imageURL = newsList?.articles![indexPath.row].urlToImage
        if(imageURL?.range(of: "https") != nil)
        {
            if (imageURL == nil){
                cell.iconImageView.image = #imageLiteral(resourceName: "newspaper_default")
            }
            else{
                cell.iconImageView.imageFromServerURL(urlString: imageURL!)
            }
        }
        else
        {
            if (imageURL == nil){
                cell.iconImageView.image = #imageLiteral(resourceName: "newspaper_default")
            }
            else {
                let updatedURL = imageURL?.replacingOccurrences(of: "http", with: "https",
                                                                options: NSString.CompareOptions.literal, range:nil)
                cell.iconImageView.imageFromServerURL(urlString: updatedURL!)
            }
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

   override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return "News"
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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let news = newsList?.articles![indexPath.row]
        {
            let newsDetailsController = NewsDetailsTableViewController()
            newsDetailsController.selectedNews = news
            self.navigationController?.pushViewController(newsDetailsController, animated: true)
        }
        
    }
    
    func checkIfUserIsLoggedIn() {
        // if not sign in, display login screen!!!
        if Auth.auth().currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func setupNavBar(){
        navigationController?.isNavigationBarHidden = false
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
    
    
    func downloadJSON(completed: @escaping () -> () ) {
        let downloadurlstring = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=7bf9cbe1e6554b7480a6f24a70590cc9"
        
        let url = URL(string:downloadurlstring)
        
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            guard let data = data else {return}
           // let jsonString = String(data:data, encoding:.utf8)
            //print ("newsAttribs --->>>>", jsonString!)
            do{
                self.newsList = try JSONDecoder().decode(NewsList.self, from: data)
                //print (self.recipeList?.meals![0].strMeal ?? "default recipe")
                DispatchQueue.main.async {
                    completed ()
                }
            }
            catch let err {
                print ("printing" , err)
            }
            }.resume()
        
    }
    
    
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        
        // fetch User info! Set up Navigation Bar!
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user)
            }
            
        }, withCancel: nil)
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




 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


