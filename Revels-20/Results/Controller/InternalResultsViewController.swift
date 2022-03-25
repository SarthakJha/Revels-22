//
//  InternalResultsViewController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 26/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

class ResultsDetailViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, MenuControllerDelegate  {
    
    var event: Event?{
        didSet{
            guard let event = event else { return }
            
            navigationItem.title = event.name
        }
    }
    
//    var results: [Result]?{
//        didSet{
//            guard let results = results else { return }
//            for result in results{
//                if result.round == 1{
//                    firstRoundResults.append(result)
//                }else if result.round == 2{
//                    secondRoundResults.append(result)
//                }else if result.round == 3{
//                    thirdRoundResults.append(result)
//                }
//            }
//            menuController.menuItems = ["Round 1"]
//            if secondRoundResults.count > 0{
//                menuController.menuItems.append("Round 2")
//            }
//            if thirdRoundResults.count > 0{
//                menuController.menuItems.append("Round 3")
//            }
//            print(results.count)
//        }
//
//    }
    
    var firstRoundResults = [String](){
        didSet{
            
        }
    }
    var secondRoundResults = [String](){
        didSet{
            
        }
        }
    
    var thirdRoundResults = [String]()
    
        
    
    
    
    func didTapMenuItem(indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    fileprivate let menuController = MenuController(collectionViewLayout: UICollectionViewFlowLayout())
    
    fileprivate let cellId = "cellId"
    fileprivate let menuCellId = "menuCellId"
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let offset = x / CGFloat(3)//menuController.menuItems.count)
        menuController.menuBar.transform = CGAffineTransform(translationX: offset, y: 0)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let item = x / view.frame.width
        let indexPath = IndexPath(item: Int(item), section: 0)
        menuController.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
        menuController.delegate = self
        menuController.markerBar.backgroundColor = UIColor.CustomColors.Theme.themeColor
        menuController.menuItems = ["Round 1","Round 2","Round 3"]
        menuController.specialColor = UIColor.CustomColors.Theme.themeColor
        menuController.menuBar.backgroundColor = UIColor.CustomColors.Black.background
        menuController.collectionView.backgroundColor = UIColor.CustomColors.Black.background
        menuController.shadowBar.backgroundColor = UIColor.CustomColors.Black.background
        setupLayout()
    }
    
    fileprivate func setupLayout() {
        let menuView = menuController.view!
        menuView.backgroundColor = .white
        view.addSubview(menuView)
        _ = menuView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        menuController.collectionView.selectItem(at: [0, 0], animated: true, scrollPosition: .centeredHorizontally)
        
        view.backgroundColor = .white
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
        }
        
        collectionView.backgroundColor = UIColor.CustomColors.Black.background
        collectionView.anchor(top: menuView.bottomAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        collectionView.register(DetailContactCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.isPagingEnabled = true
        collectionView.allowsSelection = true
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuController.menuItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DetailContactCell
        switch indexPath.item {
        case 0:
//            firstRoundResults.sort(by: { (res1, res2) -> Bool in
//                res1.position < res2.position
//            })
            cell.results = firstRoundResults
        case 1:
//            secondRoundResults.sort(by: { (res1, res2) -> Bool in
//                res1.position < res2.position
//            })
            cell.results = secondRoundResults ?? []
        case 2:
//            thirdRoundResults.sort(by: { (res1, res2) -> Bool in
//                res1.position < res2.position
//            })
            cell.results = thirdRoundResults ?? []
        default:
            cell.results = []
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: view.frame.height - 50)
    }
    
}

class DetailContactCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Properties
    
    var results = [String]()
    
    fileprivate let cellId = "cellId"
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Setup Functions
    
    fileprivate func setupTableView(){
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.register(PositionCell.self, forCellReuseIdentifier: cellId)
        tableView.register(NoResultsCell.self, forCellReuseIdentifier: "NoResultsCell")
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        tableView.allowsSelection = false
        
        addSubview(tableView)
        tableView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    // MARK: - TableView Functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(results.count==0){
            return 1
        }else{
        return results.count
    }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (results.count == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoResultsCell", for: indexPath) as! NoResultsCell
            return cell
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PositionCell
        cell.teamIdLabel.text = results[indexPath.row]
        cell.positionLabel.text = "\(indexPath.row+1)"
        cell.medalImageView.image = UIImage(named: "medal_\(indexPath.row+1)")
        return cell
        }
    }
    
}

class NoResultsCell: UITableViewCell{
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        if UIViewController().isSmalliPhone(){
            label.font = UIFont.boldSystemFont(ofSize: 20)
        }else{
           label.font = UIFont.boldSystemFont(ofSize: 25)
        }
        
        label.textColor = UIColor(white: 1, alpha: 0.3)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "The results have not been uploaded yet."
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - Setup Functions
    
    func setupLayout(){
        backgroundColor = .clear
        
        addSubview(titleLabel)
        titleLabel.anchorWithConstants(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 100, leftConstant: 16, bottomConstant: 0, rightConstant: 16)
    }
}

