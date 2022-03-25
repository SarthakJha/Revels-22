//
//  QRDelegateTableViewCell.swift
//  TechTetva-19
//
//  Created by Naman Jain on 28/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import SDWebImage

protocol updateDriveDelegate{
    func updateDrive(link:String, userId: Int)
}

class UserIDTableViewCell: UITableViewCell {
    
    var usersViewController: UsersViewController?

    var user: User?{
        didSet{
            guard let user = user else { return }
                DispatchQueue.main.async {
                self.nameLabel.text = user.name
                self.emailLabel.text = user.email
                self.collegeLabel.text = user.college
                 //   self.stateLabel.text = "lavda"
            if let phoneno = user.mobileNumber{
                self.phoneLabel.text = String(phoneno)
            }
            if let userid = user.userID{
                self.userIDLabel.text = String(userid)
        }
            if let userVerified = user.verified{
                self.titleBackgroundText.text = userVerified
                    }
                }
        }
}
    
    lazy var titleBackgroundText: UILabel = {
           let label = UILabel()
           label.text = "User"
           label.font = UIFont.systemFont(ofSize: 68, weight: .bold)
           label.textColor = UIColor(white: 0.4, alpha: 0.3)
           label.textAlignment = .center
           return label
       }()
    
    lazy var containerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 12
        view.layer.masksToBounds = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.text = "Error 404"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    lazy var collegeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "There was an error"
        label.textColor = .black
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "fetching your details."
        label.textColor = .black
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "please log out and login again!"
        label.textColor = .black
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
    lazy var userTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "User ID"
        label.textColor = .black//UIColor.init(white: 1, alpha: 0.25)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
//
    lazy var userIDLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "NA"
        label.numberOfLines = 0
        label.textAlignment = .right
        label.textColor = .black
        return label
    }()
    
    lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "State"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()
    
//    lazy var logoImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(named:"anonymous")
//        imageView.contentMode = .scaleAspectFill
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    lazy var eventsButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.startAnimatingPressActions()
        button.backgroundColor = UIColor(named:"Theme")
        button.setTitle("Registered Events", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showRegisteredEvents), for: .touchUpInside)
        return button
    }()
    
    lazy var updateDriveButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.startAnimatingPressActions()
        button.backgroundColor = UIColor.CustomColors.Theme.themeColor
        button.backgroundColor = UIColor.white
        button.setTitle("Update Drive Link", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(named:"Theme"), for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(updateDriveLink), for: .touchUpInside)
        return button
    }()
    

    @objc func showRegisteredEvents(){
        eventsButton.showLoading()
        eventsButton.activityIndicator.tintColor = .white
        eventsButton.isEnabled = false
        eventsButton.animateDown(sender: self.eventsButton)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.eventsButton.animateUp(sender: self.eventsButton)
        }
            self.eventsButton.hideLoading()
            self.eventsButton.isEnabled = true
        
        guard let userReg = Caching.sharedInstance.getUserDetailsFromCache() else {return}
        
        if userReg.regEvents?.count == 0{
                FloatingMessage().longFloatingMessage(Message: "You have not registered for any events.", Color: .orange, onPresentation: {}) {}
                return
            }else{
                self.usersViewController?.showRegisteredEvents(RegisteredEvents: userReg.teamDetails ?? [])
            }
        self.eventsButton.hideLoading()
        self.eventsButton.isEnabled = true
    }
    
    
    lazy var logoutButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.isUserInteractionEnabled = true
        button.setTitle("LOG OUT", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.red, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    @objc func handleLogout(){
        logoutButton.animateDown(sender: self.logoutButton)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.logoutButton.animateUp(sender: self.logoutButton)
        }
        
        usersViewController?.logOutUser()
    }
    
    
    @objc func updateDriveLink(){
            updateDriveButton.animateDown(sender: self.updateDriveButton)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                self.updateDriveButton.animateUp(sender: self.updateDriveButton)
            }
            
            usersViewController?.updateDriveLink()
        }
    
    lazy var userLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "User ID"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
  
    lazy var emailIdLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Email ID"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    lazy var stateInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "State"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    lazy var contactLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Contact"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    lazy var collegeInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "College"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    
    lazy var previewView: QRCodeReaderView = {
        let view = QRCodeReaderView()
        view.backgroundColor = .black
        view.setupComponents(with: QRCodeReaderViewControllerBuilder{
            $0.reader                 = reader
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = false
            $0.showCancelButton       = false
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        })
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var reader: QRCodeReader = QRCodeReader()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        if UIViewController().isSmalliPhone(){

            titleBackgroundText.font = UIFont.systemFont(ofSize: 64, weight: .bold)
            addSubview(titleBackgroundText)
            _ = titleBackgroundText.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 64, leftConstant: -12, bottomConstant: 0, rightConstant: -12, widthConstant: 0, heightConstant: 0)
            
            nameLabel.font = UIFont.boldSystemFont(ofSize: 23)
            addSubview(nameLabel)
            _ = nameLabel.anchor(top: titleBackgroundText.topAnchor, left: leftAnchor, bottom: titleBackgroundText.bottomAnchor, right: rightAnchor, topConstant: 6, leftConstant: 16, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 0)
            
            
            addSubview(previewView)
            _ = previewView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 64, leftConstant: -12, bottomConstant: 0, rightConstant: -12, widthConstant: 0, heightConstant: 0)
            
            
            addSubview(containerView)
            
            _ = containerView.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 32, leftConstant: 8, bottomConstant: 0, rightConstant: 8, heightConstant: UIViewController().view.frame.width/2+20)
            
            
             let stackInfoView = UIStackView(arrangedSubviews: [userLabel,emailIdLabel,stateInfoLabel,contactLabel,collegeInfoLabel])
             stackInfoView.axis = .vertical
             stackInfoView.distribution = .equalSpacing
 //            stackInfoView.backgroundColor = .blue
             
             containerView.addSubview(stackInfoView)
             _ = stackInfoView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil,topConstant: 16,leftConstant: 16,bottomConstant: 16,rightConstant: 0,widthConstant: 60)
             
             let stackView = UIStackView(arrangedSubviews: [userIDLabel,emailLabel,stateLabel,phoneLabel,collegeLabel])
             stackView.axis = .vertical
             stackView.distribution = .equalSpacing

             
             containerView.addSubview(stackView)
             
             _ = stackView.anchor(top: containerView.topAnchor, left: stackInfoView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 16, leftConstant:8, bottomConstant: 16, rightConstant: 16)
             
            
            addSubview(eventsButton)
            _ = eventsButton.anchor(top: containerView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
            
            addSubview(updateDriveButton)
            _ = updateDriveButton.anchor(top: eventsButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 12, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 40)
            
            addSubview(logoutButton)
            _ = logoutButton.anchor(top: updateDriveButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 12, leftConstant: 16, bottomConstant: 32, rightConstant: 16, widthConstant: 0, heightConstant: 40)
            
            eventsButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)

            logoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            
        }else{

            
            addSubview(titleBackgroundText)
            _ = titleBackgroundText.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 100, leftConstant: -12, bottomConstant: 0, rightConstant: -12, widthConstant: 0, heightConstant: 0)
            
            
            addSubview(nameLabel)
            _ = nameLabel.anchor(top: titleBackgroundText.topAnchor, left: leftAnchor, bottom: titleBackgroundText.bottomAnchor, right: rightAnchor, topConstant: 6, leftConstant: 16, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 0)
            
            addSubview(containerView)
            
            _ = containerView.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 64, leftConstant: 12, bottomConstant: 0, rightConstant: 12, heightConstant: UIViewController().view.frame.width/2+20)
            
           
            let stackInfoView = UIStackView(arrangedSubviews: [userLabel,emailIdLabel,contactLabel,collegeInfoLabel])
            stackInfoView.axis = .vertical
            stackInfoView.distribution = .equalSpacing
//            stackInfoView.backgroundColor = .blue
            
            containerView.addSubview(stackInfoView)
            _ = stackInfoView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil,topConstant: 16,leftConstant: 16,bottomConstant: 16,rightConstant: 0,widthConstant: 60)
            
            let stackView = UIStackView(arrangedSubviews: [userIDLabel,emailLabel,phoneLabel,collegeLabel])
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
//            stackView.backgroundColor = .blue
            
            containerView.addSubview(stackView)
            
            _ = stackView.anchor(top: containerView.topAnchor, left: stackInfoView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 16, leftConstant:8, bottomConstant: 16, rightConstant: 16)
            
 
            addSubview(eventsButton)
            _ = eventsButton.anchor(top: containerView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 24, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
            
//            addSubview(updateDriveButton)
//            _ = updateDriveButton.anchor(top: eventsButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
            
            addSubview(logoutButton)
            _ = logoutButton.anchor(top: eventsButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 32, rightConstant: 16, widthConstant: 0, heightConstant: 50)
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

