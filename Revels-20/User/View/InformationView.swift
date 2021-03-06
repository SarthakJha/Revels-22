//
//  InformationView.swift
//  TechTetva-19
//
//  Created by Naman Jain on 27/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit


class InformationView: UIView {
    
    
    
    var usersViewController: UsersViewController?
    
    lazy var loginButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.startAnimatingPressActions()
     //   button.backgroundColor = UIColor.CustomColors.Purple.register
        button.backgroundColor = UIColor.CustomColors.Theme.themeColor
        button.setTitle("Continue", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        if UIViewController().isSmalliPhone(){
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        }else{
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        }
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(presentLogin), for: .touchUpInside)
        return button
    }()
    
    @objc func presentLogin(){
        loginButton.animateDown(sender: self.loginButton)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.loginButton.animateUp(sender: self.loginButton)
        }
        self.usersViewController?.presentLogin()
    }
    
    let loginTextLabel: UILabel = {
        let label = UILabel()
        label.text = "Revels'22 aims to transform the paradigm of a college fest and unite nation-wide students even in the midst of a global pandemic by going online.An arena for ideas and learning in all domains of technology and the advancing modern world with various kinds of events.\n\nSign in to your Revels account to register for exciting events and have a chance to win huge cash prizes!"
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        if UIViewController().isSmalliPhone(){
            label.font = UIFont.boldSystemFont(ofSize: 14)
        }else{
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Revels-Logo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.CustomColors.Black.background
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        
        addSubview(loginTextLabel)
        addSubview(loginButton)
        addSubview(profileImageView)
        
        loginTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loginTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -(UIApplication.shared.statusBarFrame.height + 40)).isActive = true
        
        loginTextLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
        loginTextLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        loginButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: loginTextLabel.bottomAnchor, constant: 18).isActive = true
        loginButton.widthAnchor.constraint(equalTo: widthAnchor, constant: -48).isActive = true
        if UIViewController().isSmalliPhone(){
            loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }else{
            loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }
        
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginTextLabel.topAnchor, constant: -18).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    func removeView(){
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 0
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}

