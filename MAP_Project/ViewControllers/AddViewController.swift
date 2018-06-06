//
//  AddViewController.swift
//  MAP_Project
//
//  Created by Devashree Devidas Jadhav on 5/3/18.
//  Copyright © 2018 Devashree Devidas Jadhav. All rights reserved.
//

import UIKit
import Firebase

class AddViewController:UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var uploadedImageurl: String?
    var userProfileImageurl: String?
    let picker = UIImagePickerController()
    var scroller = UIScrollView()
    
    
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()

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
    let textFieldView4 : TextFieldView = {
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
    //    navigationController?.isNavigationBarHidden = true
        
        addingUIElements()
        showDatePicker()
        showTimePicker()
        self.hideKeyboardWhenTappedAround()
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    func addingUIElements() {
        let padding: CGFloat = 40.0
        let signInButtonHeight: CGFloat = 40.0
        let textFieldViewHeight: CGFloat = 50.0
        
        scroller.frame = view.bounds
        
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
        logoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80.0).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: logoImageView.heightAnchor, constant: 0.0).isActive = true
        logoImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        logoImageView.isUserInteractionEnabled = true
        
        // Event Name
        view.insertSubview(textFieldView1, aboveSubview: bgView)
        textFieldView1.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20.0).isActive = true
        textFieldView1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        textFieldView1.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        textFieldView1.heightAnchor.constraint(equalToConstant: textFieldViewHeight).isActive = true
        
        let attributesDictionary = [NSAttributedStringKey.foregroundColor: UIColor.lightGray]
        textFieldView1.textField.attributedPlaceholder = NSAttributedString(string: "Event Name", attributes: attributesDictionary)
        textFieldView1.textField.textColor = templateColor
        
        // Event Date
        view.insertSubview(textFieldView2, aboveSubview: bgView)
        textFieldView2.topAnchor.constraint(equalTo: textFieldView1.bottomAnchor, constant: 0.0).isActive = true
        textFieldView2.leadingAnchor.constraint(equalTo: textFieldView1.leadingAnchor, constant: 0.0).isActive = true
        textFieldView2.trailingAnchor.constraint(equalTo: textFieldView1.trailingAnchor, constant: 0.0).isActive = true
        textFieldView2.heightAnchor.constraint(equalTo: textFieldView1.heightAnchor, constant: 0.0).isActive = true
        textFieldView2.textField.attributedPlaceholder = NSAttributedString(string: "Date", attributes: attributesDictionary)
        textFieldView2.textField.inputView = datePicker
        textFieldView2.textField.textColor = templateColor
        
        //Event Time
        view.insertSubview(textFieldView4, aboveSubview: bgView)
        textFieldView4.topAnchor.constraint(equalTo: textFieldView2.bottomAnchor, constant: 0.0).isActive = true
        textFieldView4.leadingAnchor.constraint(equalTo: textFieldView2.leadingAnchor, constant: 0.0).isActive = true
        textFieldView4.trailingAnchor.constraint(equalTo: textFieldView2.trailingAnchor, constant: 0.0).isActive = true
        textFieldView4.heightAnchor.constraint(equalTo: textFieldView2.heightAnchor, constant: 0.0).isActive = true
        textFieldView4.textField.attributedPlaceholder = NSAttributedString(string: "Time", attributes: attributesDictionary)
        textFieldView4.textField.inputView = datePicker
        textFieldView4.textField.textColor = templateColor
        
        
        //City
        
        view.insertSubview(textFieldView3, aboveSubview: bgView)
        textFieldView3.topAnchor.constraint(equalTo: textFieldView4.bottomAnchor, constant: 0.0).isActive = true
        textFieldView3.leadingAnchor.constraint(equalTo: textFieldView4.leadingAnchor, constant: 0.0).isActive = true
        textFieldView3.trailingAnchor.constraint(equalTo: textFieldView4.trailingAnchor, constant: 0.0).isActive = true
        textFieldView3.heightAnchor.constraint(equalTo: textFieldView4.heightAnchor, constant: 0.0).isActive = true
        
        textFieldView3.textField.attributedPlaceholder = NSAttributedString(string: "Location", attributes: attributesDictionary)
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
        signInButton.setAttributedTitle(NSAttributedString(string: "Post Event", attributes: buttonAttributesDictionary), for: .normal)
        // signInButton.isEnabled = false
        signInButton.addTarget(self, action: #selector(handleUpdate(button:)), for: .touchUpInside)
        
        
        
        
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @objc private func signUpButtonTapped(button: UIButton) {
        showAlertVC(title: "Sign up tapped")
    }
    
    @objc func handleSelectProfileImageView() {
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else{
            picker.delegate = self
            picker.allowsEditing = true
            // show Image Picker!!!! (Modally)
            present(picker, animated: true, completion: nil)
        }
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
        let alertController = UIAlertController(title: title, message: "Successfully completed!", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion:{})
    }
    
    @objc func handleUpdate(button: UIButton) {
        
        guard let uid = Auth.auth().currentUser?.uid else{
            return
        }
        
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("Event_images").child("\(imageName).jpg")
        
        // Compress Image into JPEG type
        if let profileImageUPLOAD = self.logoImageView.image, let uploadData = UIImageJPEGRepresentation(profileImageUPLOAD, 0.1) {
            
            _ = storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print("Error when uploading profile image")
                    return
                }
                // Metadata contains file metadata such as size, content-type, and download URL.
                self.uploadedImageurl = metadata.downloadURL()?.absoluteString
                self.registerEventIntoDatabaseWithUID(uid)
                self.navigate()
            }
        }
        
    }
    
    func navigate()
    {
      showAlertVC(title: "Event Added")
    }
    
    fileprivate func registerEventIntoDatabaseWithUID(_ uid: String) {
        let ref = Database.database().reference()
        let eventId = UUID().uuidString
        let eventsReference = ref.child("events").child(eventId)
        
        let values = ["eventimage": uploadedImageurl as AnyObject,"eventname": textFieldView1.textField.text ?? "default text","eventId":eventId,"date": textFieldView2.textField.text ?? "default date" ,"location": textFieldView3.textField.text ?? "location","time":textFieldView4.textField.text ?? "default time","userId":Auth.auth().currentUser?.uid as Any] as [String : AnyObject]
        
        eventsReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            
            if err != nil {
                print(err ?? "")
                return
            }
            
        })
        
        let usersReference = ref.child("eventsbyspecificusers").child(uid).child(eventId)
        
        let eventUserValues = ["eventname": textFieldView1.textField.text ?? "default name","eventId":eventId, "eventlocation": textFieldView3.textField.text ?? "default Location" ,"eventsImage": uploadedImageurl ?? "default image","date": textFieldView2.textField.text ?? "default date","time": textFieldView4.textField.text ?? "default time", "userId":Auth.auth().currentUser?.uid as Any] as [String : AnyObject]
        
        usersReference.updateChildValues(eventUserValues, withCompletionBlock: { (err, ref) in
            
            
            if err != nil {
                print(err ?? "")
                return
            }
            
        })
        
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        textFieldView2.textField.inputAccessoryView = toolbar
        textFieldView2.textField.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        textFieldView2.textField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    func showTimePicker(){
        //Formate Date
        timePicker.datePickerMode = .time
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donetimePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTimePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        textFieldView4.textField.inputAccessoryView = toolbar
        textFieldView4.textField.inputView = timePicker
        
    }

    
    @objc func donetimePicker(){
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        textFieldView4.textField.text = formatter.string(from: timePicker.date)
        self.view.endEditing(true)
    }
    
    @objc func cancelTimePicker(){
        self.view.endEditing(true)
    }

}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardView)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboardView() {
        view.endEditing(true)
    }
}
