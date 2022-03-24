//
//  YoutubeCollectionView.swift
//  Revels-20
//
//  Created by Rohit Kuber on 27/09/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import UIKit
import Disk
import SDWebImage

class YoutubeCollectionView: UICollectionViewCell,UITableViewDelegate,UITableViewDataSource{
                             //,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
        
        private let cellId = "cellID"
        var youData = [DataYT]()
        
    private let refreshControl = UIRefreshControl()
    
    lazy var titleBackgroundText: UILabel = {
           let label = UILabel()
           label.text = "Youtube"
           label.font = UIFont.systemFont(ofSize: 80, weight: .bold)
           label.textColor = UIColor(white: 0.4, alpha: 0.3)
           label.textAlignment = .center
           return label
       }()
        
        lazy var titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Revels-22"
            label.font = UIFont.boldSystemFont(ofSize: 22)
            label.textColor = UIColor(white: 1, alpha: 0.7)
            label.textAlignment = .center
            label.textColor = .white
            return label
        }()
        
        lazy var youtubeCollectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
//            layout.scrollDirection = .vertical
            let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
//            cv.delegate = self
//            cv.dataSource = self
//            cv.isUserInteractionEnabled = true
//            cv.register(YoutubeCell.self, forCellWithReuseIdentifier: cellId)
            return cv
        }()
    
    lazy var youtubeTableView : UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.isUserInteractionEnabled = true
        tv.separatorStyle = .none
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tv.register(YoutubeTableViewCell.self, forCellReuseIdentifier: cellId)
        tv.refreshControl = self.refreshControl
        tv.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        return tv
    }()
        
        lazy var seperatorLineView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            return view
        }()
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //      return youtubeCache.count
            return youData.count
        }
    
    
    //TableViewdelegate Functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return youData.count
    }
    
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! YoutubeCell
//            cell.layer.cornerRadius = 10
            let data = youData[indexPath.item]
            cell.backgroundColor = .black
            let dataVal = data.thumbnail.split(separator: "?")
            cell.thumbnailImageView.sd_setImage(with: URL(string: String(dataVal[0])), placeholderImage: UIImage(named: "logo.png"))
            cell.descriptionlabel.text = data.title
//            cell.durationLabel.text = data.time
            return cell
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! YoutubeTableViewCell
//            cell.layer.cornerRadius = 10
        let data = youData[indexPath.item]
        cell.backgroundColor = .black
        let dataVal = data.thumbnail.split(separator: "?")
        cell.thumbnailImageView.sd_setImage(with: URL(string: String(dataVal[0])), placeholderImage: UIImage(named: "logobg1.png"))
        cell.descriptionlabel.text = data.title
        return cell
    }
        

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = youData[indexPath.item]
        let url = data.link
        let webURL = NSURL(string: url)!
        let application = UIApplication.shared
        application.open(webURL as URL)
    }
    
        
    override init(frame: CGRect) {
                super.init(frame: frame)
                if #available(iOS 13.0, *) {
                    youtubeTableView.backgroundColor = .black
        
    //            }
    //            Networking.sharedInstance.getYoutubeData { (data) in
    //                print("YT data recieved----------------------------\n")
    //                print(data)
    //                print("\n\n")
    //
                }
                //youtubeCollectionView.refreshControl = UIRefreshControl()
                //youtubeCollectionView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
                
                getYouData()
                setupLayout()
                self.youData = self.getYoutubeItemsFromCache() ?? []
            }
        
        @objc private func pullToRefresh(){
            self.youData = []
            getYouData()
            self.youData = self.getYoutubeItemsFromCache() ?? []
            
            DispatchQueue.main.async {
                self.youtubeTableView.refreshControl?.endRefreshing()
                self.youtubeTableView.reloadData()
            }
        }
    
    
        fileprivate func setupLayout(){
            addSubview(titleBackgroundText)
            _ = titleBackgroundText.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 2, leftConstant: -32, bottomConstant: 0, rightConstant: -32, widthConstant: 0, heightConstant: 0)
            
            
            addSubview(titleLabel)
            _ = titleLabel.anchor(top: titleBackgroundText.topAnchor, left: leftAnchor, bottom: titleBackgroundText.bottomAnchor, right: rightAnchor, topConstant: 6, leftConstant: 16, bottomConstant: 0, rightConstant: 16, heightConstant: 0)
            
           
            addSubview(youtubeTableView)
            youtubeTableView.anchorWithConstants(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 2, leftConstant: 10, bottomConstant: 0, rightConstant: 4)
           
        }
    
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func getYouData(){
        print("Getting Youtube links")
        let urlString = "http://159.65.146.229:5000/youtube/TechTatva"
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
                    let youtubefeed = try decoder.decode(Youtube.self, from: data!)
//                    self.youData = youtubefeed.data
                    self.saveYoutubeToCache(data: youtubefeed.data)
                    print(self.youData)
                } catch{
                    print(error)
                    print("error in json parsing")
                }
                DispatchQueue.main.async {
                    self.youtubeTableView.reloadData()
                    //youtubeCollectionView.reloadData()
                }
                
            }
        }
        dataTask.resume()
    }
    
    func getYoutubeItemsFromCache() -> [DataYT]? {
        do{
            let retrievedData = try Disk.retrieve("youtube.json", from: .caches, as: [DataYT].self)
            print("saved to cache")
            return retrievedData
        }catch{
            return nil
        }
    }
    
    func saveYoutubeToCache(data: [DataYT]){
        do{
            try Disk.save(data, to: .caches, as: "youtube.json")
            print("retrieved from cache")
        }catch let error{
            print(error)
        }
    }
   
    }

    

