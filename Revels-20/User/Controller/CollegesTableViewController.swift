//
//  CollegesTableViewController.swift
//  Revels-20
//
//  Created by sarthak jha on 05/04/22.
//  Copyright © 2022 Naman Jain. All rights reserved.
//

import UIKit

class CollegesTableViewController: UITableViewController {
    
    var collegeDelegate:collegeSelected? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(collegeTableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.register(noCollegeTableViewCell.self, forCellReuseIdentifier: "cellID2")
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.tableFooterView = UIView()
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        

    }
    
    var colleges = [String]()

    
    //MARK: -Set Up Colleges
    func setupColleges(){
        let collegeDetails = Caching.sharedInstance.getCollegesFromCache()
        //var name = [String]()
        for i in 0...(collegeDetails.count-1){
            colleges.append(collegeDetails[i+1]?.name ?? "Other Colleges")
            colleges.sort()
         
        }
        print("College Names: \(colleges)")
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return colleges.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if colleges.count == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID2", for: indexPath) as! noCollegeTableViewCell
            tableView.allowsSelection = false
            tableView.separatorStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! collegeTableViewCell
            cell.textLabel?.text = colleges[indexPath.row]
            return cell
        }
    }
 
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black
        let label = UILabel()
        label.text =  "All Colleges"
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(label)
        label.fillSuperview(padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))

        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        collegeDelegate?.collegeTapped(name: colleges[indexPath.row])
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    

}
