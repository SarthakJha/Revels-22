//
//  RegisteredTeamResponse.swift
//  Revels-20
//
//  Created by Rohit Kuber on 29/10/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import Foundation

struct CreateTeamResponse:Codable{
    let success: Bool
    let msg: String
    let data: CreateTeam?
}

struct CreateTeam:Codable{
    let timeStamp: String
    let members: [Int]?
    let _id: String
    let teamID: Int
    let eventName: String
    let minMembers: Int?
    let partyCode: String
    let maxMembers : Int?
    let leader: Int
    let __v: Int
}
