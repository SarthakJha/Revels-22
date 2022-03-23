//
//  SocialController.swift
//  Revels-20
//
//  Created by Rohit Kuber on 27/09/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
private let instaCellID = "instaCellID"
private let youtubeCellID = "youtubeCellID"
private let twitterCellID = "twitterCellID"

class SocialController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var fromYoutube :Bool = false
    var fromInsta : Bool = true
    var fromTwitter : Bool = false
    
    
    lazy var instaButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "instagram"), for: .normal)
        if UIViewController().isSmalliPhone(){
            button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        }else{
            button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        button.backgroundColor = .white
        button.startAnimatingPressActions()
        button.tag = 0
        button.addTarget(self, action: #selector(handleSocial(button:)), for: .touchUpInside)
        button.layer.cornerRadius = 12
        return button
    }()
    
    lazy var youtubeButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "youtube"), for: .normal)
        if UIViewController().isSmalliPhone(){
            button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        }else{
            button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        button.backgroundColor = .white
        button.startAnimatingPressActions()
        button.tag = 2
        button.addTarget(self, action: #selector(handleSocial(button:)), for: .touchUpInside)
        button.layer.cornerRadius = 12
        return button
    }()
    
    lazy var twitterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "twitter"), for: .normal)
        if UIViewController().isSmalliPhone(){
            button.imageEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        }else{
            button.imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        button.backgroundColor = .white
        button.startAnimatingPressActions()
        button.tag = 1
        button.addTarget(self, action: #selector(handleSocial(button:)), for: .touchUpInside)
        button.layer.cornerRadius = 12
        return button
    }()
    
    
    @objc func handleSocial(button: UIButton){
        switch button.tag {
        case 0:
            fromYoutube = false
            fromTwitter = false
            fromInsta = true
            self.collectionView.reloadData()
            break
        case 1:
            fromInsta = false
            fromYoutube = false
            fromTwitter = true
            self.collectionView.reloadData()
            break
        case 2:
            fromTwitter = false
            fromInsta = false
            fromYoutube = true
            self.collectionView.reloadData()
            break
            
        default:
            fromInsta = true
            break
        }
    }
    //MARK: -LifeCycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupCollectionView()
        print(view.frame.height)
    }
    
    func setupCollectionView(){
        collectionView.backgroundColor = .black
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.register(InstagramCollectionView.self, forCellWithReuseIdentifier: instaCellID)
        self.collectionView.register(YoutubeCollectionView.self, forCellWithReuseIdentifier: youtubeCellID)
        self.collectionView.register(TwitterCollectionView.self, forCellWithReuseIdentifier: twitterCellID)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        collectionView.isScrollEnabled = false
        collectionView!.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    func setupNavigationBar(){
        let titleLabel = UILabel()
        titleLabel.text = "Social"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    

    //MARK: -UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if fromInsta{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: instaCellID, for: indexPath) as! InstagramCollectionView
            return cell
        }
        else if fromTwitter{
            //
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: twitterCellID, for: indexPath) as!
            TwitterCollectionView
            return cell
            
        }else if fromYoutube{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: youtubeCellID, for: indexPath) as! YoutubeCollectionView
            return cell
        }
        else{
            return UICollectionViewCell()
        }

    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return .init(width: view.frame.width-32, height: collectionView.frame.height-54)
    }
    //MARK: - ViewController Accessory views
    
    
    lazy var containerView : UIView = {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIViewController().view.frame.width-32, height: UIViewController().view.frame.height/7)
        
        let wid = UIViewController().view.frame.width
        let dim = (wid-96)/5
        
        let containerSubView = UIView()
        containerSubView.backgroundColor = UIColor.darkGray
        containerSubView.layer.cornerRadius = 16
        containerSubView.isUserInteractionEnabled = true
        
        view.addSubview(containerSubView)
        
        _ = containerSubView.anchor(top: view.topAnchor , left: view.leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: UIViewController().view.frame.width/6, bottomConstant: 0, rightConstant: 0, widthConstant: UIViewController().view.frame.width*(2/3), heightConstant: dim+20)

        containerSubView.addSubview(instaButton)
        containerSubView.addSubview(twitterButton)
        containerSubView.addSubview(youtubeButton)

        _ = instaButton.anchor(top: containerSubView.topAnchor, left: containerSubView.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 10, bottomConstant: 0, rightConstant: 0, widthConstant: dim, heightConstant: dim)


        _ = twitterButton.anchor(top: containerSubView.topAnchor, left:instaButton.rightAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 32, bottomConstant: 0, rightConstant: 0, widthConstant: dim, heightConstant: dim)

        _ = youtubeButton.anchor(top: containerSubView.topAnchor, left: twitterButton.rightAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 32 , bottomConstant: 0, rightConstant: 0, widthConstant: dim, heightConstant: dim)
        
        
        view.backgroundColor = .black
        return view
    }()

    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
}
