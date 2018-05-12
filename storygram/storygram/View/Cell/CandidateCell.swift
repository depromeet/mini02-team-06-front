//
//  CandidateCell.swift
//  storygram
//
//  Created by 이광용 on 2018. 5. 9..
//  Copyright © 2018년 gwangyonglee. All rights reserved.
//

import UIKit

// MARK: Protocol
protocol CandidateCellDelegate: class {
    func candidateCellTouchUpInEmoji1(_ sender: CandidateCell)
    func candidateCellTouchUpInEmoji2(_ sender: CandidateCell)
    func candidateCellTouchUpInEmoji3(_ sender: CandidateCell)
    func candidateCellTouchUpInEmoji4(_ sender: CandidateCell)
}

class CandidateCell: UITableViewCell {
    // MARK: IBOutlets
    // 스토리 레이블
    @IBOutlet var storyContentsLabel: UILabel!
    
    // 스토리 넘버 옆 라인
    @IBOutlet var smallBarView: UIView!
    
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
    
    // MARK: Properties
    weak var delegate: CandidateCellDelegate?
    
    // MARK: IBActions
    @IBAction func touchUpInEmoji1(_ sender: UIButton) {
        delegate?.candidateCellTouchUpInEmoji1(self)
    }
    
    @IBAction func touchUpInEmoji2(_ sender: UIButton) {
        delegate?.candidateCellTouchUpInEmoji2(self)
    }
    
    @IBAction func touchUpInEmoji3(_ sender: UIButton) {
        delegate?.candidateCellTouchUpInEmoji3(self)
    }
    
    @IBAction func touchUpInEmoji4(_ sender: UIButton) {
        delegate?.candidateCellTouchUpInEmoji4(self)
    }
}
