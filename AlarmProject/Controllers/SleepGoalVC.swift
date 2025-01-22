//
//  SleepGoalVC.swift
//  AlarmProject
//
//  Created by Mert Ziya on 21.01.2025.
//

import Foundation
import UIKit

class SleepGoalVC : UIViewController{
    
    let sliderView = UISlider()
    let setYourSleepGoalSection = UILabel()
    let sleepLabel = UILabel()
    let saveButton = UIButton()
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        view.addSubview(sliderView)
        view.addSubview(sleepLabel)
        view.addSubview(saveButton)
        view.addSubview(setYourSleepGoalSection)
        
        setYourSleepGoalSection.text = "Choose your sleep goal !"
        setYourSleepGoalSection.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        setYourSleepGoalSection.textColor = .label
        
        
        sliderView.minimumValue = 4
        sliderView.maximumValue = 16
        sliderView.addTarget(self, action: #selector(valueChanged(_:)), for: .valueChanged)
        
        sleepLabel.textColor = .label
        
        if let sleepGoal = UserDefaults.standard.object(forKey: "SleepGoal") as? Float{
            let hours = Int(sleepGoal)
            let minutesAsFraction = sleepGoal - Float(hours)
            let fiveminutesIntervals = Int(minutesAsFraction * 12) * 5
            sleepLabel.text = "\(hours) hr \(fiveminutesIntervals) min"
            sliderView.setValue(sleepGoal, animated: true)
        }
      
        
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.label, for: .normal)
        saveButton.backgroundColor = .link
        saveButton.layer.cornerRadius = 8
        saveButton.addTarget(self, action: #selector(setSleepGoal), for: .touchUpInside)
        
        
        
        
        
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sleepLabel.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        setYourSleepGoalSection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sliderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            sliderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            sliderView.widthAnchor.constraint(equalToConstant: 160),
            
            sleepLabel.bottomAnchor.constraint(equalTo: sliderView.topAnchor, constant: -24),
            sleepLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            setYourSleepGoalSection.bottomAnchor.constraint(equalTo: sleepLabel.topAnchor, constant: -36),
            setYourSleepGoalSection.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            saveButton.heightAnchor.constraint(equalToConstant: 44),
            saveButton.widthAnchor.constraint(equalToConstant: 120),
    
            
        ])
    }
    
    @objc private func valueChanged(_ slider : UISlider){
        let hours = Int(slider.value)
        let minutesAsFraction = slider.value - Float(hours)
        let fiveminutesIntervals = Int(minutesAsFraction * 12) * 5
        sleepLabel.text = "\(hours) hr \(fiveminutesIntervals) min"
    }
    
    @objc private func setSleepGoal(){
        UserDefaults.standard.set(sliderView.value, forKey: "SleepGoal")
        self.dismiss(animated: true)
    }
    
}
