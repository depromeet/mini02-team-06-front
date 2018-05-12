//
//  TimeLineModel.swift
//  storygram
//
//  Created by 이광용 on 2018. 5. 8..
//  Copyright © 2018년 gwangyonglee. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TimeLineModel {
    var contents: String
    var createdAt: String
    var id: Int
    var likeCount: Int
    var sadCount: Int
    var warmCount: Int
    var storyLineJobId: Int
    var wantContinueCount: Int
    
    init(dictionary: [String : Any]) {
        let json = JSON(dictionary)
        contents = json["contents"].stringValue
        createdAt = json["createdAt"].stringValue
        id = json["id"].intValue
        likeCount = json["likeCount"].intValue
        sadCount = json["sadCount"].intValue
        warmCount = json["warmCount"].intValue
        storyLineJobId = json["storyLineJobId"].intValue
        wantContinueCount = json["wantContinueCount"].intValue
    }
}
