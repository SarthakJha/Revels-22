//
//  DelegateCardsController.swift
//  Revels-20
//
//  Created by sarthak jha on 05/04/22.
//  Copyright © 2022 Naman Jain. All rights reserved.
//

import UIKit
import Alamofire
import Disk

class DelegateCardsController: UITableViewController {

    
    var boughtCards: [String]?{
        didSet{
            guard let cards = Cards else {
                print("stuck here")
                getBoughtDelegateCards()
                return
            }
            guard let boughtCards = boughtCards else {
                print("stuck here here")
                print("ye hai bought cards",boughtCards)
                return
            }
            
//            UserDefaults.standard.set(boughtCards.contains(58), forKey: "boughtProshow")
//            UserDefaults.standard.synchronize()
            
            BoughtCards = cards.filter({ (card) -> Bool in
                boughtCards.contains(card._id)
            })
            print("ye hai og", BoughtCards)
            ProShowCards = cards.filter({ (card) -> Bool in
                !boughtCards.contains(card._id) && card.type == "PROSHOW" && card.isActive == true
            })
            GeneralCards = cards.filter({ (card) -> Bool in
                !boughtCards.contains(card._id) && card.type == "GENERAL" && card.isActive == true
            })
            GamingCards = cards.filter({ (card) -> Bool in
                !boughtCards.contains(card._id) && card.type == "GAMING" && card.isActive == true
            })
            SportsCards = cards.filter({ (card) -> Bool in
                !boughtCards.contains(card._id) && card.type == "SPORTS" && card.isActive == true
            })
            CardsData = [self.BoughtCards,self.ProShowCards, self.GeneralCards,self.GamingCards, self.SportsCards]
//            tableView.reloadData()
            print("this is all the cards: ",CardsData)
            tableView.reloadSections(IndexSet(0..<1), with: .automatic)
//            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBoughtDelegateCards()
        setupView()
    }
    
    fileprivate func setupTableView() {
        tableView.register(DelegateCardTableViewCell.self, forCellReuseIdentifier: "cellId")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.CustomColors.Black.background
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.isUserInteractionEnabled = true
    
    }
    
    func setupView(){
        self.navigationItem.title = "Delegate Cards"
        setupTableView()
        getCachedCards()
    }
    
    var BoughtCards = [DelegateCard]()
    var GeneralCards = [DelegateCard]()
    var FeaturedCards = [DelegateCard]()
    var GamingCards = [DelegateCard]()
    var WorkshopCards = [DelegateCard]()
    var SportsCards = [DelegateCard]()
    var ProShowCards = [DelegateCard]()
    
    var CardsData = [[DelegateCard]]()
    var Titles = ["Bought Cards","Proshow Cards", "General Cards", "Gaming Cards", "Sports Cards"]
    
    var Cards : [DelegateCard]?
    
    func getCachedCards(){
        do{
            let retCards = try Disk.retrieve(delegateCardsCache, from: .caches, as: [DelegateCard].self)
            self.Cards = retCards
        }
        catch let error{
            var delegateCardsDictionary = [String: DelegateCard]()
            let tok = UserDefaults.standard.string(forKey: "token") ?? " "
            let headers: HTTPHeaders = [
                "authorization":tok
            ]
            Networking.sharedInstance.getData(url: delegateCardsURL,headers: headers, decode: DelegateCard(), dataCompletion: { (data) in
                self.Cards = data
                for card in data{
                        delegateCardsDictionary[card._id] = card
                }
                Caching.sharedInstance.saveDelegateCardsToCache(cards: data)
                Caching.sharedInstance.saveDelegateCardsDictionaryToCache(dict: delegateCardsDictionary)
            }) { (errorMessage) in
                print(error)
                print(errorMessage)
            }
        }
    }
    
    func getBoughtDelegateCards(){
        let tok = UserDefaults.standard.string(forKey: "token") ?? " "
        let headers: HTTPHeaders = [
            "authorization": tok
        ]
        let apiStruct = ApiStruct(url: boughtDelegateCardsURL, method: .get, body: nil,headers: headers)
        WSManager.shared.getJSONResponse(apiStruct: apiStruct, success: { (boughtCards: BoughtDelegateCard) in
            var cards = [String]()
            for card in boughtCards.data{
                cards.append(card._id)
            }
            print(cards)
            DispatchQueue.main.async {
                print("ye hai bought cards",cards)
                self.boughtCards = cards
            }
        }) { (error) in
           print(error)
            print("bought cards mai bt")
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CardsData.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.CardsData[indexPath.row].count == 0 ? 0 : isSmalliPhone() ? 250 : 300
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! DelegateCardTableViewCell
//        if indexPath.row == 0 {
//            cell.buyLabel.isHidden = true
//        }else{
//            cell.buyLabel.isHidden = false
//        }
        cell.titleLabel.text = self.Titles[indexPath.row]
        cell.Cards = self.CardsData[indexPath.row]
        cell.delegateCardsController = self
        //MARK: IMPORTANT
        cell.contentView.isUserInteractionEnabled = false
        cell.selectionStyle = .none
        return cell
    }
    
    func buyCard(id: String){
        if self.boughtCards?.contains(id) ?? false{
            FloatingMessage().longFloatingMessage(Message: "Card already bought!", Color: UIColor.CustomColors.Blue.register, onPresentation: {}) {
            }
            return
        }
        if UserDefaults.standard.isLoggedIn(){
            let popUp = SpinnerCardPopUp()
             UIApplication.shared.keyWindow?.addSubview(popUp)
             DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                 popUp.animateOut()
             }
//            let vc = PaymentsWebViewController()
//            vc.delegateCardID = id
//            vc.delegateCardsController = self
//            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            DispatchQueue.main.async(execute: {
                let alertController = UIAlertController(title: "Sign in to Buy Delegate Cards", message: "You need to be signed in to buy a Delegate Card.", preferredStyle: UIAlertController.Style.actionSheet)
                let logInAction = UIAlertAction(title: "Sign In", style: .default, handler: { (action) in
                    let login = LoginViewController()
                    let loginNav = MasterNavigationBarController(rootViewController: login)
                    if #available(iOS 13.0, *) {
                        loginNav.modalPresentationStyle = .fullScreen
                        loginNav.isModalInPresentation = true
                    } else {
                        // Fallback on earlier versions
                    }
                    fromLogin = true
                    self.present(loginNav, animated: true)
                })
                let createNewAccountAction = UIAlertAction(title: "Create New Account", style: .default, handler: { (action) in
                    let login = LoginViewController()
                    let loginNav = MasterNavigationBarController(rootViewController: login)
                    fromLogin = true
                    self.present(loginNav, animated: true, completion: {
                        login.handleRegister()
                    })
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(logInAction)
                alertController.addAction(createNewAccountAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            })
            return
        }
    }
    
    var delegateCardToBuy: Int?
    
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
}
