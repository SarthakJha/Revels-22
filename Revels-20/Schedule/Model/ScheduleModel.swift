//
//  ScheduleModel.swift
//  TechTetva-19
//
//  Created by Naman Jain on 26/08/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//
    
struct ScheduleResponse: Codable{
    let data: [ScheduleDays]?
}

struct ScheduleDays: Codable{
    let day1: [Schedule]?
    let day2: [Schedule]?
    let day3: [Schedule]?
    let day4: [Schedule]?
}


struct Schedule: Codable{
    let eventName: String
    let eventID: String
    let category: String
    let round: String
    let time: String
    let location: String
    let day:Int
}
