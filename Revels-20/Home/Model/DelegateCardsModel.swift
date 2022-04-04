//
//  DelegateCardsModel.swift
//  TechTetva-19
//
//  Created by Naman Jain on 30/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

struct DelegateCard: Codable {
    let _id: String
    let name: String
    let cardID: String
    let description: String
    let mitPrice: Int
    let nonMahePrice: Int
    let isActive: Bool
    let type: String
    init() {
        _id = ""
        name = ""
        description = ""
        mitPrice = 0
        nonMahePrice = 0
        isActive = false
        type = ""
        cardID = ""
    }
}

struct BlogData: Codable{
    let success:Bool?
    let msg:String?
    let data: [Blog]?
}

struct Blog: Codable{
    let author: String?
    let content: String?
//    let id: Int
    let image: String?
//    let timestamp: String
}


struct BoughtDelegateCard: Codable {
    var success: Bool
    var msg: String
    var data: [CardTypeStruct]
}

struct CardTypeStruct: Codable{
    var card_type: Int
}
