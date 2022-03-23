//
//  UserModel.swift
//  TechTetva-19
//
//  Created by Naman Jain on 27/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

struct UserResponse: Decodable {
    let success: Bool
    let msg: String?
    let data : User?
}

struct User: Codable{
    let timeStamp: String
    let branch:String?
    let verified:String?
    let regEvents:[Int]?
    let teamList:[Int]?
    let userID: Int?
    let name: String
    let email: String
    let phoneNo: Int64?
    let college: String?
    let state: String
    let isMahe: Bool?
    let driveLink: String?
    let __v:Int
    let teamDetails:[TeamDetails]?
}

struct TeamDetails:Codable{
    let eventID:Int
    let teamID: Int
}
