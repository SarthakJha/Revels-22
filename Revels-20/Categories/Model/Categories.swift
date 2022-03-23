//
//  Categories.swift
//  TechTetva-19
//
//  Created by Vedant Jain on 26/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

struct CategoriesResponse: Codable {
    let success: Bool
    let data: [Category]?
}

struct Category: Codable {
    let tags: [String]
    let name: String
    let  cc : [CCInfo]?
    let description: String?
}

struct CCInfo : Codable{
    let name: String
    let phoneNo: UInt64?
}
