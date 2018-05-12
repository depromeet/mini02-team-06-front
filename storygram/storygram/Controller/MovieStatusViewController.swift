//
//  MovieStatusViewController.swift
//  storygram
//
//  Created by 이광용 on 2018. 5. 7..
//  Copyright © 2018년 gwangyonglee. All rights reserved.
//

import UIKit

class MovieStatusViewController: UIViewController {

    // MARK: IBOulets
    @IBOutlet var joiningPeopleLabel: UILabel!
    @IBOutlet var remainTimeLabel: UILabel!
    
    // MARK: Propeties
    var timer: Timer?
    
    // MARK: ViewController Instance
    static func instance() -> MovieStatusViewController? {
        return UIStoryboard(name: "MovieStatus", bundle: nil).instantiateViewController(withIdentifier: classNameToString) as? MovieStatusViewController
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.isNavigationBarHidden = true
        self.requestStoryLinesCount()
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
        self.timer?.invalidate()
    }
    
    // MARK: IBActions
    @IBAction func RelayStartButton(_ sender: UIButton) {
        if let viewController = TimeLineViewController.instance(){
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    // MARK: Methods
    func requestStoryLinesCount() {
        APIConnector.sharedManager.requestStoryLinesCount { result -> (Void) in
            if let joiningPeople = result {
                self.joiningPeopleLabel.text = "\(joiningPeople)명 참여중"
            }
        }
    }
    
    @objc func updateTime() {
        let remainTime = AppDelegate.shared?.remainTime()
        if let remainTime = remainTime {
            self.remainTimeLabel.text = "다음 릴레이까지 \(remainTime) 남음"
        }
    }
}
