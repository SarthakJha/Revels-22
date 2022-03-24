//
//  TweetTableViewCell.swift
//  Revels-20
//
//  Created by Rohit Kuber on 30/10/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell {
    
//    lazy var tweetView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .gray
//        view.layer.cornerRadius = 10
//        return view
//    }()
//
//    lazy var profileImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFill
//        iv.setDimensions(width: 28, height: 28)
//        iv.layer.cornerRadius = 28/2
//        iv.layer.masksToBounds = true
//        iv.clipsToBounds = true
//        iv.backgroundColor = .white
//        iv.layer.borderWidth = 0.5
//        return iv
//    }()
//
//    lazy var usernameLabel: UILabel = {
//        let label = UILabel()
//        label.text = "MITTechtatva"
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.numberOfLines = 1
//        label.textAlignment = .left
//        label.textColor = .white
//        return label
//    }()
//
//    lazy var tweetlabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 18)
//        label.numberOfLines = 0
//        label.textAlignment = .left
//        label.textColor = .white
//        return label
//    }()
//
//
//    lazy var likesLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 13)
//        label.numberOfLines = 1
//        label.textAlignment = .left
//        label.textColor = .white
//        return label
//    }()
//
//    lazy var retweetLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 13)
//        label.numberOfLines = 1
//        label.textAlignment = .left
//        label.textColor = .white
//        return label
//    }()
//
//
//    lazy var commentsLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 13)
//        label.numberOfLines = 1
//        label.textAlignment = .left
//        label.textColor = .white
//        return label
//    }()
//
//    lazy var likesImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFit
//        iv.layer.cornerRadius = 4
////        iv.setDimensions(width: 8, height: 8)
//        iv.image = UIImage(named: "heart")
////        iv.backgroundColor = .gray
//        iv.layer.masksToBounds = true
//        iv.clipsToBounds = true
//        return iv
//    }()
//
//    lazy var retweetImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFit
//        iv.layer.cornerRadius = 4
//        iv.layer.masksToBounds = true
//        iv.clipsToBounds = true
//        iv.image = UIImage(named: "retweet")
//        return iv
//    }()
//
//    lazy var commentImageView: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFit
//        iv.layer.cornerRadius = 4
//        iv.layer.masksToBounds = true
//        iv.clipsToBounds = true
//        iv.image = UIImage(named: "comment")
//        return iv
//    }()
    
    lazy var tweetView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0/255, green: 172/255, blue: 238/255, alpha: 1)
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 10
        return view
    }()
     
    lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 28, height: 28)
        iv.layer.cornerRadius = 28/2
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.backgroundColor = .white
        iv.layer.borderWidth = 0.5
        return iv
    }()
    lazy var righttwitterlogo: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(width: 28, height: 28)
        iv.layer.cornerRadius = 28/2
        iv.image = UIImage(named: "bluebird")
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.backgroundColor = .white
        iv.layer.borderWidth = 0.5
        return iv
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "@revelsmit"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .black
         
        return label
    }()
    
    lazy var tweetlabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.2
        return label
    }()
   
    
    lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var retweetLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    
    lazy var commentsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .white
        return label
    }()
    
    lazy var likesImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 4
        iv.image = UIImage(named: "heart")
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        return iv
    }()
    
    lazy var retweetImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 4
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.image = UIImage(named: "retweet")
        return iv
    }()
    
    lazy var commentImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 4
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.image = UIImage(named: "comment")
        return iv
    }()
    
  

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        
        self.backgroundColor = .clear
        self.selectedBackgroundView = UIView()
        
//

        
        addSubview(tweetView)
        
        addSubview(profileImageView)
        _ = profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 16, bottomConstant: 0, rightConstant: 0)
        
        addSubview(usernameLabel)
        _ = usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 13, leftConstant: 8, bottomConstant: 0, rightConstant: 8, heightConstant: 0)
        
        print("Framewidth:",frame.width-30)
        
        let stackView = UIStackView(arrangedSubviews: [likesLabel,retweetLabel])
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .black
        addSubview(stackView)
        _ = stackView.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 42, heightConstant: 64)
        
        
        let logoStackView = UIStackView(arrangedSubviews: [likesImageView,retweetImageView])
        logoStackView.axis = .vertical
        logoStackView.distribution = .fillEqually
        logoStackView.backgroundColor = .black
        
        addSubview(logoStackView)
       _ = logoStackView.anchor(top: topAnchor, left: nil, bottom: nil, right: stackView.leftAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 2, widthConstant: 32, heightConstant: 64)
        
        addSubview(tweetlabel)
        _ = tweetlabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: logoStackView.leftAnchor, topConstant: 10, leftConstant: 18, bottomConstant: 20, rightConstant: 12, widthConstant: 0)
        
        
        _ = tweetView.anchor(top: profileImageView.topAnchor, left: leftAnchor, bottom: tweetlabel.bottomAnchor, right: logoStackView.leftAnchor, topConstant: -8, leftConstant: 10, bottomConstant: -10, rightConstant: 4, widthConstant: 0, heightConstant: 0)
        
//        addSubview(righttwitterlogo)
//        _ = righttwitterlogo.anchor(top: topAnchor, left: nil, bottom: nil, right: tweetView.rightAnchor, topConstant: 0, leftConstant:0, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 0)
        
    }

}
