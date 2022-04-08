//
//  ResultsViewController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 26/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Disk

class ResultsViewController: UICollectionViewController {

    
    //MARK: - Properties
    
    fileprivate let reuseIdentifier = "reuseIdentifier"
    var isSearching = false

    var eventsDictionary = [Int: Event]()
    
    var eventsWithResults = [Event](){
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
       
    
    let slideInTransitioningDelegate = SlideInPresentationManager(from: UIViewController(), to: UIViewController())
        
    
    
    
    var filteredEventsWithResults = [Event]()
    
    var filteredEvents: [Event]?
    
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let popUp = SpinnerPopUp()
    var isEmpty = false
    
    
    //MARK: - Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupView()
        setupCollectionView()
        setupSearchBar()
        refreshResults()
        getEvents()
        
    }
    
    var startTime : TimeInterval?
    
    override func viewDidAppear(_ animated: Bool) {
        if let time = startTime{
            let time1 = Date(timeIntervalSince1970: time)
            let time2 = Date()
            let difference = Calendar.current.dateComponents([.second], from: time1, to: time2)
            let duration = difference.second
            if duration ?? 0 > 600{
                self.refreshResults()
                self.startTime = Date().timeIntervalSince1970
            }
        }else{
            startTime = Date().timeIntervalSince1970
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.eventsWithResults = Caching.sharedInstance.getEventsFromCache()
        self.filteredEventsWithResults = Caching.sharedInstance.getEventsFromCache()
        self.filteredEvents = Caching.sharedInstance.getEventsFromCache()
        if let eventsDict = Caching.sharedInstance.getEventsDataDictionary(){
            self.eventsDictionary = eventsDict
        }
    }
    
    
    //MARK: - Layout Setup Functions
    
    fileprivate func setupNavigationBar(){
        let titleLabel = UILabel()
        titleLabel.text = "Events"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.sizeToFit()
        let leftItem = UIBarButtonItem(customView: titleLabel)
        self.navigationItem.leftBarButtonItem = leftItem
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshResults))
    }
    
    
    fileprivate func setupView(){
        view.backgroundColor = UIColor.CustomColors.Black.background
    }
    
    fileprivate func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.CustomColors.Black.background
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.register(ResultsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        collectionView.register(NoResultsCell.self, forCellWithReuseIdentifier: "NoResultsCell")
        collectionView.isUserInteractionEnabled = true
        collectionView.isScrollEnabled = true
    }
    
    fileprivate func setupSearchBar(){
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Events"
        searchController.searchBar.searchBarStyle = .default
        searchController.searchBar.sizeToFit()
        searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField
        searchController.searchBar.barStyle = UIBarStyle.black
        textFieldInsideSearchBar?.textColor = .white
        searchController.searchBar.tintColor = UIColor.CustomColors.Theme.themeColor
        
        definesPresentationContext = true
    }
    
    
    // MARK: - Data Functions
    
    @objc func refreshResults(){
//        self.eventsDictionary = [:]
        self.eventsWithResults = []
//        self.filteredEventsWithResults = []
        collectionView.reloadData()
//        collectionView.addSubview(popUp)
//        view.addSubview(popUp)
//        UIApplication.shared.keyWindow?.addSubview(popUp)
        getCachedEventResult()
    }
    
    func getCachedEventResult(){
        self.eventsWithResults  = Caching.sharedInstance.getEventsFromCache()
            self.getEvents()
                DispatchQueue.main.async {
                    self.popUp.hideSpinner()
                    self.collectionView.reloadData()
                }
            }
        
    
    
    fileprivate func getEvents(){
        Networking.sharedInstance.getEvents { (data) in
            self.eventsWithResults = data
            Caching.sharedInstance.saveEventsToCache(events: data)
            DispatchQueue.main.async {
                self.popUp.hideSpinner()
                self.collectionView.reloadData()
            }
        } errorCompletion: { (errorMessage) in
            print("Error getting results",errorMessage)
        }
    }
    
    
    //MARK: - Selector Handlers
}

extension ResultsViewController: UISearchResultsUpdating {
    
    @objc func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    @objc func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        
//        filteredEventsWithResults = []
        
//        if searchText == ""{
//            filteredEventsWithResults = eventsWithResults
//        }
//        else{
//        for event in eventsWithResults {
//            if(event.name.lowercased().contains(searchText.lowercased())){
//                filteredEventsWithResults.append(event)
//            }
//        }
        
        filteredEventsWithResults = eventsWithResults.filter({ (event: Event) -> Bool in
            return event.name.lowercased().contains(searchText.lowercased())
        })
        
        filteredEvents =  eventsWithResults.filter({ (event: Event) -> Bool in
            return event.name.lowercased().contains(searchText.lowercased())
        })
        
        collectionView.reloadData()
        
//        self.collectionView.reloadData()
        }
    
    
    
    @objc func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}


extension ResultsViewController: UICollectionViewDelegateFlowLayout{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return isFiltering() ? filteredEventsWithResults.count : eventsWithResults.count
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isEmpty{
            return .init(width: view.frame.width, height: 300)
        }
        var width : CGFloat = 0
        if isSmalliPhone(){
            width = (view.frame.width - 32) / 2
        }else{
            width = (view.frame.width - 48) / 3
        }
        return .init(width: width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ResultsCell
//        if  let selectedEventID = isFiltering() ? filteredEventsWithResults[indexPath.item].eventID: eventsWithResults[indexPath.item].eventID{
////            print(selectedEventID)
//        cell.event = eventsDictionary[selectedEventID]
//        }
        let selectedEventID = isFiltering() ? filteredEventsWithResults[indexPath.item].eventID: eventsWithResults[indexPath.item].eventID
        cell.event = eventsDictionary[selectedEventID]
        print("Selected Event ID: \(eventsDictionary[selectedEventID]?.name)")
        cell.eventNameLabel.text = eventsDictionary[selectedEventID]!.name
        return cell
}
    //MARK: Did Select Item At
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let resultsDetailViewController = ResultsDetailViewController(collectionViewLayout: UICollectionViewFlowLayout())
////        if let selectedEventID = isFiltering() ? filteredEventsWithResults[indexPath.item].eventID: eventsWithResults[indexPath.item].eventID{
////            print(selectedEventID)
////            guard let selectedEvent = eventsDictionary[selectedEventID] else {return}
////            resultsDetailViewController.event = selectedEvent
////            resultsDetailViewController.firstRoundResults = selectedEvent.round1
////            resultsDetailViewController.secondRoundResults = selectedEvent.round2
////            resultsDetailViewController.thirdRoundResults = selectedEvent.round3
////        }
//        let selectedEventID = isFiltering() ? filteredEventsWithResults[indexPath.item].eventID: eventsWithResults[indexPath.item].eventID
//        print(selectedEventID)
     //   guard let selectedEvent = eventsDictionary[selectedEventID] else {return}

        //navigationController?.pushViewController(resultsDetailViewController, animated: true)
        
        print("indexPath.row:\(indexPath.row)")
        let event = filteredEventsWithResults[indexPath.row]
        self.handleEventTap(withEvent: event)
        
        
        
        
    }
    
   
    
    func handleEventTap(withEvent event: Event){
       // AudioServicesPlaySystemSound(1519)
        let eventViewController = EventsViewController()
        slideInTransitioningDelegate.categoryName = ""
        //"\(event.description)"
        eventViewController.modalPresentationStyle = .custom
        eventViewController.transitioningDelegate = slideInTransitioningDelegate
        eventViewController.event = event
        eventViewController.schedule = nil
        eventViewController.resultsViewControoller = self
        eventViewController.fromTags = true
        present(eventViewController, animated: true, completion: nil)
//        print(event.eventID)
//        print(event.name)
    }
    
}


class SpinnerPopUp: UIView {
    
    var constant : Int?
    
    lazy var spinnerView : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .white)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.frame = UIScreen.main.bounds
        addSubview(spinnerView)
        spinnerView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -128).isActive = true
        spinnerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        spinnerView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        spinnerView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        spinnerView.startAnimating()
    }
    
    @objc func hideSpinner(){
        self.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
