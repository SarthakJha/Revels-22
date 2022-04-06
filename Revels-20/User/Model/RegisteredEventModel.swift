
//
//  RegisteredEventModel.swift
//  TechTetva-19
//
//  Created by Naman Jain on 29/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

struct RegisteredEventsResponse: Codable {
    let success: Bool
    let data : [RegEvents]?
}

//struct RegEvent: Codable {
//    let regEvent:[RegisteredEvent]?
//}

struct RegEvents: Codable{
    let _id: String
    let teamID: String
    let event: RegEventData
}

struct EventHead : Codable{
    let _id: String
    let name:String
    let phoneNo: Int64?
    let email: String
}

struct RegEventData: Codable{

    let _id: String
    let eventID: Int
    let category: Category?
    let name: String
    let eventType: String
    let mode: String
    let description: String
    let minMembers: Int
    let maxMembers: Int
    let tags: [String]?
    let isActive: Bool
    let teamDelegateCard: Bool
    let prize: String?
    let eventHeads: [EventHead]
    let delegateCards: [String]?

    init() {
        _id = "0"
        eventID = 0
        category = Category(type: "", category: "", description: "", categoryId: "")
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
        eventHeads = [EventHead(_id: "", name: "", phoneNo: 1234567890, email: "")]
        delegateCards = [String()]
    }
}
