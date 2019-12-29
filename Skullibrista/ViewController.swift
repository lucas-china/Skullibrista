//
//  ViewController.swift
//  Skullibrista
//
//  Created by Lucas Santana Brito on 29/12/19.
//  Copyright © 2019 lsb.br. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var streetImageView: UIImageView!
    @IBOutlet weak var playerImageView: UIImageView!
    @IBOutlet weak var gameOverView: UIView!
    @IBOutlet weak var timePlayedLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        gameOverView.isHidden = true
    }

    @IBAction func playAgain(_ sender: UIButton) {
    }
    
}

