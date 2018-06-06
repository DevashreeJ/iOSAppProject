//
//  CustomTableViewCell.swift
//  MAP_Project
//
//  Created by Devashree Devidas Jadhav on 4/29/18.
//  Copyright © 2018 Devashree Devidas Jadhav. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {


    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 80, y: 10, width:200, height: 60)
        textLabel?.font = UIFont.systemFont(ofSize: 16.0)
        textLabel?.numberOfLines = 0
        textLabel?.textAlignment = NSTextAlignment.justified
        
       /* detailTextLabel?.frame = CGRect(x: 80, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width+10, height: detailTextLabel!.frame.height)*/
    }
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(iconImageView)
        
       
        
        iconImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
