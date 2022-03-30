//
//  EventViewController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 01/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Disk
import AudioToolbox
import FirebaseMessaging

class EventsViewController: UITableViewController {
    
    var scheduleController: ScheduleController?
    var tagsEventController: TagsEventsViewController?
//    var featuredEventController: FeaturedEventsConroller?
    
    var fromTags :Bool = false
    var event: Event! {
        didSet{
            tableView.reloadData()
        }
    }
    
    var schedule: Schedule? {
        didSet{
            tableView.reloadData()
        }
    }
    
    var user: User?{
        didSet{
            
        }
    }
    
    var userStatusUpdate: User?{
        didSet{
            
        }
    }
    
    var categoriesDictionary = [String: Category]()
    var delegateDictionary = [Int: DelegateCard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.CustomColors.Black.background
//        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.register(EventCell.self, forCellReuseIdentifier: "cellId")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        getCachedUserDetails()
        getCachedCategoriesDictionary()
        getCachedDelegatedCardDictionary()
    }

    func getCachedCategoriesDictionary(){
        do{
            let retrievedCategoriesDictionary = try Disk.retrieve(categoriesDictionaryCache, from: .caches, as: [String: Category].self)
            self.categoriesDictionary = retrievedCategoriesDictionary
        }
        catch let error{
            print("Category cache error in EventsController: ", error)
        }
    }
    
    func getCachedDelegatedCardDictionary(){
        do{
            let retDict = try Disk.retrieve(delegateCardsDictionaryCache, from: .caches, as: [Int: DelegateCard].self)
            self.delegateDictionary = retDict
        }
        catch let error{
            print("Delegate card cache error in EventsController:", error)
        }
    }
    
    func getCachedUserDetails(){
        self.user =  Caching.sharedInstance.getUserDetailsFromCache()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = self.schedule else{ return 5 }
        return 9
    }
    
//     This is shown when you tap on a schedule and event cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! EventCell
        
        var textLabel = "N/A"
        var detailedTextLabel = "N/A"
        var imageName = "calendar"
        let formatter = DateFormatter()
        guard let event = event else { return cell }
        let category = categoriesDictionary[event.category.category]
        
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            if let schedule = self.schedule{
                textLabel = "Round"
                detailedTextLabel = "\(schedule.round)"
                imageName = "assessment"
            }else{
                textLabel = "Category"
                detailedTextLabel = category?.name ?? ""
                imageName = "category"
            }
            break
        case 1:
            if let _ = self.schedule{
                textLabel = "Category"
                detailedTextLabel = category?.name ?? ""
                imageName = "category"
                break
            }else{
                textLabel = "Team Size"
                detailedTextLabel = "\(event.maxMembers - event.minMembers)"
                imageName = "group"
            }

        case 2:
            if let schedule = self.schedule{
                textLabel = "Date"

                if(schedule.day==1){
                    detailedTextLabel = "05 Nov 2020"
                }else if(schedule.day==2){
                    detailedTextLabel = "06 Nov 2020"
                }else if(schedule.day==3){
                    detailedTextLabel = "07 Nov 2020"
                }else{
                    detailedTextLabel = "08 Nov 2020"
                }
            }else{
                textLabel = "Delegate Card"
                
                if(event.category.category == "Gaming"){
                    detailedTextLabel = "Gaming"
                }
                else{
                detailedTextLabel = "Free"
                }

                imageName = "card"
                if detailedTextLabel != "" {
                    cell.selectionStyle = .gray
                    cell.accessoryType = .disclosureIndicator
                }
            break
            }
        case 3:
            if let schedule = self.schedule{
                textLabel = "Time"
//                formatter.dateFormat = "h:mm a"
//                var startDate = Date(dateString: schedule.start)
//                startDate = Calendar.current.date(byAdding: .hour, value: -5, to: startDate)!
//                startDate = Calendar.current.date(byAdding: .minute, value: -30, to: startDate)!
//                var endDate = Date(dateString: schedule.end)
//                endDate = Calendar.current.date(byAdding: .hour, value: -5, to: endDate)!
//                endDate = Calendar.current.date(byAdding: .minute, value: -30, to: endDate)!
//                var dateString = formatter.string(from: startDate)
//                dateString.append(" - \(formatter.string(from: endDate))")
                detailedTextLabel = schedule.time
                imageName = "timer"
            }else{
                textLabel = "Contact 1"
                detailedTextLabel = category?.cc?[0].name ?? "N/A"
                if detailedTextLabel != "N/A" {
                    cell.selectionStyle = .gray
                }
                imageName = "contact"
            }
            break
        case 4:
            if let schedule = self.schedule{
                textLabel = "Venue"
                detailedTextLabel = schedule.location
                imageName = "location"
            }else{
                textLabel = "Contact 2"
                detailedTextLabel = category?.cc?[1].name ?? "N/A"
                if detailedTextLabel != "N/A" {
                    cell.selectionStyle = .gray
                }
                imageName = "contact"
            }
            break
        case 5:
            if let _ = self.schedule{
                textLabel = "Team Size"
                detailedTextLabel = "\(event.maxMembers - event.minMembers)"
                imageName = "group"
            }else{
                textLabel = "Contact 2"
                detailedTextLabel = category?.cc?[1].name ?? "N/A"
                if detailedTextLabel != "N/A" {
                    cell.selectionStyle = .gray
                }
                imageName = "contact"
            }
            break
        case 6:
            textLabel = "Delegate Card"
            if(event.category.category == "Gaming"){
                detailedTextLabel = "Gaming"
            }
            else{
            detailedTextLabel = "Free"
            }
            imageName = "card"
            if detailedTextLabel != "" {
                cell.selectionStyle = .gray
                cell.accessoryType = .disclosureIndicator
            }
            break
        case 7:
            textLabel = "Contact 1"
            detailedTextLabel = category?.cc?[0].name ?? "N/A"
            if detailedTextLabel != "N/A" {
                cell.selectionStyle = .gray
            }
            imageName = "contact"
            break
        case 8:
            textLabel = "Contact 2"
            detailedTextLabel = category?.cc?[1].name ?? "N/A"
            if detailedTextLabel != "N/A" {
                cell.selectionStyle = .gray
            }
            imageName = "contact"
            break
        default:
            textLabel = "Team Size"
            cell.selectionStyle = .gray
        }
        cell.imageView?.image = UIImage(named: imageName)
        cell.imageView?.setImageColor(color: .white)
        cell.textLabel?.text = textLabel
        cell.detailTextLabel?.text = detailedTextLabel
        return cell
    }
    
    let createTeam = LoadingButton(type: .system)
    let joinTeam = LoadingButton(type: .system)
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.CustomColors.Black.background
        
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = event?.name ?? ""
        
        let closedReg = UILabel()
        closedReg.textColor = .red
        closedReg.font = UIFont.systemFont(ofSize: 13)
        closedReg.textAlignment = .center
        closedReg.numberOfLines = 2
        closedReg.text = "Registrations are closed for this event"
        
        createTeam.backgroundColor = UIColor.CustomColors.Theme.themeColor
        createTeam.setTitle("Register", for: UIControl.State())
        createTeam.translatesAutoresizingMaskIntoConstraints = false
        createTeam.startAnimatingPressActions()
        createTeam.layer.cornerRadius = 10
        createTeam.setTitleColor(.white, for: UIControl.State())
        
        joinTeam.backgroundColor = UIColor.systemRed
        joinTeam.setTitle("Join Team", for: UIControl.State())
        joinTeam.translatesAutoresizingMaskIntoConstraints = false
        joinTeam.startAnimatingPressActions()
        joinTeam.layer.cornerRadius = 10
        joinTeam.setTitleColor(.white, for: UIControl.State())
        
        
        if isSmalliPhone(){
            label.font = UIFont.boldSystemFont(ofSize: 15)
            closedReg.font = UIFont.systemFont(ofSize: 12)
            createTeam.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            joinTeam.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        }else{
            label.font = UIFont.boldSystemFont(ofSize: 18)
            createTeam.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            joinTeam.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        }
        createTeam.layer.cornerRadius = 10
        createTeam.addTarget(self, action: #selector(registerTeamLeader), for: .touchUpInside)
        joinTeam.addTarget(self, action: #selector(registerTeammate), for: .touchUpInside)

        
//        if event.can_register == 1{
            view.addSubview(label)
            _ = label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 25)
            
            view.addSubview(createTeam)
           _ = createTeam.anchor(top: label.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 8, leftConstant: 32, bottomConstant: 8, rightConstant: 0,widthConstant: UIViewController().view.frame.width/2-40)
//        print("create team width", UIViewController().view.frame.width/2-40)
            view.addSubview(joinTeam)
        _ = joinTeam.anchor(top: label.bottomAnchor, left: createTeam.rightAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 8, leftConstant: 16, bottomConstant: 8, rightConstant: 0,widthConstant: UIViewController().view.frame.width/2-40)
        
//        }else{
//
//            view.addSubview(label)
//            _ = label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 25)
//
//            view.addSubview(closedReg)
//            closedReg.anchorWithConstants(top: label.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 8, rightConstant: 16)
//        }
        
        return view
    }
    
    @objc func registerTeamLeader(){
        print("Create Team Pressed")
        
        
  
        DispatchQueue.main.async(execute:{
        let alertController = UIAlertController(title: "Register", message: "\n Register for the event as a single person or as a team leader in a team event", preferredStyle: .alert)

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let sureAction = UIAlertAction(title: "Continue", style: .default) { (_) in
            if UserDefaults.standard.isLoggedIn(){
                print("loggined")
                self.createTeam.showLoading()
                self.createTeam.activityIndicator.color = .white
                //let eventID = self.event.id else {return }
                let eventID = self.event.id
                let userID = self.user?.userID
               // let userID = self.user?.userID else {return}
                
                Networking.sharedInstance.registerEventWith(eventID: eventID,userid: userID!, category:self.event.category.category, successCompletion: { (message) in
                    self.createTeam.hideLoading()
                    print(message)
                    FloatingMessage().longFloatingMessage(Message: "Successfully Registered for \(self.event.name).", Color: UIColor.CustomColors.Theme.themeColor!, onPresentation: {
                        Networking.sharedInstance.getStatusUpdate { (user) in
                            print(user)
                            Caching.sharedInstance.saveUserDetailsToCache(user: user)
                            self.userStatusUpdate = user
                        }

                    }){}
                }) { (message) in
                    self.createTeam.hideLoading()
                    print(message)
                    if message == "User already registered for event" {
                        FloatingMessage().longFloatingMessage(Message: "You have already registered for \(self.event.name)", Color: .orange, onPresentation: {}) {}
                    }else{
                        FloatingMessage().longFloatingMessage(Message: message, Color: .orange, onPresentation: {}) {}
                    }
                }
                self.createTeam.hideLoading()
                
            }
            else{
                DispatchQueue.main.async(execute: {
                    let alertController = UIAlertController(title: "Sign in to Register", message: "You need to be signed in to register for any event.", preferredStyle: UIAlertController.Style.actionSheet)
                    let logInAction = UIAlertAction(title: "Sign In", style: .default, handler: { (action) in
                        let login = LoginViewController()
                        let loginNav = MasterNavigationBarController(rootViewController: login)
                        if #available(iOS 13.0, *) {
                            loginNav.modalPresentationStyle = .fullScreen
                            loginNav.isModalInPresentation = true
                        } else {
                            // Fallback on earlier versions
                        }
                        fromLogin = true
                        self.present(loginNav, animated: true)
                    })
                    let createNewAccountAction = UIAlertAction(title: "Create New Account", style: .default, handler: { (action) in
                        let login = LoginViewController()
                        let loginNav = MasterNavigationBarController(rootViewController: login)
                        fromLogin = true
                        self.present(loginNav, animated: true, completion: {
                            login.handleRegister()
                        })
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertController.addAction(logInAction)
                    alertController.addAction(createNewAccountAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                })
                return
            }
        }
            alertController.addAction(sureAction)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: nil)
        })
        
    }
        
    var partyCode: UITextField!
    
    @objc func registerTeammate(){
        
        DispatchQueue.main.async(execute:{
        let alertController = UIAlertController(title: "Join Team", message: "\n Enter party code to register with a team", preferredStyle: .alert)
    
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let sureAction = UIAlertAction(title: "Continue", style: .default) { (_) in
            if UserDefaults.standard.isLoggedIn(){
                print("loggined")
                self.joinTeam.showLoading()
                self.joinTeam.activityIndicator.color = .white
                guard let eventInfo = self.event else { return  }
              //  guard let eventID = eventInfo.id else {return }
                let eventID = eventInfo.id
                guard let userID = self.user?.userID else {return}
                guard let partyCodeValue = self.partyCode.text else{return}
                let categoryName = eventInfo.name
                print("User id:",userID)
                
                if partyCodeValue.count != 6{
            FloatingMessage().floatingMessage(Message: "Party code format is wrong", Color: .red, onPresentation: {
                self.joinTeam.hideLoading()
            }) {}
            return
        }

                
        Networking.sharedInstance.joinTeam(eventId: eventID, userID: userID, category: categoryName, partyCode: partyCodeValue, successCompletion: { (message) in
                    self.joinTeam.hideLoading()
                    print(message)
            FloatingMessage().longFloatingMessage(Message: "Successfully joined the team for \(eventInfo.name). ", Color: UIColor.CustomColors.Theme.themeColor!, onPresentation: {
                Networking.sharedInstance.getStatusUpdate { (user) in
                    print(user)
                    Caching.sharedInstance.saveUserDetailsToCache(user: user)
                    self.userStatusUpdate = user
                }
                    }){}
                }) { (message) in
                    self.joinTeam.hideLoading()
                    print(message)
                    if message == "User already registered for event" {
                        FloatingMessage().longFloatingMessage(Message: "You have already registered for \(self.event.name)", Color: .orange, onPresentation: {}) {}
                    }else{
                        self.joinTeam.hideLoading()
                        FloatingMessage().longFloatingMessage(Message: message, Color: .red, onPresentation: {
//                            self.joinTeam.hideLoading()
                        }) {}
                    }
                }
                self.joinTeam.hideLoading()
            }
            else{
                DispatchQueue.main.async(execute: {
                    let alertController = UIAlertController(title: "Sign in to Register", message: "You need to be signed in to register for any event.", preferredStyle: UIAlertController.Style.actionSheet)
                    let logInAction = UIAlertAction(title: "Sign In", style: .default, handler: { (action) in
                        let login = LoginViewController()
                        let loginNav = MasterNavigationBarController(rootViewController: login)
                        if #available(iOS 13.0, *) {
                            loginNav.modalPresentationStyle = .fullScreen
                            loginNav.isModalInPresentation = true
                        } else {
                            // Fallback on earlier versions
                        }
                        fromLogin = true
                        self.present(loginNav, animated: true)
                    })
                    let createNewAccountAction = UIAlertAction(title: "Create New Account", style: .default, handler: { (action) in
                        let login = LoginViewController()
                        let loginNav = MasterNavigationBarController(rootViewController: login)
                        fromLogin = true
                        self.present(loginNav, animated: true, completion: {
                            login.handleRegister()
                        })
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertController.addAction(logInAction)
                    alertController.addAction(createNewAccountAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                })
                return
            }
        }
            alertController.addAction(sureAction)
            alertController.addAction(cancel)
            alertController.addTextField(configurationHandler: {(textField: UITextField!) in
                        textField.placeholder = "Enter Party Code"
                        self.partyCode = textField
                    })
            
            self.present(alertController, animated: true, completion: nil)
      
        })
        
        //Do something
        Networking.sharedInstance.getStatusUpdate { (user) in
            self.userStatusUpdate = user
        }
}
        


    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 95
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension //60
    }
    
    //Make changes to the below function as per the new event model
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row{

        case 2:
            if(fromTags){
            self.presentDelegateCardInfo(categoryName: event.name)
            }
            break
        case 3:
            if (fromTags){
                let category = categoriesDictionary[event.category.category]
            if let number = category?.cc?[0].phoneNo{
                self.callNumber(number: number)
            }
            }
        case 4:
            if (fromTags){
                let category = categoriesDictionary[event.category.category]
            if let number = category?.cc?[1].phoneNo{
                self.callNumber(number: number)
            }
        }
            
        case 6:
            self.presentDelegateCardInfo(categoryName: event.name)
            break
            
        case 7:
            let category = categoriesDictionary[event.category.category]
        //    if let number = category.cc?[0].ph
            if let number = category?.cc?[0].phoneNo{
                self.callNumber(number: number)
            }
        case 8:
            let category = categoriesDictionary[event.category.category]
            if let number = category?.cc?[1].phoneNo{
                self.callNumber(number: number)
            }
        default: return
        }
    }
    
    fileprivate func callNumber(number: UInt64){
        AudioServicesPlaySystemSound(1519)
        if let url = URL(string: "tel://\(number)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    fileprivate func presentDelegateCardInfo(categoryName: String){
        
            DispatchQueue.main.async(execute: {
                if(categoryName == "Gaming"){
                    let alertController = UIAlertController(title: categoryName, message: "You need to contact the event CC for payment details and pay to register successfully for the event", preferredStyle: UIAlertController.Style.alert)
                    
                    let okayAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: { (_) in
                    })
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)

            }else{
           let alertController = UIAlertController(title: categoryName, message: "No delegate card is required to participate in the event", preferredStyle: UIAlertController.Style.alert)
           
           let okayAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: { (_) in
           })
           alertController.addAction(okayAction)
           self.present(alertController, animated: true, completion: nil)
       }
     
            })
    }
}



class EventCell: UITableViewCell{

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        
        if UIViewController().isSmalliPhone(){
            textLabel?.font = UIFont.systemFont(ofSize: 14)
            detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        backgroundColor = .clear
        textLabel?.textColor = .white
        detailTextLabel?.numberOfLines = 0
        textLabel?.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

