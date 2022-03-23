//
//  InstagramCell.swift
//  Revels-20
//
//  Created by Rohit Kuber on 27/09/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit

class InstagramCell: UICollectionViewCell {
    lazy var backgroundV : UIView = {
        let bg = UIView()
        bg.backgroundColor = UIColor(white: 1, alpha: 1)
        bg.layer.cornerRadius = 40
        return bg
    }()
    
    lazy var usernameLabel : UILabel = {
        let label = UILabel()
        label.text = "mittechtatva"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    lazy var likeLabel : UILabel = {
        let label = UILabel()
        label.text = "12K"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        return label
    }()
    
    lazy var commentsLabel : UILabel = {
        let label = UILabel()
        label.text = "1.2K"
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue", size: 18)
        return label
    }()
   
    lazy var likeImageView : UIImageView = {
           let imageview = UIImageView()
           imageview.clipsToBounds = true
           imageview.image = UIImage(named: "icons8-love-96")
           imageview.contentMode = .scaleAspectFill
        imageview.setDimensions(width: 24, height: 24)
           return imageview
       }()
    
    lazy var profilePhotoImageview: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "logobg1")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 30, height: 30)
        iv.layer.cornerRadius = 30/2
        iv.backgroundColor = .gray
        return iv
    }()
    
    lazy var commentsImageView : UIImageView = {
           let imageview = UIImageView()
           imageview.clipsToBounds = true
           imageview.image = UIImage(named: "comment")
           imageview.contentMode = .scaleAspectFill
            imageview.setDimensions(width: 25, height: 25)
           return imageview
       }()
    
   
    lazy var postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
            iv.layer.cornerRadius = 25
            iv.layer.masksToBounds = true
            iv.backgroundColor = .gray
//        iv.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
//        iv.layer.borderWidth = 3
            iv.clipsToBounds = true
            return iv
        }()
    
    lazy var postCaption: UILabel = {
        let lb = UILabel()
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 20)
        lb.textColor = .black
        lb.numberOfLines = 0
        lb.alpha = 1
        return lb
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    fileprivate func setupLayout(){
//        addSubview(backgroundV)
//        _ = backgroundV.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
//
//        contentView.backgroundColor = UIColor(red: 255/255, green: 192/255, blue: 203/255, alpha: 0.6)
        contentView.backgroundColor = .black
        contentView.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        contentView.layer.borderWidth = 2
        
        contentView.layer.cornerRadius = 28
        addSubview(profilePhotoImageview)
        
        _ = profilePhotoImageview.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 20, bottomConstant: 0, rightConstant: 0)
        
        addSubview(usernameLabel)
        
        _ = usernameLabel.anchor(top: topAnchor, left: profilePhotoImageview.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 13, leftConstant: 12, bottomConstant: 0, rightConstant: 8, heightConstant: 14)
       
        addSubview(postImageView)
        _ = postImageView.anchor(top: usernameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 18, leftConstant: 20, bottomConstant: 12, rightConstant: 20, heightConstant: 320)
        
        postImageView.addSubview(postCaption)
        
        _ = postCaption.anchor(top: postImageView.topAnchor, left: postImageView.leftAnchor, bottom: postImageView.bottomAnchor, right: postImageView.rightAnchor, topConstant: 290, leftConstant: 8, bottomConstant: 12, rightConstant: 8)
        
        addSubview(likeImageView)
    _ = likeImageView.anchor(top: postImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 6, leftConstant: 45, bottomConstant: 14, rightConstant: 0)
        
        addSubview(likeLabel)
        _ = likeLabel.anchor(top: postImageView.bottomAnchor, left: likeImageView.rightAnchor, bottom: bottomAnchor, right: nil, topConstant: 10, leftConstant: 4, bottomConstant: 16, rightConstant: 0, heightConstant: 16)
        
        addSubview(commentsLabel)
        _ = commentsLabel.anchor(top: postImageView.bottomAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 16, rightConstant: 10, widthConstant: 48, heightConstant: 16)
        
        
        addSubview(commentsImageView)
        _ = commentsImageView.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: commentsLabel.leftAnchor, topConstant: 6, leftConstant: 0, bottomConstant: 22, rightConstant: 6)
        
        
        

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


