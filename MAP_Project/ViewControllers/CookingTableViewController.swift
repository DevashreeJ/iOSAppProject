//
//  CookingTableViewController.swift
//  MAP_Project
//
//  Created by Devashree Devidas Jadhav on 4/29/18.
//  Copyright © 2018 Devashree Devidas Jadhav. All rights reserved.
//

import UIKit
import Firebase

class CookingTableViewController: UITableViewController {

    var recipeList : RecipeList?
    override func viewDidLoad() {
        super.viewDidLoad()
       
        checkIfUserIsLoggedIn()
        setupNavBar()
        
        let tableView = UITableView(frame: view.bounds, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        downloadJSON {
            print("completed")
            tableView.reloadData()
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
    
    func downloadJSON(completed: @escaping () -> () ) {
        let downloadurlstring = "https://www.themealdb.com/api/json/v1/1/randomselection.php"
        
        let url = URL(string:downloadurlstring)
        
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            guard let data = data else {return}
            //let jsonString = String(data:data, encoding:.utf8)
            //print ("recipe Attribs --->>>>", jsonString!)
            do{
                self.recipeList = try JSONDecoder().decode(RecipeList.self, from: data)
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
        return 85
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recipe"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CustomTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier:"Identifier")
        cell.textLabel?.text = recipeList?.meals![indexPath.row].strMeal
        print(recipeList?.meals![indexPath.row].strMealThumb ?? "default")
       
        let imageURL = recipeList?.meals![indexPath.row].strMealThumb
        
        if imageURL == nil{
           cell.iconImageView.image = #imageLiteral(resourceName: "dining-meal-covered")
        }
        else{
             cell.iconImageView.imageFromServerURL(urlString: imageURL!)
        }
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let recipe = recipeList?.meals![indexPath.row]
        {
            let recipeDetailController = RecipeDetailViewController()
            recipeDetailController.specificRecipe = recipe
            self.navigationController?.pushViewController(recipeDetailController, animated: true)
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

extension UIImageView {
    public func imageFromServerURL(urlString: String) {
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "error default")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}





