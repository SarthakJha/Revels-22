//
//  YoutubeModel.swift
//  Revels-20
//
//  Created by Rohit Kuber on 27/09/20.
//  Copyright © 2020 Naman Jain. All rights reserved.
//

import Foundation

struct Youtube: Codable {
    var count: Int
    var data: [DataYT]
}

struct DataYT: Codable {
    var title: String //description label
    var time: String //durationlabel
    var view:String//views
    var link: String // yeet
    var thumbnail: String // thumbnailImageView
}


