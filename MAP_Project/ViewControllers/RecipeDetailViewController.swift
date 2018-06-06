//
//  RecipeDetailViewController.swift
//  MAP_Project
//
//  Created by Devashree Devidas Jadhav on 5/1/18.
//  Copyright © 2018 Devashree Devidas Jadhav. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    var specificRecipe: SelectedRecipe? {
        didSet{
            _ = specificRecipe?.idMeal
            //   let link = "https://api.themoviedb.org/3/movie/\(id!)?api_key=b33ce31bf3b4db5418438ad8e60074b4"
        }
    }
    
    let templateColor = UIColor.white
    let bgImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "background3")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var logoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.8
        imageView.image = #imageLiteral(resourceName: "foodImage")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let bgView : UIView = {
        let bgView = UIView()
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.backgroundColor = UIColor(displayP3Red: 9.0/255.0, green: 33.0/255.0, blue: 47.0/255.0, alpha: 1.0).withAlphaComponent(0.7)
        return bgView
    }()
    
    let textFieldView1 : TextFieldView = {
        let textFieldView = TextFieldView()
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.backgroundColor = UIColor.clear
        return textFieldView
    }()
    
    let textView1 : UITextView = {
        let textView1 = UITextView()
          textView1.translatesAutoresizingMaskIntoConstraints = false
        textView1.backgroundColor = UIColor.white
        return textView1
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let padding: CGFloat = 20.0
        let paddingforTextView :CGFloat = 40.0
        let textFieldViewHeight: CGFloat = 60.0
        
        self.view.addSubview(bgImageView)
        bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        bgImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        
        // Background layer view
        view.insertSubview(bgView, aboveSubview: bgImageView)
        bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0).isActive = true
        bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0).isActive = true
        bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0).isActive = true
        bgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0).isActive = true
        
        view.insertSubview(textFieldView1, aboveSubview: bgView)
        textFieldView1.topAnchor.constraint(equalTo: view.topAnchor, constant: 50.0).isActive = true
        textFieldView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        textFieldView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        textFieldView1.heightAnchor.constraint(equalToConstant: textFieldViewHeight).isActive = true
        textFieldView1.textField.text = specificRecipe?.strMeal
        textFieldView1.textField.font = UIFont.systemFont(ofSize: 18)
        textFieldView1.textField.textColor = UIColor.white
        //textFieldView1.textField.textAlignment = .center
        
        // Logo at top
        view.insertSubview(logoImageView, aboveSubview: bgView)
        logoImageView.topAnchor.constraint(equalTo: textFieldView1.bottomAnchor, constant: 20.0).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, constant: 0.0).isActive = true
        
        let imageURL = specificRecipe?.strMealThumb
        
        if imageURL == nil{
           logoImageView.image = #imageLiteral(resourceName: "default_food")
        }
        else{
            logoImageView.imageFromServerURL(urlString: imageURL!)
        }
        
        //Scrollable textView
        view.insertSubview(textView1, aboveSubview: bgView)
        textView1.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20.0).isActive = true
        textView1.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        textView1.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        textView1.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -paddingforTextView).isActive = true
        textView1.font = UIFont.systemFont(ofSize: 15)
        textView1.isScrollEnabled = true
        textView1.scrollsToTop = true
        textView1.text = specificRecipe?.strInstructions
        textView1.autocorrectionType = UITextAutocorrectionType.no
        textView1.isEditable = false
        textView1.keyboardType = UIKeyboardType.default
        textView1.returnKeyType = UIReturnKeyType.done
        textView1.textAlignment = NSTextAlignment.justified
       
    }
    
    func addUIelements(){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }

}
