//
//  UserOptionsViewController.swift
//  MAP_Project
//
//  Created by Devashree Devidas Jadhav on 4/28/18.
//  Copyright © 2018 Devashree Devidas Jadhav. All rights reserved.
//

import UIKit
import Firebase

class UserOptionsViewController: UIViewController {
    
    let templateColor = UIColor.white
    var randomRecipeList : RecipeList?
    var randomnewsList : NewsList?
    
    let bgImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "background3")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let bgView : UIView = {
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = UIColor(displayP3Red: 9.0/255.0, green: 33.0/255.0, blue: 47.0/255.0, alpha: 0.4).withAlphaComponent(0.7)
        return bgView
    }()
    
    let cookingButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let newsButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let eventsButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
       
        checkIfUserIsLoggedIn()
        setupNavBar()
        addingUIElements()
        downloadJSON {
            print ("Downloaded recipe of the moment!")
        }
        downloadJSONnews {
            print("Completed news download")
        }
       self.view.backgroundColor = UIColor.white
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
        navigationItem.title = "My Option"
    }
    
    func addingUIElements() {
        
        let signInButtonHeight: CGFloat = 70.0
        let padding: CGFloat = 40.0
        
        // Background imageview
        self.view.addSubview(bgImageView)
        bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant:0.0).isActive = true
        bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        bgImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        
        // Background layer view
        view.insertSubview(bgView, aboveSubview: bgImageView)
        bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        bgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
     
        // cookingButton
        view.insertSubview(cookingButton, aboveSubview: bgView)
        cookingButton.topAnchor.constraint(equalTo:view.topAnchor, constant: 150.0).isActive = true
        cookingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        cookingButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        cookingButton.heightAnchor.constraint(equalToConstant: signInButtonHeight).isActive = true
        
        let buttonAttributesDictionary = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0),
                                           NSAttributedStringKey.foregroundColor: templateColor]
        cookingButton.alpha = 0.7
        cookingButton.backgroundColor = UIColor.lightGray
        cookingButton.setAttributedTitle(NSAttributedString(string: "RECIPE OF THE MOMENT", attributes: buttonAttributesDictionary), for: .normal)
        cookingButton.addTarget(self, action: #selector(randomRecipeSelected(button:)), for: .touchUpInside)
        
       
        view.insertSubview(newsButton, aboveSubview: bgView)
        newsButton.topAnchor.constraint(equalTo: cookingButton.bottomAnchor, constant: 20.0).isActive = true
        newsButton.leadingAnchor.constraint(equalTo: cookingButton.leadingAnchor, constant: 0.0).isActive = true
        newsButton.trailingAnchor.constraint(equalTo: cookingButton.trailingAnchor, constant: 0.0).isActive = true
        newsButton.heightAnchor.constraint(equalTo: cookingButton.heightAnchor, constant: 0.0).isActive = true
        
        newsButton.alpha = 0.7
        newsButton.backgroundColor = UIColor.lightGray
        newsButton.setAttributedTitle(NSAttributedString(string: "NEWS FLASH", attributes: buttonAttributesDictionary), for: .normal)
        newsButton.addTarget(self, action: #selector(randomNewsSelected(button:)), for: .touchUpInside)
        
        // Sign In Button
        view.insertSubview(eventsButton, aboveSubview: bgView)
        eventsButton.topAnchor.constraint(equalTo: newsButton.bottomAnchor, constant: 20.0).isActive = true
        eventsButton.leadingAnchor.constraint(equalTo: newsButton.leadingAnchor, constant: 0.0).isActive = true
        eventsButton.trailingAnchor.constraint(equalTo: newsButton.trailingAnchor, constant: 0.0).isActive = true
        eventsButton.heightAnchor.constraint(equalToConstant: signInButtonHeight).isActive = true
        
        eventsButton.alpha = 0.7
        eventsButton.backgroundColor = UIColor.lightGray
        eventsButton.setAttributedTitle(NSAttributedString(string: "GOING TO", attributes: buttonAttributesDictionary), for: .normal)
        eventsButton.addTarget(self, action: #selector(eventsGoingTo(button:)), for: .touchUpInside)
        
        
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
    
    @objc func randomRecipeSelected(button: UIButton){
        //tabBarController?.tabBar.isHidden=true
        let randomRecipeController = RecipeDetailViewController()
        randomRecipeController.specificRecipe = randomRecipeList?.meals![0]
        navigationController?.pushViewController(randomRecipeController, animated: true)
    }
    
    @objc func randomNewsSelected(button: UIButton){
        //tabBarController?.tabBar.isHidden=true
        let randomRecipeController = NewsDetailsTableViewController()
        randomRecipeController.selectedNews = randomnewsList?.articles![10]
        navigationController?.pushViewController(randomRecipeController, animated: true)
    }
    @objc func eventsGoingTo(button: UIButton){
        let goingToViewController = GoingToViewController()
         navigationController?.pushViewController(goingToViewController, animated: true)
    }

    func downloadJSON(completed: @escaping () -> () ) {
        let downloadurlstring = "https://www.themealdb.com/api/json/v1/1/random.php"
        
        let url = URL(string:downloadurlstring)
        
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            guard let data = data else {return}
            let jsonString = String(data:data, encoding:.utf8)
            print ("recipe Attribs --->>>>", jsonString!)
            do{
                self.randomRecipeList = try JSONDecoder().decode(RecipeList.self, from: data)
                print (self.randomRecipeList?.meals![0].strMeal ?? "default value")
                DispatchQueue.main.async {
                    completed ()
                }
            }
            catch let err {
                print ("printing" , err)
            }
            }.resume()
        
    }
    func downloadJSONnews(completed: @escaping () -> () ) {
        let downloadurlstring = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=7bf9cbe1e6554b7480a6f24a70590cc9"
        
        let url = URL(string:downloadurlstring)
        
        URLSession.shared.dataTask(with: url!) { (data, response, err) in
            guard let data = data else {return}
            // let jsonString = String(data:data, encoding:.utf8)
            //print ("newsAttribs --->>>>", jsonString!)
            do{
                self.randomnewsList = try JSONDecoder().decode(NewsList.self, from: data)
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
                //                self.navigationItem.title = dictionary["name"] as? String
                
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

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
    func downloadImageUsingCacheWithLink(_ urlLink: String){
        self.image = nil
        
        if urlLink.isEmpty {
            return
        }
        // check cache first
        if let cachedImage = imageCache.object(forKey: urlLink as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // otherwise, download
        let url = URL(string: urlLink)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if let err = error {
                print(err)
                return
            }
            DispatchQueue.main.async {
                if let newImage = UIImage(data: data!) {
                    imageCache.setObject(newImage, forKey: urlLink as NSString)
                    
                    self.image = newImage
                }
            }
        }).resume()
        
    }
}

extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}



