//
//  TimeLineViewController.swift
//  storygram
//
//  Created by 이광용 on 2018. 5. 7..
//  Copyright © 2018년 gwangyonglee. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class TimeLineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {

    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var contentInsertView: UIView!
    @IBOutlet var remainTimeLabel: UILabel!
    
    // MARK: Properties
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshDatas(_:)), for: .valueChanged)
        refreshControl.tintColor = .blue
        return refreshControl
    }()
    
    // Private
    var timeLineItem: [TimeLineModel]?
    var timer: Timer?
    
    // MARK: ViewController Instance
    static func instance() -> TimeLineViewController? {
        return UIStoryboard(name: STORYGRAM_TIMELINE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: classNameToString) as? TimeLineViewController
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        self.contentInsertView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(contentInsert)))
        self.contentInsertView.layer.cornerRadius = 16
        self.contentInsertView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        self.tableView.addSubview(self.refreshControl)
        
        self.requestAllStoryLines()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
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
    func requestAllStoryLines() {
        self.startAnimating(CGSize(width: 45, height: 45), type: .circleStrokeSpin)
        APIConnector.sharedManager.requestAllStoryLines { result -> (Void) in
            self.timeLineItem = nil
            self.timeLineItem = result
            self.tableView.reloadData()
            self.stopAnimating()
        }
    }
    
    @objc func refreshDatas(_ refreshControl: UIRefreshControl) {
        self.requestAllStoryLines()
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
    
    // MARK: TableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let timeLineItem = self.timeLineItem {
            return timeLineItem.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: STORYGRAM_TIMELINE_CELLID, for: indexPath) as? TimeLineCell else {
            let empty_cell = TimeLineCell(style: .default, reuseIdentifier: STORYGRAM_TIMELINE_CELLID)
            return empty_cell
        }
        
        if let timeLineItem = self.timeLineItem?[indexPath.row] {
            cell.storyContentsLabel.text = timeLineItem.contents
            cell.storyNumberLabel.text = "\(indexPath.row+1)"
            cell.emoji1CountLabel.text = "\(timeLineItem.likeCount)"
            cell.emoji2CountLabel.text = "\(timeLineItem.wantContinueCount)"
            cell.emoji3CountLabel.text = "\(timeLineItem.sadCount)"
            cell.emoji4CountLabel.text = "\(timeLineItem.warmCount)"
        }
        
        return cell
    }
    
    // MARK: IBActions
    @IBAction func candidateViewPushButton(_ sender: UIButton) {
        if let viewController = CandidateViewController.instance() {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
