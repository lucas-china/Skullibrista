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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        gameOverView.isHidden = true
        setupStreet()
        setupPlayer()
    }
    
    private func setupStreet() {
        streetImageView.frame.size.width = view.frame.size.width * 2
        streetImageView.frame.size.height = view.frame.size.height * 2
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
        
        if motionManager.isDeviceMotionActive {
            motionManager.startDeviceMotionUpdates(to: .main) { (data, error) in
                if error != nil { return }
                guard let data = data else { return }
                print("x: \(data.gravity.x), y: \(data.gravity.y), z: \(data.gravity.z)")
                let angle = atan2(data.gravity.x, data.gravity.y)
                self.playerImageView.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
            }
        }
    }

    @IBAction func playAgain(_ sender: UIButton) {
    }
    
}

