//
//  StateTableViewController.swift
//  Revels-20
//
//  Created by Rohit Kuber on 27/10/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit

protocol StateSelected {
    func stateSelected(state: String)
}

class StateTableViewController: UITableViewController {
    fileprivate let cellid = "cellID"
    
    var stateDelegate: StateSelected? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(stateTableViewCell.self, forCellReuseIdentifier: cellid)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func configureNavigationBar(){
        navigationItem.title = "Choose from below"
        self.navigationController?.navigationBar.tintColor =  UIColor.CustomColors.Theme.themeColor
        let button1 = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(Close))
        self.navigationItem.rightBarButtonItem  = button1
        self.navigationItem.rightBarButtonItem?.title = "Close"
    }
    
    @objc func Close(){
        self.dismiss(animated: true, completion: nil)
    }
    
    var stateList: [String] = ["Andhra Pradesh","Arunachal Pradesh","Assam",
                               "Bihar",
                               "Chhattisgarh",
                               "Goa","Gujarat",
                               "Haryana","Himachal Pradesh",
                               "Jharkhand",
                               "Karnataka","Kerala",
                               "Madhya Pradesh","Maharashtra","Manipur","Meghalaya","Mizoram",
                               "Nagaland",
                               "Odisha",
                               "Punjab",
                               "Rajasthan",
                               "Sikkim",
                               "Tamil Nadu","Telangana","Tripura",
                               "Uttar Pradesh","Uttarakhand",
                               "West Bengal","Others"]
    
    var utList:[String] =    ["Andaman and Nicobar",
                              "Chandigarh",
                              "Delhi",
                              "Jammu and Kashmir",
                              "Ladakh","Lakshwadeep",
                              "Puducherry",
                              "Dadar and Nagar Haveli and Daman and Diu"]
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black
        let label = UILabel()
        if(section==0){
        label.text = "Union Territories"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(label)
        label.fillSuperview(padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        }else{
            label.text = "States"
            label.textColor = .white
            label.textAlignment = .left
            label.font = UIFont.boldSystemFont(ofSize: 20)
            view.addSubview(label)
            label.fillSuperview(padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        }
        return view
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section==0) {
            return utList.count }
        return stateList.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! stateTableViewCell
        
        if(indexPath.section==0){
            cell.textLabel?.text = utList[indexPath.row]
        }else{
            cell.textLabel?.text = stateList[indexPath.row]
        }
       
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section==0){
        stateDelegate?.stateSelected(state: utList[indexPath.row])
        }else{
        stateDelegate?.stateSelected(state: stateList[indexPath.row])
        }
    }
}



class stateTableViewCell: UITableViewCell{
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        self.textLabel?.textColor = .lightGray
        self.textLabel?.numberOfLines = 0
        self.textLabel?.lineBreakMode = .byWordWrapping
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
