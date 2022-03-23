//
//  InstagramCollectionView.swift
//  Revels-20
//
//  Created by Rohit Kuber on 27/09/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit
import Disk
import SDWebImage

class InstagramCollectionView: UICollectionViewCell,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
   
    
    var instData = [Node]()
    let cellId = "cellId"
    let cellPadding : CGFloat = 16
    
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.text = "TechTatva'20"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor(white: 1, alpha: 0.7)
        label.textColor = .white
        return label
    }()
    
    lazy var titleBackgroundText: UILabel = {
        let label = UILabel()
        label.text = "Instagram"
        label.font = UIFont.systemFont(ofSize: 80, weight: .bold)
        label.textColor = UIColor(white: 0.4, alpha: 0.3)
        label.textAlignment = .center
        return label
       }()
    
    lazy var instagramCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .black
        cv.register(InstagramCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    lazy var seperatorLineView: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
            super.init(frame: frame)
    //        Networking.sharedInstance.getInstaPosts { (res) in
    ////            print("insta data recieved: ------------------------")
    ////            print(res)
    ////            print("\n\n")
    //        }
            
           getInstaData()
            setupLayout()
            self.instData = self.getInstagramItemsFromCache() ?? []
            
            instagramCollectionView.refreshControl = UIRefreshControl()
            instagramCollectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        }
        
        
        @objc private func pullToRefresh(){
            self.instData = []
            getInstaData()
            self.instData = self.getInstagramItemsFromCache() ?? []
            
            DispatchQueue.main.async {
                self.instagramCollectionView.refreshControl?.endRefreshing()
                self.instagramCollectionView.reloadData()
            }
        }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(instData.count)
        return instData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InstagramCell
        let data = instData[indexPath.item]
        print(data)
        print(data.node.display_url)
        cell.postImageView.sd_setImage(with: URL(string: data.node.display_url), placeholderImage: UIImage(named: "logobg1.png"))
//        cell.profilePhotoImageview = UIImageView(image: UIImage(named: "logobg1.png"))
        
        cell.likeLabel.text = String(data.node.edge_liked_by.count)
        cell.commentsLabel.text = String(data.node.edge_media_to_comment.count)
        cell.backgroundColor = .black
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: UIViewController().view.frame.width-48 , height: UIViewController().view.frame.height/2)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = instData[indexPath.item]
        let redirectLink = "https://www.instagram.com/p/\(data.node.shortcode)"
        let webURL = NSURL(string: redirectLink)!
        let application = UIApplication.shared
        application.open(webURL as URL)
    }
    
    fileprivate func setupLayout(){
        
        addSubview(titleBackgroundText)
        _ = titleBackgroundText.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant:2, leftConstant: -32, bottomConstant: 0, rightConstant: -32, widthConstant: 0, heightConstant: 0)
        
        
        addSubview(titleLabel)
        _ = titleLabel.anchor(top: titleBackgroundText.topAnchor, left: leftAnchor, bottom: titleBackgroundText.bottomAnchor, right: rightAnchor, topConstant: 6, leftConstant: 16, bottomConstant: 0, rightConstant: 16, heightConstant: 0)
      
    
       addSubview(instagramCollectionView)
       instagramCollectionView.anchorWithConstants(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 2, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        
    }
    
    func getInstaData() {
        print("Getting Insta links")
        let urlString = "http://159.65.146.229:5000/insta/mittechtatva"
        let url = URL(string: urlString)
        guard url != nil else {
            print("wrong url")
            return
        }
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            
            if error == nil && data != nil {
                let decoder = JSONDecoder()
                do{
                    let instafeed = try decoder.decode(entrydat.self, from: data!)
//                    self.instData = instafeed.edges
                    
                    let ins = instafeed.entry_data.ProfilePage[0].graphql.user.edge_owner_to_timeline_media.edges
                    self.saveInstagramToCache(data: ins)
//                    print(ins)
                } catch{
                    print(error)
                    print("error in json parsing")
                }
                DispatchQueue.main.async {
                    self.instagramCollectionView.reloadData()
                }
                
            }
        }
        dataTask.resume()
    }
    
    func getInstagramItemsFromCache() -> [Node]? {
        do{
            let retrievedData = try Disk.retrieve("instagram.json", from: .caches, as: [Node].self)
            print("saved to cache instagram")
            return retrievedData
        }catch{
            return nil
        }
    }
    
    func saveInstagramToCache(data: [Node]){
        do{
            try Disk.save(data, to: .caches, as: "instagram.json")
            print("retrieved from cache instagram")
        }catch let error{
            print(error)
        }
    }
    
    
}



    

