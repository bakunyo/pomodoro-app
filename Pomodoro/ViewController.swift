//
//  ViewController.swift
//  Pomodoro
//
//  Created by Izuta Hiroyuki on 2016/12/31.
//  Copyright © 2016年 Izuta Hiroyuki. All rights reserved.
//

import UIKit
import AudioToolbox
import MaterialKit

class ViewController: UIViewController {
    
    var defaultCount = 60 * 25
    var count = 60 * 25
    var timerRunning = false
    var timer = Timer()
    private var myButton: UIButton!
    
    func update() {
        count -= 1
        updateLabel()
        if count == 0 {
            let soundIdRing:SystemSoundID = 1000  // new-mail.caf
            AudioServicesPlaySystemSound(soundIdRing)
            stop()
        }
    }
    
    @IBAction func calcCount() {
        var m = Int(minutes.text!)
        var s = Int(seconds.text!)
        if m == nil { m = 0 }
        if s == nil { s = 0 }
        count = m! * 60 + s!
        updateLabel()
    }
    
    func updateLabel() {
        let m = count / 60
        let s = count % 60
        minutes.text = String(format: "%02d", m)
        seconds.text = String(format: "%02d", s)
    }
    
    @IBOutlet weak var minutes: UITextField!
    @IBOutlet weak var seconds: UITextField!
    
    @IBAction func start(_ sender: UIButton) {
        if timerRunning { return }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        timerRunning = true
    }
    
    @IBAction func stopButton(_ sender: UIButton) {
        stop()
    }
    
    @IBAction func stop() {
        if timerRunning {
            timer.invalidate()
            timerRunning = false
        }
    }
    
    @IBAction func reset(_ sender: UIButton) {
        count = defaultCount
        updateLabel()
    }
    
    func createButton (
        bWidth: CGFloat,
        bHeight: CGFloat,
        posX: CGFloat,
        posY: CGFloat,
        title: String
        ) -> UIButton {
        let button = UIButton()
        let posX: CGFloat = posX
        let posY: CGFloat = posY
        button.frame = CGRect(x: posX, y: posY, width: bWidth, height: bHeight)
        button.backgroundColor = UIColor.MKColor.Blue.P500
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8.0
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        
        return button
    }
    
    func createTimerButton (
        title: String,
        xGrid: CGFloat
        ) -> UIButton {
        let bWidth: CGFloat = 80
        let bHeight: CGFloat = 30
        let posX: CGFloat = self.view.frame.width/6 * xGrid - bWidth/2
        let posY: CGFloat = self.view.frame.height/7 * 4 - bHeight/2
        return createButton(bWidth: bWidth, bHeight: bHeight, posX: posX, posY: posY, title: title)
    }
    
    func initTimerButtons() {
        // start button
        let startButton = createTimerButton(title: "Start", xGrid: 1)
        startButton.addTarget(self, action: #selector(self.start), for: .touchDown)
        self.view.addSubview(startButton)
        
        // stop button
        let stopButton = createTimerButton(title: "Stop", xGrid: 3)
        stopButton.addTarget(self, action: #selector(self.stop), for: .touchDown)
        self.view.addSubview(stopButton)
        
        // restart button
        let resetButton = createTimerButton(title: "Reset", xGrid: 5)
        resetButton.addTarget(self, action: #selector(self.reset), for: .touchDown)
        self.view.addSubview(resetButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTimerButtons()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

