//
//  NewsDetailsTableViewController.swift
//  MAP_Project
//
//  Created by Devashree Devidas Jadhav on 5/3/18.
//  Copyright © 2018 Devashree Devidas Jadhav. All rights reserved.
//

import UIKit

class NewsDetailsTableViewController: UITableViewController {

    var selectedNews: SelectedNews? {
        didSet{
            _ = selectedNews?.title
            //   let link = "https://api.themoviedb.org/3/movie/\(id!)?api_key=b33ce31bf3b4db5418438ad8e60074b4"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let tableView = UITableView(frame: view.bounds, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
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
        return 4
    }
    
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       if(indexPath.row == 3)
       {
        if let url = URL(string: (selectedNews?.url)!){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        else{
            print ("No such URL")
            }
        }
       else{
        print ("here")
    }
    
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier:"Identifier")
        
        if(indexPath.row == 0)
        {
            cell.textLabel?.text = selectedNews?.title
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20.0)
            cell.textLabel?.textAlignment = NSTextAlignment.center
        }
        else if(indexPath.row == 1)
        {
            let imgUser = UIImageView()
            let imageURL = selectedNews?.urlToImage
            if(imageURL?.range(of: "https") != nil)
            {
                if (imageURL == nil){
                    imgUser.image = #imageLiteral(resourceName: "default-image_news")
                }
                else{
                   imgUser.imageFromServerURL(urlString: imageURL!)
                }
            }
            else
            {
                if (imageURL == nil){
                    imgUser.image = #imageLiteral(resourceName: "default-image_news")
                }
                else {
                    let updatedURL = imageURL?.replacingOccurrences(of: "http", with: "https",
                                                                    options: NSString.CompareOptions.literal, range:nil)
                   imgUser.imageFromServerURL(urlString: updatedURL!)
                }
            }
            //imgUser.imageFromServerURL(urlString: (selectedNews?.urlToImage)!)
            cell.contentView.addSubview(imgUser)
            
            let viewsDict = [
                "image" : imgUser,
                ]
            imgUser.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[image(150)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views:viewsDict ))
            cell.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[image(270)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views:viewsDict ))
           
        }
        else if(indexPath.row == 2)
        {
            cell.textLabel?.text = selectedNews?.description
            cell.textLabel?.numberOfLines = 0
            //cell.textLabel?.textAlignment = NSTextAlignment.justified
        }
        else if(indexPath.row == 3)
        {
            cell.textLabel?.text = selectedNews?.url
            cell.textLabel?.textColor = UIColor.blue
            cell.textLabel?.numberOfLines = 0
        }
        return cell
    }
}
    

    