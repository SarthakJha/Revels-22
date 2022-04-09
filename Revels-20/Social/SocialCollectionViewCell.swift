//
//  SocialCollectionViewCell.swift
//  Revels-20
//
//  Created by Tushar Elangovan on 08/04/22.
//  Copyright © 2022 Naman Jain. All rights reserved.
//

import UIKit

class SocialCollectionViewCell: UICollectionViewCell {
    
    lazy var bgView: UIView = {
       let l = UIView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.layer.cornerRadius = 25
       return l
    }()
    
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
        l.textAlignment = .center
        l.adjustsFontSizeToFitWidth = true
        return l
    }()
    
    func setupLayout(){
        contentView.layer.cornerRadius = 10
        setGradientBackground()
      //  bgView.backgroundColor = .orange
        
        contentView.addSubview(bgView)
        bgView.addSubview(bgImageView)
        bgImageView.addSubview(nameLbl)
        NSLayoutConstraint.activate([
        
            
            bgView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            bgView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        
            bgImageView.topAnchor.constraint(equalTo: bgView.layoutMarginsGuide.topAnchor),
            bgImageView.leadingAnchor.constraint(equalTo: bgView.layoutMarginsGuide.leadingAnchor, constant: contentView.frame.width/4),
            bgImageView.trailingAnchor.constraint(equalTo: bgView.layoutMarginsGuide.trailingAnchor, constant: -contentView.frame.width/4),
            bgImageView.bottomAnchor.constraint(equalTo: bgView.layoutMarginsGuide.bottomAnchor),
            
            nameLbl.topAnchor.constraint(equalTo: bgImageView.layoutMarginsGuide.topAnchor, constant: 10),
            nameLbl.leadingAnchor.constraint(equalTo: bgImageView.layoutMarginsGuide.leadingAnchor),
            nameLbl.trailingAnchor.constraint(equalTo: bgImageView.layoutMarginsGuide.trailingAnchor),
            nameLbl.bottomAnchor.constraint(equalTo: bgImageView.layoutMarginsGuide.bottomAnchor, constant: -10),
    
        ])
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 37/255.0, green: 150/255.0, blue: 190/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor.white.cgColor
        let gradientLayer = CAGradientLayer()
        
       // gradientLayer.locations = [0.45, 0.55]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.contentView.bounds
        gradientLayer.colors = [colorBottom, colorTop]
        self.contentView.layer.insertSublayer(gradientLayer, at:0)
    }
    
}
