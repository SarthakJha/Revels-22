//
//  DevelopersTableViewCell.swift
//  Revels-20
//
//  Created by Rohit Kuber on 30/10/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit

class DevelopersTableViewCell: UITableViewCell {
    var homeViewController: HomeViewController?
    
    lazy var developersButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "developer")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.contentMode = .scaleAspectFit
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .lightGray
        button.backgroundColor = UIColor.CustomColors.Black.card
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showDevelopersPage), for: .touchUpInside)
        return button
    }()
    

    
    @objc func showDevelopersPage(){
        self.homeViewController?.showDeveloper()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        addSubview(developersButton)
        
        developersButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        _ = developersButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 8, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        developersButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
        
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.text = "Developers"
        
        
        if UIViewController().isSmalliPhone(){
            titleLabel.font = UIFont.boldSystemFont(ofSize: 10)
            
            developersButton.addSubview(titleLabel)
            _ = titleLabel.anchor(top: nil, left: developersButton.leftAnchor, bottom: developersButton.bottomAnchor, right: developersButton.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 14)
                        
            developersButton.imageEdgeInsets = .init(top: 8, left: 0, bottom: 18, right: 0)

        }else{
            titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
            
            developersButton.addSubview(titleLabel)
            _ = titleLabel.anchor(top: nil, left: developersButton.leftAnchor, bottom: developersButton.bottomAnchor, right: developersButton.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 8, rightConstant: 0, widthConstant: 0, heightConstant: 16)
            
            developersButton.imageEdgeInsets = .init(top: 16, left: 0, bottom: 32, right: 0)

        }
        
        

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
