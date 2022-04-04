//
//  UserModel.swift
//  TechTetva-19
//
//  Created by Naman Jain on 27/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit

struct UserResponse: Codable {
    let success: Bool
    let msg: String?
    let data : User?
}

struct User: Codable{
//    let timestamp: String
    let branch:String?
    let verified:String?
    let regEvents:[Int]?
    let teamList:[Int]? // this
    let userID: Int?
    let name: String
    let token: String
    let passwordResetToken: String?
    let email: String
    let mobileNumber: Int64?
    let college: String?
    let isMahe: Int?
    let driveLink: String?
    let __v:Int
    let teamDetails:[TeamDetails]?
    let qr: String?
}

struct TeamDetails:Codable{
    let eventID:Int
    let teamID: String
}
