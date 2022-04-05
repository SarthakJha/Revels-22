//
//  UsersViewController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 24/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.


import UIKit
import FirebaseMessaging

//this boolean is used for reloading user page when loading for the first time
var fromLogin = true


class UsersViewController: UITableViewController {

    var user: User? {
        didSet{
            tableView.isScrollEnabled = true
            tableView.reloadData()
            tableView.showsVerticalScrollIndicator = false
            infoView?.alpha = 0
            makeClearNavBar()
        }
    }

    private var themedStatusBarStyle: UIStatusBarStyle?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return themedStatusBarStyle ?? UIStatusBarStyle.lightContent
    }

    func updateStatusBar(){
        themedStatusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }

    func makeClearNavBar(){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        updateStatusBar()
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.view.backgroundColor = .clear
    }

    var infoView: InformationView?


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.register(QRDelegateIDTableViewCell.self, forCellReuseIdentifier: "cellId")
       // tableView.register(UserIDTableViewCell.self, forCellReuseIdentifier: "cellId")
        if UserDefaults.standard.isLoggedIn(){

        }else{
            setupViewForLoggedOutUser()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if UserDefaults.standard.isLoggedIn() {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            
            self.updateStatusBar()
            if fromLogin {
                if let user = Caching.sharedInstance.getUserDetailsFromCache() {
//                    print(user)
                    self.user = user
                }else{
                    self.logOutUser()
                    print("cannot get user")
                }
                fromLogin = false
            }
        }else{
            print("not logged in")
        }
    }

    func setupViewForLoggedOutUser(){
        tableView.reloadData()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.isScrollEnabled = false
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        infoView = InformationView(frame: .init(x: 0, y: 0, width: width, height: height))
        infoView?.usersViewController = self
        tableView.addSubview(infoView!)
        infoView?.alpha = 1
                updateStatusBar()
        print("Checking infoview")
        updateStatusBar()
        
    }

    func presentLogin(){
        let login = LoginViewController()
        let loginNav = MasterNavigationBarController(rootViewController: login)
        if #available(iOS 13.0, *) {
            loginNav.modalPresentationStyle = .fullScreen
            loginNav.isModalInPresentation = true
        } else {
            // Fallback on earlier versions
        }
        fromLogin = true
        present(loginNav, animated: true)
    }

    func logOutUser(){
        let actionSheet = UIAlertController(title: "Are you Sure?", message: nil, preferredStyle: .alert)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let sureAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            if let subsDict = UserDefaults.standard.dictionary(forKey: "subsDictionary") as? [String: Bool]{
                for (key, _) in subsDict{
                    Messaging.messaging().unsubscribe(fromTopic: key)
                    print("Unsubscribing from \(key)")
                }
            }
            UserDefaults.standard.set([:], forKey: "subsDictionary")
            UserDefaults.standard.removeObject(forKey: "token")
            UserDefaults.standard.synchronize()


            UserDefaults.standard.setIsLoggedIn(value: false)
            self.setupViewForLoggedOutUser()
        }
        actionSheet.addAction(sureAction)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }

//MARK: Registered Events
    func showRegisteredEvents(RegisteredEvents: [TeamDetails]){
        let vc = RegisteredEventsViewController()
        vc.registeredEvents = RegisteredEvents
        navigationController?.pushViewController(vc, animated: true)
    }

    var driveLink: UITextField!
        
        func updateDriveLink(){
            //Do something
            DispatchQueue.main.async(execute:{
                let alertController = UIAlertController(title: "Update Drive Link", message: "\n Are you sure you want to update your google drive link?", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                let sureAction = UIAlertAction(title: "Continue", style: .destructive) { (_) in
                        guard let userID = self.user?.userID else {return}
                        print("User id:",userID)
                }
                alertController.addAction(sureAction)
                alertController.addAction(cancel)
                alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                            textField.placeholder = "Enter Drive Link"
                            self.driveLink = textField
                        })
                
                self.present(alertController, animated: true, completion: nil)
                })

    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if UserDefaults.standard.isLoggedIn(){
            return 1
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! QRDelegateIDTableViewCell
      //  let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UserIDTableViewCell
        cell.user = self.user
        cell.contentView.isUserInteractionEnabled = false
        cell.usersViewController = self
        cell.selectionStyle = .none
        return cell
    }

}
