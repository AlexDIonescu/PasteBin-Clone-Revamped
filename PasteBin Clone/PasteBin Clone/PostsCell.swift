//
//  PostsCell.swift
//  PasteBin Clone
//
//  Created by Alex Ionescu on 16.11.2022.
//

import UIKit

class PostsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
//        addSubview(profileImage)
//
//        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
//        profileImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
//        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }

    
    var email = ""
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRectMake(56, textLabel!.frame.origin.y, textLabel!.frame.width, textLabel!.frame.height)
        detailTextLabel?.frame = CGRectMake(56, detailTextLabel!.frame.origin.y,detailTextLabel!.frame.width, detailTextLabel!.frame.height)
        
    }
    
    let profileImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "logo1.png")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 20
        image.layer.masksToBounds = true
        return image
    }()

    

    
}
