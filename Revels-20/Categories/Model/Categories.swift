//
//  Categories.swift
//  TechTetva-19
//
//  Created by Vedant Jain on 26/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

struct CategoriesResponse: Codable {
    let data: [Category]?
}

struct Category: Codable {
    let type: String
    let name: String
    let description: String?
    let categoryId: String
}

struct CCInfo : Codable{
    let name: String
    let phoneNo: UInt64?
}
