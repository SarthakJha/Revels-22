//
//  SocialCollectionViewCell.swift
//  Revels-20
//
//  Created by Tushar Elangovan on 08/04/22.
//  Copyright © 2022 Naman Jain. All rights reserved.
//

import UIKit

class SocialCollectionViewCell: UICollectionViewCell {
    
    lazy var bgImageView: UIImageView = {
        let l = UIImageView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.contentMode = .scaleAspectFit
        return l
    }()
    
    lazy var nameLbl: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: .headline)
        return l
    }()
    
    func setupLayout(){
        
        contentView.addSubview(bgImageView)
        bgImageView.addSubview(nameLbl)
        NSLayoutConstraint.activate([
        
        
            bgImageView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            bgImageView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
            
            nameLbl.topAnchor.constraint(equalTo: bgImageView.layoutMarginsGuide.topAnchor, constant: 10),
            nameLbl.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor, constant: contentView.frame.width/4),
            nameLbl.trailingAnchor.constraint(equalTo: bgImageView.layoutMarginsGuide.trailingAnchor,constant: -contentView.frame.width/4),
            nameLbl.bottomAnchor.constraint(equalTo: bgImageView.layoutMarginsGuide.bottomAnchor, constant: -10),
    
        ])
    }
    
}
