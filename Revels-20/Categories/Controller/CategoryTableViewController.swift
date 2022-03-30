//
//  CategoriesCollectionViewController.swift
//  TechTatva-19
//
//  Created by Vedant Jain on 05/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Disk
import AudioToolbox

protocol DayTableViewCellProtocol {
    func didTapEvent( day: Int, event:Int)
}

class CategoriesTableViewController: UITableViewController, DayTableViewCellProtocol {
    
    
    func didTapEvent(day: Int, event: Int) {
        print(day, event)
    }
    
    //MARK: - Init
    
    fileprivate let cellId = "cellId"
    
    var categoriesDictionary = [String: Category]()
    
    var popUp = SpinnerPopUp()
    
    var categories: [Category]?{
        didSet{
            self.categories = self.categories!.sorted(by: { (ca1, ca2) -> Bool in
                ca1.name < ca2.name
            })
            self.popUp.hideSpinner()
            tableView.reloadData()
        }
    }
    
//    var detailsLauncher = DetailsLauncher()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        setupView()
    }
    
    fileprivate func setupTableView() {
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setupView(){
        let titleLabel = UILabel()
        titleLabel.text = "Categories"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
//        let leftItem = UIBarButtonItem(customView: titleLabel)
//        self.navigationItem.leftBarButtonItem = leftItem
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private var themedStatusBarStyle: UIStatusBarStyle?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return themedStatusBarStyle ?? UIStatusBarStyle.lightContent
    }
    
    func updateStatusBar(){
        themedStatusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }
    
    //MARK: - TableView Functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return 10
      //  return categories?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CategoryTableViewCell
        let category = categories?[indexPath.row]
        cell.titleLabel.text = "Catewgory Name"
        cell.descriptionLabel.text = "Description"
//        cell.titleLabel.text = category?.name
//        cell.descriptionLabel.text = category?.description
        return cell
    }
    // Open details popup view
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let categoryName = categories?[indexPath.row].name{
            print(categoryName)
        showSchedule(category: categoryName)
        tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    let slideInTransitioningDelegate = SlideInPresentationManager(from: UIViewController(), to: UIViewController())
    
    func showSchedule(category : String){
        AudioServicesPlaySystemSound(1519)
        let scheduleController = ScheduleController(collectionViewLayout: UICollectionViewFlowLayout())
        scheduleController.categoryID = category
        slideInTransitioningDelegate.categoryName = category
        scheduleController.fromCategory = true
        scheduleController.modalPresentationStyle = .custom
        scheduleController.transitioningDelegate = slideInTransitioningDelegate
        present(scheduleController, animated: true, completion: nil)
    }
    
    //MARK: - Data Functions
    
    func getData(){
        view.addSubview(popUp)
        self.getCachedCategoriesDictionary()
    }
    
    func getCachedCategoriesDictionary(){
        do{
            let retrievedCategoriesDictionary = try Disk.retrieve(categoriesDictionaryCache, from: .caches, as: [String: Category].self)
            self.categories = Array(retrievedCategoriesDictionary.values)
            self.categoriesDictionary = retrievedCategoriesDictionary
        }
        catch let error{
            getCategories()
            print("Category Cache error:", error)
        }
    }
    
    fileprivate func getCategories() {
        var categoriesDictionary = [String: Category]()
        Networking.sharedInstance.getCategories(dataCompletion: { (data) in
            for category in data {
                    categoriesDictionary[category.name] = category
                
            }
            self.saveCategoriesDictionaryToCache(categoriesDictionary: categoriesDictionary)
    }) { (errorMessage) in
            print(errorMessage)
        }
    }

    
    func saveCategoriesDictionaryToCache(categoriesDictionary: [String: Category]) {
        do {
            try Disk.save(categoriesDictionary, to: .caches, as: categoriesDictionaryCache)
            self.categories = Array(categoriesDictionary.values)
            self.categoriesDictionary = categoriesDictionary
        }
        catch let error {
            print(error)
        }
    }
    
}


