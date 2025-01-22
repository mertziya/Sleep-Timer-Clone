//
//  SleepScheduleVC.swift
//  AlarmProject
//
//  Created by Mert Ziya on 21.01.2025.
//

import UIKit

class SleepScheduleVC: UIViewController{
    

    // MARK: - Properties:
    var bedHour : Int?
    var bedMinute : Int?
    
    var wakeupHour : Int?
    var wakeupMinute : Int?
    
    // MARK: - UI Elements:
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    // Scheduling the bedtime section:
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bedTime: UILabel!
    @IBOutlet weak var bedTimeofday: UILabel!
    @IBOutlet weak var wakeupTime: UILabel!
    @IBOutlet weak var wakeupTimeofday: UILabel!
    
    @IBOutlet weak var circularSlider: CircularSliderView!
    @IBOutlet weak var sleepDuration: UILabel!
    
    @IBOutlet weak var sleepdurationIcon: UIImageView!
    @IBOutlet weak var sleepDurationMessage: UILabel!
    
    // Alarm Options:
    @IBOutlet weak var alarmOptionsContainerView: UIView!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    
    // MARK: - Lifecycles:
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }
    
    
}

extension SleepScheduleVC{
    @objc private func endScheduling(){
        dismiss(animated: true)
    }
    
    @objc private func setScheduling(){
        
        if var pushBedHour = bedHour, var pushBedMinute = bedMinute, var pushWakeupHour = wakeupHour, var pushWakeupMinute = wakeupMinute{
            
            if pushBedMinute <= 10{
                pushBedHour -= 1
                pushBedMinute = 45 + pushBedMinute
            }else{ pushBedMinute -= 15}
            
            if pushWakeupMinute >= 45{
                pushWakeupHour += 1
                pushWakeupMinute = 15 - (60 - pushWakeupMinute)
            }else{ pushWakeupMinute += 15}
            
            // Handling the 24.00 Edge cases:
            if pushWakeupHour == 24 {pushWakeupHour = 0}
            if pushBedHour == -1 {pushBedHour = 23}
            
            
            print(pushBedHour , pushBedMinute)
            
            print(pushWakeupHour , pushWakeupMinute)
            
            
            UserNotification.shared.checkForPermission()
            
            UserNotification.shared.dispatchNotification(id: "goodNights", title: "You Have to sleep!", body: "15 minutes left for your optimal sleeping time.", hour: pushBedHour , minutes: pushBedMinute)
            UserNotification.shared.dispatchNotification(id: "goodMornings", title: "Good Morning!", body: "You should be awake by the time.", hour: pushWakeupHour, minutes: pushWakeupMinute)
        
            
        }
    }
    
    @objc private func switchAlarm(_ action : UISwitch){
        if action.isOn{
            doneButton.isEnabled = true
        }else{
            doneButton.isEnabled = false
        }
    }
}



extension SleepScheduleVC : CircularSliderDelegate {
    func didGetSleepingTime(hours: Int, minutes: Int) {
        sleepDuration.text = "\(hours) hr \(minutes) min"
    }
    
    func didGetBedtime(hours: Int, minutes: Int) {
        
        // Showing which day is it on the screen
        let currentDate = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentDate)
        let minute = calendar.component(.minute, from: currentDate)

        if (hours >= hour) && (minutes >= minute) {
            bedTimeofday.text = "Today"
        }else{
            bedTimeofday.text = "Tomorrow"
        }
        
        // Showing the hours and minutes chosen
        self.bedHour = hours
        self.bedMinute = minutes
        let minutesString = (minutes <= 5) ? "0\(minutes)" : "\(minutes)"
        bedTime.text = (hours >= 12) ? "\(hours-12):\(minutesString) PM" : "\(hours):\(minutesString) AM"
    }
    
    func didGetWakeuptime(hours: Int, minutes: Int) {
    
        // Showing which day is it on the screen
        let currentDate = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentDate)
        let minute = calendar.component(.minute, from: currentDate)

        if (hours >= hour) && (minutes >= minute) {
            wakeupTimeofday.text = "Today"
        }else{
            wakeupTimeofday.text = "Tomorrow"
        }
        
        self.wakeupHour = hours
        self.wakeupMinute = minutes
        let minutesString = (minutes <= 5) ? "0\(minutes)" : "\(minutes)"
        wakeupTime.text = (hours >= 12) ? "\(hours-12):\(minutesString) PM" : "\(hours):\(minutesString) AM"
    }
    func didGetSleepscheduleValidation(isValid: Bool) {
        sleepdurationIcon.isHidden = isValid ? true : false
        sleepDurationMessage.text = isValid ? "This schedule meets your sleep goal." : "This schedule does not meet your sleep goal."
    }
    
    private func setupUI(){
        containerView.layer.cornerRadius = 12
        
        cancelButton.addTarget(self, action: #selector(endScheduling), for: .touchUpInside)
        
        doneButton.setTitleColor(.systemGray2, for: .disabled)
        doneButton.setTitleColor(.link, for: .normal)
        doneButton.isEnabled = false
        doneButton.addTarget(self, action: #selector(setScheduling), for: .touchUpInside)
        
        alarmOptionsContainerView.layer.cornerRadius = 12
        alarmSwitch.isOn = false
        alarmSwitch.addTarget(self, action: #selector(switchAlarm(_:)), for: .valueChanged)
        
        circularSlider.delegate = self
    }
    
    
    
}
