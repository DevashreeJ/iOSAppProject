//
//  NewsTableViewCell.swift
//  MAP_Project
//
//  Created by Devashree Devidas Jadhav on 5/3/18.
//  Copyright © 2018 Devashree Devidas Jadhav. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    let imgUser = UIButton()
    let labUerName = UILabel()
    let labMessage = UILabel()
    let labTime = UILabel()
    let backview = UIImageView()
  
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        imgUser.translatesAutoresizingMaskIntoConstraints = false
        labUerName.translatesAutoresizingMaskIntoConstraints = false
        labMessage.translatesAutoresizingMaskIntoConstraints = false
        labTime.translatesAutoresizingMaskIntoConstraints = false
      
        //imgUser.addTarget(self, action: #selector(favourited(sender: )), for: UIControlEvents.touchUpInside)
        
        /*backview.frame = CGRect(x:0, y:0, width:self.frame.width, height:self.frame.height)
        let image = #imageLiteral(resourceName: "cellBackground")
        backview.image = image
        self.backgroundView = UIView()
        self.backgroundView?.addSubview(backview)*/
        
        labUerName.font = UIFont.boldSystemFont(ofSize: 17)
        
        contentView.addSubview(backview)
        contentView.addSubview(imgUser)
        contentView.addSubview(labUerName)
        contentView.addSubview(labMessage)
        contentView.addSubview(labTime)
        
        self.backgroundColor = UIColor(red:0.90, green:0.87, blue:0.96, alpha:1.0)
        layer.cornerRadius = 30
        layer.masksToBounds = true

        
        let viewsDict = [
            "image" : imgUser,
            "username" : labUerName,
            "message" : labMessage,
            "labTime" : labTime,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[image(40)]", options: [], metrics: nil, views: viewsDict))
      //  contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[labTime]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[username]-[message]-[labTime]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[username]-[image(40)]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[message]-|", options: [], metrics: nil, views: viewsDict))
         contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[labTime]-|", options: [], metrics: nil, views: viewsDict))
    }
    
}
