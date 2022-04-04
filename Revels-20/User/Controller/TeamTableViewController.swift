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

protocol TeamDelegate {
    func removeMember(memberInfo: MemberInfo)
}


class TeamTableViewController: UITableViewController {
    
    var event: [Event]! {
        didSet{
            tableView.reloadData()
            
        }
    }
    
    
    var regEventViewCell: RegisteredEventTableViewCell?
    
    var teamID: String?
    var eventID: Int?
    var teamMemberDetails: TeamMemberDetails?{
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
            Caching.sharedInstance.saveUserDetailsToCache(user: userStatusUpdate)
        }
    }
    
    var eventsDictionary:[Int:Event]?{
        didSet{
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.register(TeamCell.self, forCellReuseIdentifier: "cellId")
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        getCachedUserDetails()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.regEventViewCell?.teamDetailsButton.hideLoading()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.regEventViewCell?.teamDetailsButton.hideLoading()
    }
    
    
    func getCachedUserDetails(){
        self.user =  Caching.sharedInstance.getUserDetailsFromCache()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let memberArray = teamMemberDetails?.members{
            let memberCount = memberArray.count
            return memberCount
        }else{
         return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! TeamCell
        cell.contentView.isUserInteractionEnabled = false
        cell.backgroundColor = UIColor.CustomColors.Black.background
        if let memberArray = teamMemberDetails?.members{
             let memberInfo = memberArray[indexPath.row][0]
             cell.memberInfo = memberInfo
            }
        cell.teamDelegate = self
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.CustomColors.Black.background
       
        
//        guard let partyCode = teamMemberDetails.partyCode else{return}
    
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "Team Details"
        
        let partyCodeLabel = UILabel()
        partyCodeLabel.textColor = .white
        partyCodeLabel.font = UIFont.systemFont(ofSize: 16)
        partyCodeLabel.textAlignment = .center
        partyCodeLabel.numberOfLines = 2
        partyCodeLabel.text = "Party Code"
        
        let partyCodeValue = UILabel()
        partyCodeValue.textColor = .red
        partyCodeValue.font = UIFont.systemFont(ofSize: 16)
        partyCodeValue.textAlignment = .center
        partyCodeValue.numberOfLines = 2
        partyCodeValue.text = "N/A"
        
        
        if let partyVal = teamMemberDetails?.partyCode{
            partyCodeValue.text = partyVal
        }
            
        
        if isSmalliPhone(){
            label.font = UIFont.boldSystemFont(ofSize: 15)
            partyCodeLabel.font = UIFont.systemFont(ofSize: 12)
        }else{
            label.font = UIFont.boldSystemFont(ofSize: 18)
        }
        
            view.addSubview(label)
            _ = label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 25)

            view.addSubview(partyCodeLabel)
           _ = partyCodeLabel.anchor(top: label.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 8, leftConstant: 32, bottomConstant: 8, rightConstant: 0,widthConstant: UIViewController().view.frame.width/2-40)

            view.addSubview(partyCodeValue)
        _ = partyCodeValue.anchor(top: label.bottomAnchor, left: partyCodeLabel.rightAnchor, bottom: view.bottomAnchor, right: nil, topConstant: 8, leftConstant: 16, bottomConstant: 8, rightConstant: 0,widthConstant: UIViewController().view.frame.width/2-40)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 95
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72 //60
    }
        
}

extension TeamTableViewController: TeamDelegate{
    func removeMember(memberInfo: MemberInfo) {
        let actionSheet = UIAlertController(title: "Are you sure?", message: "The following member would be removed from your team", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let sureAction = UIAlertAction(title: "Yes", style: .destructive) { (_) in
            guard let teamId = self.teamID else {return}
            guard let userId = self.user?.userID else {return }
            guard let eventId = self.eventID else {return}
            guard let removeId = memberInfo.userID else {return}
            
            Networking.sharedInstance.removeTeammate(userID: userId, teamID: teamId, eventID: eventId, removeID: removeId,successCompletion:  { (message) in
                print(message)
                FloatingMessage().floatingMessage(Message: message, Color: .orange, onPresentation: {
                    self.navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true, completion: nil)
                }) {}
            }, errorCompletion: { (message) in
                FloatingMessage().floatingMessage(Message: message, Color: .red, onPresentation: {}) {}
            })
        }
        actionSheet.addAction(sureAction)
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
}



class TeamCell: UITableViewCell{
    
    var teamDelegate: TeamDelegate?
   
    var memberInfo: MemberInfo?{
        didSet{
            guard let memberInfo = self.memberInfo else {return}
            DispatchQueue.main.async{
                self.memberID.text = "User id:\(memberInfo.userID ?? 0)"
                print(memberInfo.id)
            self.nameLabel.text = memberInfo.name
            
        }
    }
}
    
    lazy var memberID: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray
        if(UIViewController().isSmalliPhone()){
        label.font = UIFont.boldSystemFont(ofSize: 13)
        }else{
            label.font = UIFont.boldSystemFont(ofSize: 15)
        }
        label.textAlignment = .left
        label.text = "Member id:"
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        if(UIViewController().isSmalliPhone()){
        label.font = UIFont.boldSystemFont(ofSize: 15)
        }else{
            label.font = UIFont.boldSystemFont(ofSize: 17)
        }
        label.textAlignment = .left
        label.text = "Name"
        return label
    }()
    
    lazy var removeButton : UIButton = {
        let button2 = UIButton()
        button2.backgroundColor = #colorLiteral(red: 0.7536286485, green: 0.1785056603, blue: 0.07220073951, alpha: 1)
        button2.setTitle("Remove", for: UIControl.State())
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.startAnimatingPressActions()
        button2.layer.cornerRadius = 10
        button2.setTitleColor(.white, for: UIControl.State())
        button2.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button2.layer.cornerRadius = 10
        button2.addTarget(self, action: #selector(removeMember), for: .touchUpInside)
        return button2
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       setupLayout()
    }
    
    func setupLayout(){
        
        addSubview(nameLabel)
        _ = _ = nameLabel.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: frame.width/2 - 20, heightConstant: 0)
        
        addSubview(memberID)
        _ = memberID.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant:0, leftConstant: 16, bottomConstant: 20, rightConstant: 0, widthConstant: frame.width/2 - 20, heightConstant: 0)
        
        addSubview(removeButton)
        _ = removeButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 16, widthConstant: frame.width/2 - 20, heightConstant: 36)
        
    }
    
    
    @objc func removeMember(){
        guard let memberData = memberInfo else {return}
        self.teamDelegate?.removeMember(memberInfo: memberData)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


