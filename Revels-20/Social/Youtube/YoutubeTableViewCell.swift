//
//  YoutubeTableViewCell.swift
//  Revels-20
//
//  Created by Rohit Kuber on 02/11/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit

class YoutubeTableViewCell: UITableViewCell {
    
    lazy var thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 20
        iv.backgroundColor = .gray
        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    lazy var descriptionlabel: UILabel = {
        let label  = UILabel()
        if UIViewController().isSmalliPhone(){
            label.font = UIFont.systemFont(ofSize: 16)
        }else{
            label.font = UIFont.systemFont(ofSize: 20)
        }
        label.numberOfLines = 0
        label.textColor = .white
//        label.text = "Techtatva 20 is back, yeah yeah"
        label.textAlignment = .center
        return label
    }()
    
    lazy var backgroundCard : UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 20
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    fileprivate func setupLayout(){
        
//        contentView.backgroundColor = .white
        
        addSubview(backgroundCard)
        self.backgroundColor = .clear
        self.selectedBackgroundView = UIView()
        
        
        addSubview(thumbnailImageView)
        _ = thumbnailImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 16, bottomConstant: 0, rightConstant:0,widthConstant: frame.width-14, heightConstant: 224)

        addSubview(descriptionlabel)
        _ = descriptionlabel.anchor(top: thumbnailImageView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 10, leftConstant: 8, bottomConstant: 20, rightConstant: 0 ,heightConstant: 0)
        
        _ = backgroundCard.anchor(top: thumbnailImageView.topAnchor, left: leftAnchor, bottom: descriptionlabel.bottomAnchor, right: rightAnchor, topConstant: -10, leftConstant: 2, bottomConstant: -10, rightConstant: 5, widthConstant: 0, heightConstant: 0)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
