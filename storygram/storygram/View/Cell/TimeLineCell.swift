//
//  TimeLineCell.swift
//  storygram
//
//  Created by 이광용 on 2018. 5. 7..
//  Copyright © 2018년 gwangyonglee. All rights reserved.
//

import UIKit

class TimeLineCell: UITableViewCell {
    // MARK: IBOutlets
    // 스토리 레이블
    @IBOutlet var storyContentsLabel: UILabel!
    
    // 스토리 넘버 레이블
    @IBOutlet var storyNumberLabel: UILabel!
    
    // 이모지 버튼
    @IBOutlet var emoji1Button: UIButton!
    @IBOutlet var emoji2Button: UIButton!
    @IBOutlet var emoji3Button: UIButton!
    @IBOutlet var emoji4Button: UIButton!
    
    // 이모지 카운트 레이블
    @IBOutlet var emoji1CountLabel: UILabel!
    @IBOutlet var emoji2CountLabel: UILabel!
    @IBOutlet var emoji3CountLabel: UILabel!
    @IBOutlet var emoji4CountLabel: UILabel!
}
