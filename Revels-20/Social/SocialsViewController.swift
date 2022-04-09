//
//  SocialsViewController.swift
//  Revels-20
//
//  Created by Tushar Elangovan on 08/04/22.
//  Copyright © 2022 Naman Jain. All rights reserved.
//

import UIKit

class SocialsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellID", for: indexPath) as! SocialCollectionViewCell
        if indexPath.row == 0{
            cell.nameLbl.text = "@revelsmit"
            cell.bgImageView.image = UIImage(named: "instagram")
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.setupLayout()
            
//            cell.bgView.backgroundColor = Colors.gl
        }
        if indexPath.row == 1{
            cell.nameLbl.text = "@RevelsMIT"
            cell.bgImageView.image = UIImage(named: "twitter")
            cell.setupLayout()
        }
        if indexPath.row == 2{
            cell.nameLbl.text = "REVELS,MIT MANIPAL"
            cell.bgImageView.image = UIImage(named: "youtube")
            cell.setupLayout()
        }
       
       // cell.backgroundColor = .red
        return cell
    }
    
    func setupView(){
      //  self.navigationController!.navigationBar.topItem!.title = "Back"

        let titleLabel = UILabel()
        titleLabel.text = "Socials"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
//        let leftItem = UIBarButtonItem(customView: titleLabel)
//        self.navigationItem.leftBarButtonItem = leftItem
        setupLayout()
    }
    
    private var themedStatusBarStyle: UIStatusBarStyle?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return themedStatusBarStyle ?? UIStatusBarStyle.lightContent
    }
    
    func updateStatusBar(){
        themedStatusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.collectionView?.isUserInteractionEnabled = true
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.register(SocialCollectionViewCell.self, forCellWithReuseIdentifier: "CellID")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Cell Selected")
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width , height: view.frame.height)
//    }
    
    func setupLayout(){
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
        
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
    
        ])
    }
    
    @objc func swipeBack(){
        let HVC = HomeViewController()
        self.navigationController?.pushViewController(HVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  view.backgroundColor = .green
      //  setupLayout()
        navigationController?.isNavigationBarHidden = false
        setupView()
        
//        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeBack))
//        gesture.direction = .left
//        view.addGestureRecognizer(gesture)
        
       // self.navigationController?.view.backgroundColor = UIColor.white

    }
    
}

extension SocialsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height/4)
    }
}
