//
//  RegisteredEventsViewController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 29/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import AudioToolbox


class RegisteredEventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
   
    let slideInTransitioningDelegate = SlideInPresentationManager(from: UIViewController(), to: UIViewController())
    
    
//    let teamDetailsButton = LoadingButton(type: .system)
    var user: User? {
        didSet{
            tableView.isScrollEnabled = true
            tableView.reloadData()
            tableView.showsVerticalScrollIndicator = false
        }
    }
    
    func updateView(){
        
    }

    private let refreshControl = UIRefreshControl()
    
    lazy var tableView : UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshRegisteredData), for: .valueChanged)
        return tv
    }()
    
    @objc func refreshRegisteredData(){
        Networking.sharedInstance.getStatusUpdate { (userData) in
            DispatchQueue.main.async {
           self.user = userData
          Caching.sharedInstance.saveUserDetailsToCache(user: userData)
//        print(userData)
          self.registeredEvents = userData.teamDetails
          self.refreshControl.endRefreshing()
//            self.updateView()
            }
        }
}
   
    
    
    var registeredEvents : [TeamDetails]!{
        didSet{
            tableView.reloadData()
        }
    }
    
    var teamMemberDetails: TeamMemberDetails?{
        didSet{
            
        }
    }
    
    var eventsDictionary:[Int:Event]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
       // self.navigationController?.popViewController(animated: true)
       
}
    
    
    var scheduleDict : [String:Schedule]?{
        didSet{
            tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Registered Events"
        if let user = Caching.sharedInstance.getUserDetailsFromCache() {
            self.user = user
        }
        if let eventsDictionary = Caching.sharedInstance.getEventsDataDictionary(){
            self.eventsDictionary = eventsDictionary
        }
        updateStatusBar()
    }
    
    private var themedStatusBarStyle: UIStatusBarStyle?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return themedStatusBarStyle ?? UIStatusBarStyle.lightContent
    }
    
    func updateStatusBar(){
        themedStatusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        getSchedule()
    }
    
    
    fileprivate func getSchedule(){

    }
    
    
    lazy var navigationView: UIView = {
        let view = UIView()
        view.backgroundColor =  UIColor.CustomColors.Black.background//UIColor.CustomColors.Green.register
        
        return view
    }()
    
    func setupTableView(){
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.separatorStyle = .none
        tableView.register(RegisteredEventTableViewCell.self, forCellReuseIdentifier: "cellId")
        view.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return registeredEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! RegisteredEventTableViewCell
        let regEvent = self.registeredEvents[indexPath.row]

//        guard let eventSchedule = self.scheduleDict?["\(regEvent.event)+\(regEvent.round)"] else {
//            print("failed here")
//            return cell
//        cell.schedule = eventSchedule
        if let event = eventsDictionary?[regEvent.eventID]{
            cell.eventName = event.name
        }
       
        cell.contentView.isUserInteractionEnabled = false
        cell.teamDetails = regEvent
        cell.registeredEventsViewController = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    


    func showLeaveTeam(Cell: UITableViewCell, teamDetails: TeamDetails){
        if let indexPath = tableView.indexPath(for: Cell){
            let indexValue = indexPath.row
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
                self.tableView.deselectRow(at: indexPath, animated: true)
            }
            leaveTeam(teamId: teamDetails.teamID,eventId:teamDetails.eventID, indexValue:indexValue)
        }
    }
    
    
    func leaveTeam(teamId: Int, eventId: Int, indexValue:Int){
        let actionSheet = UIAlertController(title: "Are you Sure?", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let sureAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            guard  let userId = self.user?.userID else {return}
            print("Team id:",teamId)
            print("Event id:",eventId)
            
            Networking.sharedInstance.leaveTeamForEventWith(userID: userId, teamID: teamId, eventID: eventId, successCompletion: { (message) in
                print(message)
                FloatingMessage().floatingMessage(Message: message, Color: .orange, onPresentation: {
                    Networking.sharedInstance.getStatusUpdate { (user) in
                        Caching.sharedInstance.saveUserDetailsToCache(user: user)
                    }
//                    self.registeredEvents.remove(at: indexValue)
                    self.tableView.reloadData()
                    self.navigationController?.popViewController(animated: true)
                }) {}
            }, errorCompletion: { (message) in
                FloatingMessage().floatingMessage(Message: message, Color: .red, onPresentation: {}) {}
            })
        }
        actionSheet.addAction(sureAction)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func showTeamDetails(Cell: UITableViewCell, teamDetails: TeamDetails, teamButton: LoadingButton){
//        let button
        Networking.sharedInstance.getTeamDetails(teamID: teamDetails.teamID) { (teamData) in
            self.teamMemberDetails = teamData
            teamButton.hideLoading()
            self.handleTeamDetailsTap(teamID: teamDetails.teamID , eventID: teamDetails.eventID)
        } errorCompletion: { (error) in
            FloatingMessage().floatingMessage(Message: "Decoder_error", Color: .red, onPresentation: {}) {}
//        })
            teamButton.hideLoading()
            print("Error in getting team details", teamDetails)
        }
    }
    
    
    func handleTeamDetailsTap(teamID: Int, eventID: Int){
        AudioServicesPlaySystemSound(1519)
        let teamTableViewController = TeamTableViewController()
//        let teamNav = MasterNavigationBarController(rootViewController: teamTableViewController)
        slideInTransitioningDelegate.categoryName = ""   //"\(event.description)"
        teamTableViewController.modalPresentationStyle = .custom
        teamTableViewController.transitioningDelegate = slideInTransitioningDelegate
        teamTableViewController.teamMemberDetails = self.teamMemberDetails
        teamTableViewController.teamID = teamID
        teamTableViewController.eventID = eventID
        present(teamTableViewController, animated: true, completion: nil)
    }
    
    
}

class RegisteredEventTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var eventName: String?
    var registeredEventsViewController: RegisteredEventsViewController?
    var teamDetails: TeamDetails?
    var schedule: Schedule?{
        didSet{
//            guard let event = registeredEvent else { return }
            guard let schedule = schedule else { return }
            print(schedule)
            tableView.reloadData()
        }
    }
    
    var eventDict = Caching.sharedInstance.getEventsDataDictionary()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if schedule == nil{
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! RegisteredEventCell
        
        var textLabel = "N/A"
        var detailedTextLabel = "N/A"
        var imageName = "calendar"
//        let formatter = DateFormatter()
        
//        let category = categoriesDictionary[event.category]
        
        cell.selectionStyle = .none
        switch indexPath.row {
        case 0:
            textLabel = "Team ID"
            imageName = "group"
            detailedTextLabel = "\(teamDetails?.teamID ?? 0)"
            break
        case 1:
            textLabel = "Category"
            let event = eventDict?[teamDetails?.eventID ?? 0]
            detailedTextLabel = ""
            imageName = "timer"
            break
        case 2:
            textLabel = "Mode"
            let event = eventDict?[teamDetails?.eventID ?? 0]
            detailedTextLabel = event?.mode ?? ""
            imageName = "location"
            break
      
        default:
            textLabel = "Team Size"
            cell.selectionStyle = .gray
        }
//        cell.imageView?.image = UIImage(named: imageName)
//        cell.imageView?.setImageColor(color: .white)
        cell.textLabel?.text = textLabel
        cell.detailTextLabel?.text = detailedTextLabel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
//    let teamDetailsButton = LoadingButton(type: .system)
    
    
    lazy var teamDetailsButton : LoadingButton = {
        let button = LoadingButton(type: .system)
        button.backgroundColor = UIColor.CustomColors.Theme.themeColor
        button.setTitle("Team Details", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        if (UIViewController().isSmalliPhone()){
           button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        }else{
           button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        }
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showTeamDetails), for: .touchUpInside)
//        return teamDetailsButton
        return button
    }()
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.CustomColors.Black.card
        
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = eventName
       
        let button2 = UIButton()
        button2.backgroundColor = #colorLiteral(red: 0.7536286485, green: 0.1785056603, blue: 0.07220073951, alpha: 1)
        button2.setTitle("Leave Team", for: UIControl.State())
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.startAnimatingPressActions()
        button2.layer.cornerRadius = 10
        button2.setTitleColor(.white, for: UIControl.State())
        button2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button2.layer.cornerRadius = 10
        button2.addTarget(self, action: #selector(leaveTeam), for: .touchUpInside)
        
        view.addSubview(label)
        _ = label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 25)
        
        
        view.addSubview(teamDetailsButton)
        _ = teamDetailsButton.anchor(top: label.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 8, leftConstant: 16, bottomConstant: 8, rightConstant: 0, widthConstant: frame.width/2 - 40, heightConstant: 0)
        
        view.addSubview(button2)
        _ = button2.anchor(top: label.bottomAnchor, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 8, rightConstant: 16, widthConstant: frame.width/2 - 40, heightConstant: 0)
        
        return view
    }
    
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.clipsToBounds = true
        tv.layer.masksToBounds = true
        tv.register(RegisteredEventCell.self, forCellReuseIdentifier: "cellId")
        tv.backgroundColor = UIColor.CustomColors.Black.card
        tv.separatorStyle = .none
        tv.layer.cornerRadius = 10
        tv.allowsSelection = false
        return tv
    }()
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 95
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.cardBackground.backgroundColor = selected ? UIColor.CustomColors.Black.background : UIColor.CustomColors.Black.card
        self.backgroundColor = .clear
//        self.lineSeperator.backgroundColor = selected ? UIColor.CustomColors.Green.accent : UIColor.CustomColors.Green.accent
    }
    
    lazy var cardBackground : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.CustomColors.Black.card
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectedBackgroundView = UIView()
        
        setupLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout(){
        addSubview(cardBackground)
        _ = cardBackground.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 8, rightConstant: 16, widthConstant: 0, heightConstant: 270)
        cardBackground.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    @objc func showTeamDetails(){
        guard let teamDetails = teamDetails else {return}
        self.teamDetailsButton.showLoading()
        teamDetailsButton.activityIndicator.tintColor = .white
        self.registeredEventsViewController?.showTeamDetails(Cell: self, teamDetails: teamDetails, teamButton: teamDetailsButton)
//        self.teamDetailsButton.hideLoading()
    }
    
    
    @objc func leaveTeam(){
        guard let teamDetails = teamDetails else {return}
        self.registeredEventsViewController?.showLeaveTeam(Cell: self, teamDetails: teamDetails)
    }
}


class RegisteredEventCell: UITableViewCell{
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        textLabel?.textColor = UIColor.init(white: 1, alpha: 0.8)
        textLabel?.font = UIFont.systemFont(ofSize: 14)
        detailTextLabel?.textColor = .white
        detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        detailTextLabel?.numberOfLines = 0
        textLabel?.numberOfLines = 0
        imageView?.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

