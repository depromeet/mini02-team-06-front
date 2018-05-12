//
//  APIConnector.swift
//  storygram
//
//  Created by 이광용 on 2018. 5. 7..
//  Copyright © 2018년 gwangyonglee. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIConnector {
    static let sharedManager = APIConnector()
    
    typealias StoryLinesCountResultCompletion = (Int?) -> Void
    func requestStoryLinesCount(completion: @escaping StoryLinesCountResultCompletion) {
        Alamofire.request("\(STORYGRAM_API_URL)/api/storylines/count", method: .get).responseJSON { response in
            
            guard response.result.isSuccess else {
                completion(nil)
                return
            }
            
            guard let result = response.result.value as? [String: Any] else {
                completion(nil)
                return
            }
            
            let json = JSON(result)
            let count = json["count"].intValue
            completion(count)
        }
    }

    typealias StoryLinesResultCompletion = ([TimeLineModel]?) -> Void
    func requestAllStoryLines(completion: @escaping StoryLinesResultCompletion) {
        Alamofire.request("\(STORYGRAM_API_URL)/api/storylines", method: .get).responseJSON { response in
            
            guard response.result.isSuccess else {
                completion(nil)
                return
            }

            guard let result = response.result.value as? [[String: Any]] else {
                completion(nil)
                return
            }
            
            let item = result.compactMap { TimeLineModel(dictionary: $0) }
            completion(item)
        }
    }
    
    typealias JSONCompletion = (JSON) -> Void
    func InsertStoryLine(content: String, completion: @escaping JSONCompletion) {
        let params = ["content" : content]
        
        Alamofire.request("\(STORYGRAM_API_URL)/api/storylines/candidates", method: .post, parameters: params, encoding: JSONEncoding.default).responseJSON { response in
            
            guard response.result.isSuccess else {
                completion(JSON.null)
                return
            }
            
            guard let result = response.result.value as? [String: Any] else {
                completion(JSON.null)
                return
            }
            
            completion(JSON(result))
        }
    }
    
    func requestCandidateStoryLines(completion: @escaping StoryLinesResultCompletion) {
        Alamofire.request("\(STORYGRAM_API_URL)/api/storylines/candidates", method: .get).responseJSON { response in
            
            guard response.result.isSuccess else {
                completion(nil)
                return
            }
            
            guard let result = response.result.value as? [[String: Any]] else {
                completion(nil)
                return
            }
            
            let item = result.compactMap { TimeLineModel(dictionary: $0) }
            completion(item)
        }
    }
    
    typealias CandidateEmojiInreaseCompletion = (JSON?) -> Void
    func requestCandidateEmojiIncrease(id: Int, emojiType: String, completion: @escaping CandidateEmojiInreaseCompletion) {
        Alamofire.request("\(STORYGRAM_API_URL)/api/storylines/candidates/\(id)/\(emojiType)", method: .get).responseJSON { response in
            guard response.result.isSuccess else {
                completion(nil)
                return
            }
            
            guard let result = response.result.value as? [String: Any] else {
                completion(nil)
                return
            }
            
            completion(JSON(result))
        }
    }
    
    typealias StoryLinesLatestResultComletion = (String?) -> Void
    func requestStoryLinesLatest(completion: @escaping StoryLinesLatestResultComletion) {
        Alamofire.request("\(STORYGRAM_API_URL)/api/storylines/latest", method: .get).responseJSON { response in
            
            guard response.result.isSuccess else {
                completion(nil)
                return
            }
            
            guard let result = response.result.value as? [String: Any] else {
                completion(nil)
                return
            }
            
            let json = JSON(result)
            let content = json["contents"].stringValue
            completion(content)
        }
    }
}
