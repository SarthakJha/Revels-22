//
//  DeveloperViewController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 02/10/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Disk
import SDWebImage
import SafariServices

struct Developer {
    let name: String
    let domain: String
    let imageURL: String
    let post: String
    let instaURL: String
    let linkdinURL: String
}


/**

 */

class DeveloperViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
        
    fileprivate let cellID = "cellID"
    var homeViewController: HomeViewController?
    let developersData = [
            Developer(name: "Sarthak", domain: "iOS", imageURL: "https://i.ibb.co/4gK6pz2/Whats-App-Image-2020-11-02-at-6-51-41-PM.jpg", post: "Category Head", instaURL: "https://instagram.com/ssarthakj?igshid=10qkoxeniyrvm", linkdinURL: "http://linkedin.com/in/sarthak-jha-a665941a2"),
            Developer(name: "Tushar", domain: "iOS", imageURL: "https://i.ibb.co/JqwcRDY/Whats-App-Image-2020-10-28-at-10-40-28-AM.jpg", post: "Category Head", instaURL: "https://www.instagram.com/tushar_elangovan/", linkdinURL: "https://www.linkedin.com/in/tushar-elangovan-3622391a5/"),
//            Developer(name: "Pranshul", domain: "Android", imageURL: "https://i.ibb.co/rwc7dDc/Whats-App-Image-2020-11-02-at-6-24-06-PM.jpg", post: "Category Head", instaURL: "https://www.instagram.com/pranshul_2002/", linkdinURL: "https://www.linkedin.com/in/pranshul-goyal"),
//            Developer(name: "Prakhar", domain: "Android", imageURL: "https://i.ibb.co/s3HV8k9/HUP3975.jpg", post: "Category Head", instaURL: "https://instagram.com/prakhar_b10?igshid=YmMyMTA2M2Y=", linkdinURL: "https://www.prakharb10.com/"),
//            Developer(name: "Sanya", domain: "Android", imageURL: "https://i.ibb.co/8dVSnr5/Whats-App-Image-2020-11-02-at-6-46-23-PM.jpg", post: "Category Head", instaURL: "https://www.instagram.com/saannya_/", linkdinURL: "https://www.linkedin.com/in/sanya-gupta-5a2a06185/"),
            Developer(name: "Ankit Mishra", domain: "iOS", imageURL: "https://i.imgur.com/IH4W0HV.jpeg", post: "Organiser", instaURL: "https://www.instagram.com/i.am.ankit.mishra/", linkdinURL: "https://www.linkedin.com/in/ankit-mishra-2ba38a1b7/"),
            Developer(name: "Chitrala", domain: "iOS", imageURL: "https://i.ibb.co/hLgc6yt/IMG-2952.jpg", post: "Organiser", instaURL: "https://www.instagram.com/chitrala_dhruv/", linkdinURL: "https://www.linkedin.com/in/chitraladhruv/"),
//            Developer(name: "Kavya Goel", domain: "Android", imageURL: "https://i.imgur.com/mHX86LG.jpeg", post: "Organiser", instaURL: " https://www.instagram.com/kavya_goel/", linkdinURL: "https://www.linkedin.com/in/kavya-goel-7ba0aa202/"),
//            Developer(name: "Praveen", domain: "Android", imageURL: "https://i.ibb.co/mCjrYX3/res-pic.png", post: "Organiser", instaURL: "https://www.instagram.com/_praveenvarma_/", linkdinURL: "https://www.linkedin.com/in/praveen-varma-a4b27b1b5/"),
//            Developer(name: "Shikhar", domain: "Android", imageURL: "https://i.ibb.co/RNBFRsB/7617-B6-CB-137-F-4-CD7-B561-442-E1-F76-D425.jpg", post: "Organiser", instaURL: "https://www.instagram.com/shikharr_ag/", linkdinURL: "https://www.linkedin.com/in/shikhar-agarwal-98a239168/"),
//            Developer(name: "Divyansh", domain: "Android", imageURL: "https://avatars.githubusercontent.com/u/34028379", post: "Organiser", instaURL: "https://instagram.com/divvyansh.__", linkdinURL: "https://www.linkedin.com/in/divyanshkul/"),
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        updateStatusBar()
    }

    private var themedStatusBarStyle: UIStatusBarStyle?

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return themedStatusBarStyle ?? UIStatusBarStyle.lightContent
    }
    func updateStatusBar(){
        themedStatusBarStyle = .lightContent
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func setupView(){
        navigationItem.title = "Developers"
        collectionView.dataSource = self
        collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.CustomColors.Black.background
        self.collectionView.register(AboutCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    @objc func popViewController() {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return developersData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIViewController().isSmalliPhone(){
            return CGSize(width: (view.frame.width/2)-24, height: 294)
        }
        return CGSize(width: (view.frame.width/2)-24, height: 294)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! AboutCollectionViewCell
        cell.developerViewController = self
        let dev = developersData[indexPath.row]
        let url = NSURL(string: dev.imageURL)
        cell.imageView.sd_setImage(with: url! as URL, placeholderImage:nil)
        cell.titleLabel.text = dev.name
        cell.postLabel.text = dev.post
        cell.platformLabel.text = dev.domain
        return cell
    }
    
        func openInstragram(cell: UICollectionViewCell){
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        print(developersData[indexPath.item].name)
            guard let appURL = URL(string: developersData[indexPath.item].instaURL) else {return}
            let webURL = developersData[indexPath.item].instaURL
        let application = UIApplication.shared
            if application.canOpenURL(appURL) {
                application.open(appURL)
        }else{
            homeViewController?.openURL(url: webURL)
            }
    }
            
            
        func openLinkedIn(cell: UICollectionViewCell){
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        print(developersData[indexPath.item].name)
            guard let appURL = URL(string: developersData[indexPath.item].linkdinURL) else {return}
        let webURL = developersData[indexPath.item].linkdinURL
        let application = UIApplication.shared
        if application.canOpenURL(appURL) {
            application.open(appURL)
            }else{
                homeViewController?.openURL(url: webURL)
                }
    }
        func openURL(url: String){
            guard let url = URL(string: url) else { return }
        let svc = SFSafariViewController(url: url)
        svc.preferredBarTintColor = .black
        svc.preferredControlTintColor = .white
        present(svc, animated: true, completion: nil)
    }
}
    
class AboutCollectionViewCell: UICollectionViewCell {
    
    var developerViewController: DeveloperViewController?
    
    lazy var spinnerView : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
        
        let imageView: UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named: "placeholder")
            iv.contentMode = .scaleAspectFill
            iv.layer.masksToBounds = true
            iv.translatesAutoresizingMaskIntoConstraints = false
            iv.clipsToBounds = true
            return iv
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.font = UIFont.boldSystemFont(ofSize: 18)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            return label
        }()
        
        let postLabel: UILabel = {
            let label = UILabel()
            label.textColor = .lightGray
            label.font = UIFont.systemFont(ofSize: 15)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        let platformLabel: UILabel = {
            let label = UILabel()
            label.textColor = .gray
            label.font = UIFont.boldSystemFont(ofSize: 13)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
    lazy var instaButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "instagram"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = .white
        button.startAnimatingPressActions()
        button.tag = 1
        button.addTarget(self, action: #selector(clickedButton(button:)), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var facebookButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "linkedin"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = .white
        button.startAnimatingPressActions()
        button.tag = 0
        button.addTarget(self, action: #selector(clickedButton(button:)), for: .touchUpInside)
        button.layer.cornerRadius = 10
        return button
    }()
    
    @objc func clickedButton(button: UIButton){
        if button.tag == 0 {
            print("helo")
            developerViewController?.openLinkedIn(cell: self)
        }else{
            developerViewController?.openInstragram(cell: self)
        }
    }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupViews()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    
        func setupViews() {
            
            if UIViewController().isSmalliPhone(){
                facebookButton.layer.cornerRadius = 8
                instaButton.layer.cornerRadius = 8
                facebookButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                instaButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
            }
            
            addSubview(imageView)
            addSubview(titleLabel)
            addSubview(postLabel)
            addSubview(platformLabel)
            addSubview(instaButton)
            addSubview(facebookButton)
            imageView.addSubview(spinnerView)
            
            self.backgroundColor = UIColor.CustomColors.Black.card
            self.layer.masksToBounds = true
            self.layer.cornerRadius = 10
            
            let width = (frame.width - 80)/2
            
            imageView.layer.cornerRadius = (frame.width-64)/2
            _ = imageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 8, rightConstant: 32, widthConstant: frame.width-64, heightConstant: frame.width-64)
            _ = titleLabel.anchor(top: imageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 0, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            _ = postLabel.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 4, leftConstant: 16, bottomConstant: 6, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            _ = platformLabel.anchor(top: postLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 16, rightConstant: 16, widthConstant: 0, heightConstant: 0)
            _ = instaButton.anchor(top: platformLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 16, leftConstant: 32, bottomConstant: 16, rightConstant: 0, widthConstant: width-7, heightConstant: width-7)
            _ = facebookButton.anchor(top: platformLabel.bottomAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 16, rightConstant: 32, widthConstant: width-7, heightConstant: width-7)
            spinnerView.fillSuperview()
        }
}


