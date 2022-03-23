//
//  YoutubeCell.swift
//  Revels-20
//
//  Created by Rohit Kuber on 27/09/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit

class YoutubeCell: UICollectionViewCell {
    
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
        label.numberOfLines = 1
        label.textColor = .white
//        label.text = "Techtatva 20 is back, yeah yeah"
        label.textAlignment = .left
        return label
    }()
    
    lazy var backgroundCard : UIView = {
        let view = UIView()
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    fileprivate func setupLayout(){
        
        addSubview(backgroundCard)
        self.backgroundColor = .clear
        self.selectedBackgroundView = UIView()
        
        
        addSubview(thumbnailImageView)
        _ = thumbnailImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 4, leftConstant: 16, bottomConstant: 0, rightConstant:0,widthConstant: frame.width-32, heightConstant: 224)

        addSubview(descriptionlabel)
        _ = descriptionlabel.anchor(top: thumbnailImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 8 ,heightConstant: 26)
        
        _ = backgroundCard.anchor(top: thumbnailImageView.topAnchor, left: leftAnchor, bottom: descriptionlabel.bottomAnchor, right: rightAnchor, topConstant: -8, leftConstant: 0, bottomConstant: -8, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

