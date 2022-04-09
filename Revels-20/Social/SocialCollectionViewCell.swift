//
//  SocialCollectionViewCell.swift
//  Revels-20
//
//  Created by Tushar Elangovan on 08/04/22.
//  Copyright © 2022 Naman Jain. All rights reserved.
//

import UIKit

class SocialCollectionViewCell: UICollectionViewCell,CAAnimationDelegate{
    let color1: CGColor = UIColor(red: 92/255, green: 39/255, blue: 116/255, alpha: 1).cgColor
    let color2: CGColor = UIColor(red: 51/255, green: 92/255, blue: 197/255, alpha: 1).cgColor
    let color3: CGColor = UIColor(red: 99/255, green: 127/255, blue: 253/255, alpha: 1).cgColor
    
    let gradient: CAGradientLayer = CAGradientLayer()
    var gradientColorSet: [[CGColor]] = []
    var colorIndex: Int = 0
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            animateGradient()
        }
    }
    
    func setupGradient(){
        gradientColorSet = [
            [color1, color2],
            [color2, color3],
            [color3, color1]
        ]
        
        gradient.frame = self.contentView.bounds
        gradient.colors = gradientColorSet[colorIndex]
        
        self.contentView.layer.addSublayer(gradient)
    }
    
    func animateGradient() {
        gradient.colors = gradientColorSet[colorIndex]
        
        let gradientAnimation = CABasicAnimation(keyPath: "colors")
        gradientAnimation.delegate = self
        gradientAnimation.duration = 3.0
        
        updateColorIndex()
        gradientAnimation.toValue = gradientColorSet[colorIndex]
        
        gradientAnimation.fillMode = .forwards
        gradientAnimation.isRemovedOnCompletion = false
        
        gradient.add(gradientAnimation, forKey: "colors")
    }
    
    func updateColorIndex(){
        if colorIndex < gradientColorSet.count - 1 {
            colorIndex += 1
        } else {
            colorIndex = 0
        }
    }
    
    lazy var bgView: UIView = {
       let l = UIView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.layer.cornerRadius = 25.0
       return l
    }()
    
    lazy var bgImageView: UIImageView = {
        let l = UIImageView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.contentMode = .scaleAspectFit
        l.layer.shadowColor = UIColor.black.cgColor
            l.layer.shadowOpacity = 1
            l.layer.shadowOffset = CGSize.zero
            l.layer.shadowRadius = 10
            l.layer.shadowPath = UIBezierPath(rect: l.bounds).cgPath
            l.layer.shouldRasterize = false
            l.layer.cornerRadius = 10
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

        setupGradient()
        animateGradient()
        contentView.layer.cornerRadius = 20
        
        contentView.addSubview(bgView)
        bgView.addSubview(bgImageView)
        NSLayoutConstraint.activate([
        
            
            bgView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor),
            bgView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor),
        
            bgImageView.topAnchor.constraint(equalTo: bgView.layoutMarginsGuide.topAnchor, constant: contentView.frame.height/4),
            bgImageView.leadingAnchor.constraint(equalTo: bgView.layoutMarginsGuide.leadingAnchor, constant: contentView.frame.width/4),
            bgImageView.trailingAnchor.constraint(equalTo: bgView.layoutMarginsGuide.trailingAnchor, constant: -contentView.frame.width/4),
            bgImageView.bottomAnchor.constraint(equalTo: bgView.layoutMarginsGuide.bottomAnchor, constant: -contentView.frame.height/4),
            
//            nameLbl.topAnchor.constraint(equalTo: bgImageView.layoutMarginsGuide.topAnchor, constant: 10),
//            nameLbl.leadingAnchor.constraint(equalTo: bgImageView.layoutMarginsGuide.leadingAnchor),
//            nameLbl.trailingAnchor.constraint(equalTo: bgImageView.layoutMarginsGuide.trailingAnchor),
//            nameLbl.bottomAnchor.constraint(equalTo: bgImageView.layoutMarginsGuide.bottomAnchor, constant: -10),
    
        ])
    }
    
    func setGradientBackground() {
        let colorTop =  UIColor(red: 56/255.0, green: 0/255.0, blue: 54/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 12/255.0, green: 186/255.0, blue: 186/255.0, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        
       // gradientLayer.locations = [0.45, 0.55]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.contentView.bounds
        gradientLayer.colors = [colorBottom, colorTop]
        self.contentView.layer.insertSublayer(gradientLayer, at:0)
    }
    
}
