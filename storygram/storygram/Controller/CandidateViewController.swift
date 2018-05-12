//
//  CandidateViewController.swift
//  storygram
//
//  Created by 이광용 on 2018. 5. 9..
//  Copyright © 2018년 gwangyonglee. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class CandidateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CandidateCellDelegate, NVActivityIndicatorViewable {
    
    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var emptyView: UIView!
    @IBOutlet var contentInsertView: UIView!
    @IBOutlet var remainTimeLabel: UILabel!
    
    // MARK: Properties
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshDatas(_:)), for: .valueChanged)
        refreshControl.tintColor = .blue
        return refreshControl
    }()
    
    var timeLineItems: [TimeLineModel]?
    var timer: Timer?
    
    // MARK: Colors
    private let blueColor = UIColor(red:0.13, green:0.04, blue:0.89, alpha:1.0)
    private let grayColor = UIColor(red:0.62, green:0.62, blue:0.62, alpha:1.0)
    
    // MARK: ViewController Instance
    static func instance() -> CandidateViewController? {
        return UIStoryboard(name: STORYGRAM_CANDIDATE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: classNameToString) as? CandidateViewController
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.hidesBackButton = true
        
        self.contentInsertView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(contentInsert)))
        self.contentInsertView.layer.cornerRadius = 16
        self.contentInsertView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        self.tableView.addSubview(self.refreshControl)
        self.tableView.isHidden = true
        
        self.requestCandidateStoryLines()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.remainTimeLabel.isHidden = false
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer?.invalidate()
    }
    
    // MARK: Methods
    func requestCandidateStoryLines() {
        self.startAnimating(CGSize(width: 45, height: 45), type: .circleStrokeSpin)
        APIConnector.sharedManager.requestCandidateStoryLines { result -> (Void) in
            if let result = result {
                if result.count != 0 {
                    self.tableView.isHidden = false
                    self.emptyView.isHidden = true
                    self.timeLineItems = nil
                    self.timeLineItems = result
                    self.tableView.reloadData()
                }
                else {
                    self.tableView.isHidden = true
                    self.emptyView.isHidden = false
                }
            }
            self.stopAnimating()
        }
    }

    @objc func refreshDatas(_ refreshControl: UIRefreshControl) {
        self.requestCandidateStoryLines()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func updateTime() {
        let remainTime = AppDelegate.shared?.remainTime()
        if let remainTime = remainTime {
            self.remainTimeLabel.text = remainTime
        }
    }
    
    @objc func contentInsert() {
        if let viewController = WriteViewController.instance() {
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    // MARK: IBActions
    @IBAction func TimeLineViewPresentButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: TableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let timeLineItems = self.timeLineItems {
            return timeLineItems.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: STORYGRAM_CANDIDATE_CELLID, for: indexPath) as? CandidateCell else {
            let empty_cell = CandidateCell(style: .default, reuseIdentifier: STORYGRAM_CANDIDATE_CELLID)
            return empty_cell
        }
        
        if let timeLineItems = self.timeLineItems?[indexPath.row] {
            if indexPath.row < 3 {
                cell.smallBarView.backgroundColor = blueColor
                cell.storyNumberLabel.textColor = blueColor
                cell.storyNumberLabel.text = STORYGRAM_CANDIDATE_BEST
            }
            else {
                cell.smallBarView.backgroundColor = grayColor
                cell.storyNumberLabel.textColor = grayColor
                cell.storyNumberLabel.text = STORYGRAM_CANDIDATE_RELAY
            }
            
            cell.storyContentsLabel.text = timeLineItems.contents
            cell.emoji1CountLabel.text = "\(timeLineItems.likeCount)"
            cell.emoji2CountLabel.text = "\(timeLineItems.wantContinueCount)"
            cell.emoji3CountLabel.text = "\(timeLineItems.sadCount)"
            cell.emoji4CountLabel.text = "\(timeLineItems.warmCount)"
        }
        cell.delegate = self
        
        return cell
    }
    
    // candidateCellTouchUpInEmoji1 ~ 4 수정 필요
    func candidateCellTouchUpInEmoji1(_ sender: CandidateCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        
        if let timeLineItems = self.timeLineItems?[tappedIndexPath.row] {
            APIConnector.sharedManager.requestCandidateEmojiIncrease(id: timeLineItems.id, emojiType: "like") { result -> (Void) in
                self.startAnimating(CGSize(width: 45, height: 45), message: STORYGRAM_CANDIDATE_RELAY_MENT, type: .circleStrokeSpin)
                self.requestCandidateStoryLines()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.stopAnimating()
                }
            }
        }
    }
    
    func candidateCellTouchUpInEmoji2(_ sender: CandidateCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        
        if let timeLineItems = self.timeLineItems?[tappedIndexPath.row] {
            APIConnector.sharedManager.requestCandidateEmojiIncrease(id: timeLineItems.id, emojiType: "wantContinue") { result -> (Void) in
                // 결과 받아서 해당 인덱스 셀만 업데이트 해야함!!
                self.startAnimating(CGSize(width: 45, height: 45), message: STORYGRAM_CANDIDATE_RELAY_MENT, type: .circleStrokeSpin)
                self.requestCandidateStoryLines()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.stopAnimating()
                }
            }
        }
    }
    
    func candidateCellTouchUpInEmoji3(_ sender: CandidateCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        
        if let timeLineItems = self.timeLineItems?[tappedIndexPath.row] {
            APIConnector.sharedManager.requestCandidateEmojiIncrease(id: timeLineItems.id, emojiType: "sad") { result -> (Void) in
                self.startAnimating(CGSize(width: 45, height: 45), message: STORYGRAM_CANDIDATE_RELAY_MENT, type: .circleStrokeSpin)
                self.requestCandidateStoryLines()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.stopAnimating()
                }
            }
        }
    }
    
    func candidateCellTouchUpInEmoji4(_ sender: CandidateCell) {
        guard let tappedIndexPath = tableView.indexPath(for: sender) else { return }
        
        if let timeLineItems = self.timeLineItems?[tappedIndexPath.row] {
            APIConnector.sharedManager.requestCandidateEmojiIncrease(id: timeLineItems.id, emojiType: "warm") { result -> (Void) in
                self.startAnimating(CGSize(width: 45, height: 45), message: STORYGRAM_CANDIDATE_RELAY_MENT, type: .circleStrokeSpin)
                self.requestCandidateStoryLines()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.stopAnimating()
                }
            }
        }
    }
}
