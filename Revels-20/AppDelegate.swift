//
//  AppDelegate.swift
//
//  Created by Naman Jain on 25/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit
import Disk
import BLTNBoard
import Firebase
import FirebaseMessaging
import UserNotifications
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?
    
    var resetPasswordToken: String?
    var resetPasswordUrl: String?
    
    lazy var bulletinManager: BLTNItemManager = {
        return BLTNItemManager(rootItem: makePasswordTextFieldPage())
    }()
    
    let gcmMessageIDKey = "com.tushartapadia"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        checkTokenForExpiry()
        getEvents()
//        getSchedule()
        getCategories()
//        getNewsletterURL()
        getColleges()
        getDelegateCards()
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = LaunchViewController()
        
        FirebaseConfiguration.shared.setLoggerLevel(FirebaseLoggerLevel.min)
        FirebaseApp.configure()
        
        
//        Messaging.messaging().delegate = self
//        application.registerForRemoteNotifications()
//        UNUserNotificationCenter.current().delegate = self
//        requestNotificationAuthorization(application: application)
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()

        Messaging.messaging().delegate = self
        
        StoreKitHelper.incrementNumberOfTImesLaunched()
        StoreKitHelper.displayRequestRatings()
        
        return true
    }

    // MARK: - Data Functions
    
    
    func getNewsletterURL(){
        Revels.Networking.sharedInstance.getNewsLetterUrl(dataCompletion: { (url) in
            UserDefaults.standard.set(url, forKey: "newletterurl")
            UserDefaults.standard.synchronize()
            print(url)
        }) { (error) in
            print(error)
        }
    }
    
    fileprivate func getEvents(){
        var eventsDictionary = [Int:Event]()
        var tags = [String]()
    //MARK: 1
        tags.append("All")
      //  var eventsDictionary = [Int: Event]()
   
        print("Before Data")
            Networking.sharedInstance.getEvents (dataCompletion: { (data) in
                for event in data{
                        let eventID = event.eventID
                                        eventsDictionary[eventID] = event
                                        if let guardedTags = event.tags{
                                        let uncapitalizedArray = guardedTags.map { $0.lowercased()}
                //                            print(event.name)
                //                            print(event.eventID)
                //                            event.tags = uncapitalizedArray
                                            for tag in uncapitalizedArray{
                                                if !tags.contains(tag){
                                                    tags.append(tag)
                                                }
                                            }
                                        }
                                    }

                print(tags)
                
                Caching.sharedInstance.saveEventsToCache(events: data)
                Caching.sharedInstance.saveEventsDictionaryToCache(eventsDictionary: eventsDictionary)
                Caching.sharedInstance.saveTagsToCache(tags: tags)
//                print("tags", tags)
             }) { (errorMessage) in
                print("Event fetch problem(App Delegate):",errorMessage)
            }
    }

    fileprivate func getDelegateCards(){
        var delegateCardsDictionary = [String: DelegateCard]()
        guard let tok = UserDefaults.standard.string(forKey: "token") else {return}
        let headers: HTTPHeaders = [
            "authorization":tok
        ]
        Networking.sharedInstance.getData(url: delegateCardsURL,headers:headers, decode: DelegateCard(), dataCompletion: { (data) in
            for card in data{
                delegateCardsDictionary[card._id] = card
            }
            Caching.sharedInstance.saveDelegateCardsToCache(cards: data)
            Caching.sharedInstance.saveDelegateCardsDictionaryToCache(dict: delegateCardsDictionary)
        }) { (errorMessage) in
            print("FFFs")
            print(errorMessage)
        }
    }
    
    fileprivate func checkTokenForExpiry(){
        Networking.sharedInstance.checkTokenExpiry { res in
            print("ye hai res: ",res)
            if(!res){
                print("invalid token, logging user off")
                UserDefaults.standard.removeObject(forKey: "token")
                UserDefaults.standard.setIsLoggedIn(value: false)
                UserDefaults.standard.synchronize()
                print("is logged in? ",UserDefaults.standard.isLoggedIn())
                let lvc = UsersViewController()
                lvc.setupViewForLoggedOutUser()
                
            }else{
                print("token is valid")
            }
        } errorCompletion: { err in
            print("error in check token:", err)

        }
    }
        
    
    
    fileprivate func getColleges(){
        var collegeDict = [Int:College]()
        Networking.sharedInstance.getColleges { Data in
            for i in 0...(Data.count-1) {
                collegeDict[i+1] = Data[i]
            }
            Caching.sharedInstance.saveCollegesToCache(collegeDictionary: collegeDict)
        } errorCompletion: { ErrorMessage in
            print(ErrorMessage)
        }

    }
    
    fileprivate func getSchedule(){
        var schedule = [ScheduleDays]()
        Revels.Networking.sharedInstance.getScheduleData { (data) in
            schedule = data
            Caching.sharedInstance.saveSchedulesToCache(schedule: data)
//            print(data)
        } errorCompletion: { (error) in
            print("Getting Schedule error in Appdelegate:",error)
        }

    }
    
    fileprivate func getCategories() {
        var categoriesDictionary = [String: Category]()
        Revels.Networking.sharedInstance.getCategories(dataCompletion: { (data) in
//            print("Category data:", data)
            for category in data {
                    categoriesDictionary[category.category] = category
            }
            self.saveCategoriesDictionaryToCache(categoriesDictionary: categoriesDictionary)
        }) { (errorMessage) in
            print("Category fetch problem(App Delegate):",errorMessage)
        }
    }
    
    func saveCategoriesDictionaryToCache(categoriesDictionary: [String: Category]) {
        do {
            try Disk.save(categoriesDictionary, to: .caches, as: categoriesDictionaryCache)
        }
        catch let error {
            print("Category cache problem (App delegate):",error)
        }
    }

}

// MARK: Cloud messaging delegate
extension AppDelegate: MessagingDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      print("Firebase registration token: \(String(describing: fcmToken))")

      let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      completionHandler(UIBackgroundFetchResult.newData)
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print full message.
    print(userInfo)

    completionHandler()
  }
}


