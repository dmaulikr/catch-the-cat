//
//  ViewController.swift
//  CatchTheCat
//
//  Created by Tolunay ÖZTÜRK on 12/08/2017.
//  Copyright © 2017 Tolunay ÖZTÜRK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var catBoundView: UIImageView!
    
    
    var timer = Timer()
    var catTimer = Timer()
    var counter: Int = 0
    var score: Int = 0
    var highScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        counter = 30
        timerLabel.text = String(counter)
        catImage.isUserInteractionEnabled = true
        highScore = UserDefaults.standard.integer(forKey: "highscore")
        highScoreLabel.text = "Highest Score: \(highScore)"
        
        let catTap = UITapGestureRecognizer(target: self,
                                            action: #selector(catTapFunc))
        
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(timerFunc),
                                     userInfo: nil,
                                     repeats: true)
        
        catTimer = Timer.scheduledTimer(timeInterval: 0.65,
                                        target: self,
                                        selector: #selector(catTimerFunc),
                                        userInfo: nil,
                                        repeats: true)
        
        catImage.addGestureRecognizer(catTap)
        
        
    }
    
    @objc func catTapFunc() {
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    @objc func catTimerFunc() {
        let IMAGE_WIDTH = CGFloat(64)
        let IMAGE_HEIGHT = CGFloat(64)
        
        let VALID_WIDTH = catBoundView.bounds.size.width - IMAGE_WIDTH
        let VALID_HEIGHT = catBoundView.bounds.size.height - IMAGE_HEIGHT
        
        let x = arc4random() % UInt32(VALID_WIDTH)
        let y = arc4random() % UInt32(VALID_HEIGHT)
        
        catImage.frame = CGRect(
            origin: CGPoint(x: Double(x), y: Double(y)),
            size: catImage.bounds.size
        )
        
        catBoundView.addSubview(catImage)
        
    }
    
    @objc func timerFunc() {
        timerLabel.text = String(counter)
        counter -= 1
        if counter == 0 {
            timer.invalidate()
            catTimer.invalidate()
            
            let gameOverAlert = UIAlertController(
                title: "Time is up!",
                message: "",
                preferredStyle: UIAlertControllerStyle.alert
            )
            
            let homeButton = UIAlertAction(
                title: "Home",
                style: .destructive,
                handler: {
                    action in
                    if self.score > self.highScore {
                        UserDefaults.standard.set(self.score, forKey: "highscore")
                        UserDefaults.standard.synchronize()
                        
                        self.highScore = UserDefaults.standard.object(forKey: "highscore") as! Int
                    }
                    
                    self.dismiss(animated: true, completion: nil)
            })
            
            let playAgainButton = UIAlertAction(
                title: "Play Again",
                style: .cancel,
                handler: {
                    (action) in
                    self.timer = Timer.scheduledTimer(timeInterval: 1,
                                                      target: self,
                                                      selector: #selector(self.timerFunc),
                                                      userInfo: nil,
                                                      repeats: true)
                    
                    self.catTimer = Timer.scheduledTimer(timeInterval: 0.65,
                                                         target: self,
                                                         selector: #selector(self.catTimerFunc),
                                                         userInfo: nil,
                                                         repeats: true)
                    
                    if self.score > self.highScore {
                        UserDefaults.standard.set(self.score, forKey: "highscore")
                        UserDefaults.standard.synchronize()
                        
                        self.highScore = UserDefaults.standard.object(forKey: "highscore") as! Int
                    }
                    
                    self.highScoreLabel.text = "Highest Score: \(self.highScore)"
                    self.scoreLabel.text = "Score: 0"
                    self.score = 0
                    self.counter = 30
                    self.timer.fire()
                    self.catTimer.fire()
            })
            
            
            gameOverAlert.addAction(playAgainButton)
            gameOverAlert.addAction(homeButton)
            self.present(gameOverAlert, animated: true, completion: nil)
        }
    }
    
}

