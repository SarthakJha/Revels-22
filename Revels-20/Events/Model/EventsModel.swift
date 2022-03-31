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
    let eventID: Int
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

    init() {
        id = "0"
        eventID = 0
        category = Cat()
        tags = [""]
        name = ""
        eventType = ""
        mode = ""
        description = ""
        minMembers = 0
        maxMembers = 0
        isActive = false
        teamDelegateCard = false
        prize = ""
        eventVenue = ""
        eventHeads = [EventHead(_id: "", name: "", phoneNo: 1234567890, email: "")]
       
    }
}

struct Cat: Codable {
    var category:String
    var categoryID:String
    let decription:String
    let type : String
    
    init(){
        category = ""
        categoryID = ""
        decription = ""
        type = ""
    }
}
