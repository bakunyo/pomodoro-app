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
import Alamofire

class ViewController: UIViewController {

    var defaultCount = 60 * 25
    var count = 60 * 25
    var timerRunning = false
    var timer = Timer()
    let slackUrl = "https://hooks.slack.com/services/XXXX"

    func update() {
        count -= 1
        updateLabel()
        if count == 0 {
            let soundIdRing:SystemSoundID = 1000  // new-mail.caf
            AudioServicesPlaySystemSound(soundIdRing)
            postToSlack(message: "Finish Task!")
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

    func postToSlack(message: String) {
        let payload = "{\"text\": \"\(message)\"}"
        Alamofire.request(slackUrl, method: .post, parameters: ["payload": payload]).responseJSON { response in
            if response.result.isSuccess {
            }else{
            }
        }
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
    
    func createTimerTextField (
            title: String,
            xGrid: CGFloat
        ) -> UITextField {
        let tWidth: CGFloat = 60
        let tHeight: CGFloat = 30
        let posX: CGFloat = self.view.frame.width/7 * xGrid - tWidth/2
        let posY: CGFloat = self.view.frame.height/3 - tHeight/2

        let textField = UITextField(frame: CGRect(x: posX, y: posY, width: tWidth, height: tHeight))
        textField.text = title
        textField.keyboardType = UIKeyboardType.numberPad
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        return textField
    }

    func initTimerTextFields() {
        minutes = createTimerTextField(title: "25", xGrid: 2)
        self.view.addSubview(minutes)

        seconds = createTimerTextField(title: "00", xGrid: 5)
        self.view.addSubview(seconds)
    }

    func createTimerLabel(
        title: String,
        xGrid: CGFloat
        ) -> UILabel {
        let tWidth: CGFloat = 30
        let tHeight: CGFloat = 30
        let posX: CGFloat = self.view.frame.width/7 * xGrid - tWidth/2
        let posY: CGFloat = self.view.frame.height/3 - tHeight/2

        let label = UILabel(frame: CGRect(x: posX, y: posY, width: tWidth, height: tHeight))
        label.text = title
        return label
    }

    func initTimerLabels() {
        let m = createTimerLabel(title: "m", xGrid: 3)
        self.view.addSubview(m)

        let s = createTimerLabel(title: "s", xGrid: 6)
        self.view.addSubview(s)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(minutes.isFirstResponder){
            minutes.resignFirstResponder()
        }
        if(seconds.isFirstResponder){
            seconds.resignFirstResponder()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initTimerButtons()
        initTimerTextFields()
        initTimerLabels()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

