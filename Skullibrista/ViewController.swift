//
//  ViewController.swift
//  Skullibrista
//
//  Created by Lucas Santana Brito on 29/12/19.
//  Copyright © 2019 lsb.br. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var streetImageView: UIImageView!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var timePlayedLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    var isMoving = false
    lazy var motionManager = CMMotionManager()
    var gameTimer: Timer!
    var startDate: Date!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        gameOverView.isHidden = true
        setupStreet()
        setupPlayer()
    }
    
    private func setupStreet() {
        streetImageView.frame.size.width = view.frame.size.width * 2
        streetImageView.frame.size.height = streetImageView.frame.size.width * 2
        streetImageView.center = view.center
    }
    
    private func setupPlayer() {
        playerImageView.center = view.center
        playerImageView.animationImages = []
        for i in 0...7 {
            guard let image = UIImage(named: "player\(i)") else { return }
            playerImageView.animationImages?.append(image)
        }
        playerImageView.animationDuration = 0.5
        playerImageView.startAnimating()
        
        Timer.scheduledTimer(withTimeInterval: 6.0, repeats: false) { (timer) in
            self.startGame()
        }
    }
    
    private func startGame() {
        instructionsLabel.isHidden = true
        gameOverView.isHidden = true
        isMoving = false
        startDate = Date()
        restartRotate()
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates(to: .main) { (data, error) in
                if error != nil { return }
                guard let data = data else { return }
                
                let angle = atan2(data.gravity.x, data.gravity.y) - .pi
                self.playerImageView.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
                
                if !self.isMoving {
                    self.checkGameOver()
                }
            }
        }
        
        gameTimer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { (timer) in
            self.rotateWorld()
        })
        
    }
    
    private func restartRotate() {
        self.playerImageView.transform = CGAffineTransform(rotationAngle: 0)
        self.streetImageView.transform = CGAffineTransform(rotationAngle: 0)
    }
    
    private func rotateWorld() {
        let randomAngle = Double(arc4random_uniform(120))/100 - 0.6
        isMoving = true
        UIView.animate(withDuration: 0.75, animations: {
            self.streetImageView.transform = CGAffineTransform(rotationAngle: CGFloat(randomAngle))
            
        }) { (success) in
            if success { self.isMoving = false }
        }
    }
    
    private func checkGameOver() {
        let worldAngle = atan2(Double(streetImageView.transform.a), Double(streetImageView.transform.b))
        let playerAngle = atan2(Double(playerImageView.transform.a), Double(playerImageView.transform.b))
        let difference = abs(worldAngle - playerAngle)
        
        if difference > 0.25 {
            gameTimer.invalidate()
            gameOverView.isHidden = false
            motionManager.stopDeviceMotionUpdates()
            
            let secondsPlayed = round(Date().timeIntervalSince(startDate))
            timePlayedLabel.text = "Você jogou durante \(secondsPlayed) segundos!"
        }
    }

    @IBAction func playAgain(_ sender: UIButton) {
        startGame()
    }
    
    
}

