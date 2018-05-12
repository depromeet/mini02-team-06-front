//
//  WriteViewController.swift
//  storygram
//
//  Created by 이광용 on 2018. 5. 7..
//  Copyright © 2018년 gwangyonglee. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Toaster

class WriteViewController: UIViewController, UITextViewDelegate, NVActivityIndicatorViewable {
    
    // MARK: IBOutlet
    @IBOutlet var ExitButton: UIButton!
    @IBOutlet var latestContentLabel: UILabel!
    @IBOutlet var contentTextView: UITextView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet var remainTimeLabel: UILabel!
    @IBOutlet var bottomClock: UIImageView!
    @IBOutlet var bottomRemainTime: UILabel!
    @IBOutlet var InsertButton: UIButton!
    
    // MARK: Properties
    var timeLineItem: TimeLineModel?
    var timer: Timer?
    
    // MARK: ViewController Instance
    static func instance() -> WriteViewController? {
        return UIStoryboard(name: STORYGRAM_WRITE_STORYBOARD, bundle: nil).instantiateViewController(withIdentifier: classNameToString) as? WriteViewController
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backgroundView.layer.cornerRadius = 24
        self.backgroundView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        self.contentTextView.text = STORYGRAM_WRITE_INSERTMENT
    
        self.requestStoryLinesLatest()
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
    func requestStoryLinesLatest() {
        self.startAnimating(CGSize(width: 45, height: 45), type: .circleStrokeSpin)
        APIConnector.sharedManager.requestStoryLinesLatest { result -> Void in
            self.latestContentLabel.text = result
            self.stopAnimating()
        }
    }
    
    @objc func updateTime() {
        let remainTime = AppDelegate.shared?.remainTime()
        if let remainTime = remainTime {
            self.remainTimeLabel.text = remainTime
            self.bottomRemainTime.text = "다음 릴레이까지 \(remainTime) 남음"
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
            self.bottomClock.isHidden = false
            self.bottomRemainTime.isHidden = false
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y += keyboardSize.height
            self.bottomClock.isHidden = true
            self.bottomRemainTime.isHidden = true
        }
    }
    
    // MARK: IBActions
    @IBAction func touchUpExitButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchUpInsertButton(_ sender: UIButton) {
        if contentTextView.text == STORYGRAM_WRITE_INSERTMENT || contentTextView.text.isEmpty {
            self.contentTextView.resignFirstResponder()
            Toast(text: STORYGRAM_WRITE_INSERTMENT, duration: 1.0).show()
        }
        else {
            APIConnector.sharedManager.InsertStoryLine(content: contentTextView.text) { result -> (Void) in
                self.startAnimating(CGSize(width: 45, height: 45), type: .circleStrokeSpin)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: Override Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.contentTextView.resignFirstResponder()
    }
    
    // MARK: TextViewDelegate
    func textViewDidBeginEditing(_ text되iew: UITextView) {
        if contentTextView.text == STORYGRAM_WRITE_INSERTMENT {
            contentTextView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextView.text.isEmpty {
            contentTextView.text = STORYGRAM_WRITE_INSERTMENT
        }
    }
}
