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
        if indexPath.section == 0{
            cell.nameLbl.text = "Instagram"
            cell.bgImageView.image = UIImage(named: "instagram")
        }
        else if indexPath.section == 1{
            cell.nameLbl.text = "Twitter"
            cell.bgImageView.image = UIImage(named: "twitter")
        }
        else if indexPath.section == 2{
            cell.nameLbl.text = "Youtube"
            cell.bgImageView.image = UIImage(named: "youtube")

        }
        return cell
    }
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.collectionView?.isUserInteractionEnabled = true
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .yellow
        cv.showsHorizontalScrollIndicator = false
        cv.register(SocialCollectionViewCell.self, forCellWithReuseIdentifier: "CellID")
        return cv
    }()
    
    
    
    func setupLayout(){
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
        
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
    
        ])
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setupLayout()
        

        // Do any additional setup after loading the view.
    }

}
