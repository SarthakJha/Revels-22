//
//  EventsModel.swift
//  TechTetva-19
//
//  Created by Naman Jain on 26/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

struct EventsResponse: Codable{
    let success: Bool
    let data: [Event]?
}

struct Event: Codable{

    let id: String
    let category: Cat
    let name: String
    let eventType: String
    let mode: String
    let description: String
    let minMembers: Int
    let maxMembers: Int
    let tags: [String]?
    let isActive: Bool
    let teamDelegateCard: Bool
    let prize: String
    let eventVenue: String
    let eventHeads: [EventHead]

    struct Cat: Codable {
        let category:String
        let categoryID:String
        let decription:String
        let type : String
    }
//    init() {
//        id = 0
//        category = 0
//        name = ""
//        description=""
//        maxMembers=0
//        minMembers = 0
//
//        tags = []
//        isActive=false
//    }

}


