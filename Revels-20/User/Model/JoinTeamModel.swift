//
//  JoinTeamModel.swift
//  Revels-20
//
//  Created by Rohit Kuber on 31/10/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import Foundation

struct JoinTeamResponse:Codable{
    let success: Bool
    let msg: String
    let teamID:Int?
}
