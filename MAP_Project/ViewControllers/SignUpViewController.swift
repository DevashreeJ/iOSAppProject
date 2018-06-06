//
//  SignUpViewController.swift
//  MAP_Project
//
//  Created by Devashree Devidas Jadhav on 4/28/18.
//  Copyright © 2018 Devashree Devidas Jadhav. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var profileurl: String?
    let picker = UIImagePickerController()
    let templateColor = UIColor.white
    let bgImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "background3")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let logoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0.8
        imageView.image = #imageLiteral(resourceName: "profile_image")
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
    
    let textFieldView2 : TextFieldView = {
        let textFieldView = TextFieldView()
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.backgroundColor = UIColor.clear
        return textFieldView
    }()
    
    let textFieldView3 : TextFieldView = {
        let textFieldView = TextFieldView()
        textFieldView.translatesAutoresizingMaskIntoConstraints = false
        textFieldView.backgroundColor = UIColor.clear
        return textFieldView
    }()
    
    let signInButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let forgotPassword : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let signUpButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        navigationController?.isNavigationBarHidden = true
        
        addingUIElements()
        self.hideKeyboardWhenTappedAround()

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    func addingUIElements() {
        let padding: CGFloat = 40.0
        let signInButtonHeight: CGFloat = 50.0
        let textFieldViewHeight: CGFloat = 60.0
        
        // Background imageview
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
        
        // Logo at top
        view.insertSubview(logoImageView, aboveSubview: bgView)
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60.0).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, constant: 0.0).isActive = true
        logoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        logoImageView.isUserInteractionEnabled = true
        
        // FirstName
        view.insertSubview(textFieldView1, aboveSubview: bgView)
        textFieldView1.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20.0).isActive = true
        textFieldView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        textFieldView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        textFieldView1.heightAnchor.constraint(equalToConstant: textFieldViewHeight).isActive = true
        
        let attributesDictionary = [NSAttributedStringKey.foregroundColor: UIColor.lightGray]
        textFieldView1.textField.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: attributesDictionary)
        textFieldView1.textField.textColor = templateColor
        
        // Last Name
        view.insertSubview(textFieldView2, aboveSubview: bgView)
        textFieldView2.topAnchor.constraint(equalTo: textFieldView1.bottomAnchor, constant: 0.0).isActive = true
        textFieldView2.leadingAnchor.constraint(equalTo: textFieldView1.leadingAnchor, constant: 0.0).isActive = true
        textFieldView2.trailingAnchor.constraint(equalTo: textFieldView1.trailingAnchor, constant: 0.0).isActive = true
        textFieldView2.heightAnchor.constraint(equalTo: textFieldView1.heightAnchor, constant: 0.0).isActive = true
        textFieldView2.textField.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: attributesDictionary)
        textFieldView2.textField.textColor = templateColor
       
        //City
      
        view.insertSubview(textFieldView3, aboveSubview: bgView)
        textFieldView3.topAnchor.constraint(equalTo: textFieldView2.bottomAnchor, constant: 0.0).isActive = true
        textFieldView3.leadingAnchor.constraint(equalTo: textFieldView2.leadingAnchor, constant: 0.0).isActive = true
        textFieldView3.trailingAnchor.constraint(equalTo: textFieldView2.trailingAnchor, constant: 0.0).isActive = true
        textFieldView3.heightAnchor.constraint(equalTo: textFieldView2.heightAnchor, constant: 0.0).isActive = true
        
        textFieldView3.textField.attributedPlaceholder = NSAttributedString(string: "City", attributes: attributesDictionary)
        textFieldView3.textField.textColor = templateColor
        
        
        // Sign Up Button
        view.insertSubview(signInButton, aboveSubview: bgView)
        signInButton.topAnchor.constraint(equalTo: textFieldView3.bottomAnchor, constant: 20.0).isActive = true
        signInButton.leadingAnchor.constraint(equalTo: textFieldView3.leadingAnchor, constant: 0.0).isActive = true
        signInButton.trailingAnchor.constraint(equalTo: textFieldView3.trailingAnchor, constant: 0.0).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: signInButtonHeight).isActive = true
        
        let buttonAttributesDictionary = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15.0),
                                          NSAttributedStringKey.foregroundColor: templateColor]
        signInButton.alpha = 0.7
        signInButton.backgroundColor = UIColor.lightGray
        signInButton.setAttributedTitle(NSAttributedString(string: "Update Info", attributes: buttonAttributesDictionary), for: .normal)
        // signInButton.isEnabled = false
        signInButton.addTarget(self, action: #selector(handleUpdate(button:)), for: .touchUpInside)
        
    }
    
    @objc private func signUpButtonTapped(button: UIButton) {
        showAlertVC(title: "Sign up tapped")
    }
    
    @objc func handleSelectProfileImageView() {
       
        
        picker.delegate = self
        picker.allowsEditing = true
        // show Image Picker!!!! (Modally)
        present(picker, animated: true, completion: nil)
    }
    
    // UIImagePickerController Delegates!!!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            logoImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    
    func showAlertVC(title: String) {
        let alertController = UIAlertController(title: title, message: "Need to implement code based on user requirements", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:{})
    }
    
    @objc func handleUpdate(button: UIButton) {
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
        
        // Compress Image into JPEG type
        if let profileImageUPLOAD = self.logoImageView.image, let uploadData = UIImageJPEGRepresentation(profileImageUPLOAD, 0.1) {
            
            _ = storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print("Error when uploading profile image")
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                self.profileurl = metadata.downloadURL()?.absoluteString
                self.registerUserIntoDatabaseWithUID(uid)
                self.navigate()
            }
        }
        
    }
    
    func navigate()
    {
        //let loginController = LoginVC()
        self.dismiss(animated: true)
    }
    
    fileprivate func registerUserIntoDatabaseWithUID(_ uid: String) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        let values = ["firstname": textFieldView1.textField.text, "lastname": textFieldView2.textField.text ,"profileurl": profileurl,"cityName": textFieldView3.textField.text] as [String : AnyObject]
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            
            if err != nil {
                print(err ?? "")
                return
            }
            
        })
        
    }
    
}

