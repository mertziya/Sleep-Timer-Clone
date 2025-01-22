//
//  CircularSliderView.swift
//  AlarmProject
//
//  Created by Mert Ziya on 21.01.2025.
//

import Foundation
import UIKit

class CircularSliderView : UIView{
    
    //MARK: - Properties:
    
    // Chosing the minumum side of the view ensures that subviews are positioned without conflicts.
    var minSide = CGFloat()
    var currentAngle: CGFloat = 0.0
    
    var currentSleepingHours: Int = 0{ didSet{ delegate?.didGetSleepingTime(hours: currentSleepingHours, minutes: currentSleepingMinutes) } }
    var currentSleepingMinutes: Int = 0{ didSet{ delegate?.didGetSleepingTime(hours: currentSleepingHours, minutes: currentSleepingMinutes)} }
    
    var currentbedtimeHours: Int = 0{ didSet{delegate?.didGetBedtime(hours: currentbedtimeHours, minutes: currentbedtimeMinutes)} }
    var currentbedtimeMinutes: Int = 0{ didSet{delegate?.didGetBedtime(hours: currentbedtimeHours, minutes: currentbedtimeMinutes)} }
    
    var currentwakeupTimeHours : Int = 0{ didSet{delegate?.didGetWakeuptime(hours: currentwakeupTimeHours, minutes: currentwakeupTimeMinutes)} }
    var currentwakeupTimeMinutes : Int = 0{ didSet{delegate?.didGetWakeuptime(hours: currentwakeupTimeHours, minutes: currentwakeupTimeMinutes)} }
    
    var isValidatingSleepGoal = true{
        didSet{
            UIView.animate(withDuration: 0.4) {
                self.sliderIVContainer.backgroundColor = self.isValidatingSleepGoal ? .systemOrange : #colorLiteral(red: 0.1860291362, green: 0.1761325896, blue: 0.1934812367, alpha: 1)
                self.bedtimeIcon.backgroundColor = self.isValidatingSleepGoal ? .systemOrange : #colorLiteral(red: 0.1860291362, green: 0.1761325896, blue: 0.1934812367, alpha: 1)
                self.wakeupIcon.backgroundColor = self.isValidatingSleepGoal ? .systemOrange : #colorLiteral(red: 0.1860291362, green: 0.1761325896, blue: 0.1934812367, alpha: 1)
            }
            delegate?.didGetSleepscheduleValidation(isValid: isValidatingSleepGoal)
        }
    }
    
    private var bedTimeDegree : CGFloat = -90{
        didSet{
            applyRadialEffect(to: sliderIVContainer, radius: (minSide-8)/2, startDegree: bedTimeDegree , endDegree: wakeuptimeDegree)
        }
    }
    private var wakeuptimeDegree: CGFloat = 0{
        didSet{
            applyRadialEffect(to: sliderIVContainer, radius: (minSide-8)/2, startDegree: bedTimeDegree, endDegree: wakeuptimeDegree)
        }
    }
    private var isbedtimeSelected = true // to update the background color of the imageview while sliding.
    
    private var bedTimeIconPosition = CGPoint()
    private var wakeupTimeIconPosition = CGPoint()
    
    weak var delegate : CircularSliderDelegate?
    
    //MARK: - Selectable Custom View Options
    @IBInspectable var centerImage : UIImage = UIImage(){
        didSet{
            centerImageView.image = centerImage
            centerImageView.contentMode = .scaleAspectFill
        }
    }
    
    @IBInspectable var sliderImage : UIImage = UIImage(){
        didSet{
            sliderImageView.image = sliderImage
        }
    }
    
    //MARK: - UI Elements:
    let centerImageView = UIImageView()
    let sliderImageView = UIImageView()
    
    let mainContainer = UIView()
    let sliderIVContainer = UIView()
    let centerIVContainer = UIView()
    
    let wakeupIcon = UIImageView()
    let bedtimeIcon = UIImageView()
    
    
    // MARK: Initializers:
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        sliderIVContainer.backgroundColor = .systemOrange
        applyRadialEffect(to: sliderIVContainer, radius: (minSide-8)/2, startDegree: bedTimeDegree, endDegree: wakeuptimeDegree)
        
        // Ensures that background color is set to system orange initially.
        bedtimeIcon.backgroundColor = isValidatingSleepGoal ? .systemOrange : #colorLiteral(red: 0.1860291362, green: 0.1761325896, blue: 0.1934812367, alpha: 1)
        
        wakeupIcon.backgroundColor = isValidatingSleepGoal ? .systemOrange : #colorLiteral(red: 0.1860291362, green: 0.1761325896, blue: 0.1934812367, alpha: 1)
    }
    
    
    private func applyRadialEffect(to view: UIView, radius: CGFloat, startDegree: CGFloat, endDegree: CGFloat) {
        let center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        let startAngle: CGFloat = startDegree * .pi / 180
        let endAngle: CGFloat = endDegree * .pi / 180
        
        // Correct angle difference for 0° crossing
        let angleDifference = (endDegree - startDegree + 360).truncatingRemainder(dividingBy: 360)
        let percentageOf24Hours = angleDifference / 360
        let hours = Int(percentageOf24Hours * 24)
        let minutesAsPercent = (percentageOf24Hours * 24) - CGFloat(hours)
        let each5minutes = Int(minutesAsPercent * 12) * 5

        // Calculate bedtime and wakeup times using similar angle adjustment
        let bedtimeDifference = (startDegree - (-90) + 360).truncatingRemainder(dividingBy: 360)
        let percentageBedtimeHours = bedtimeDifference / 360
        let bedtimeHours = Int(percentageBedtimeHours * 24)
        let bedtimeMinutes = (percentageBedtimeHours * 24) - CGFloat(bedtimeHours)
        let bedtimeEach5minutes = Int(bedtimeMinutes * 12) * 5
        
        let wakeupDifference = (endDegree - (-90) + 360).truncatingRemainder(dividingBy: 360)
        let percentageWakeupTimeHours = wakeupDifference / 360
        let wakeupHours = Int(percentageWakeupTimeHours * 24)
        let wakeupMinutes = (percentageWakeupTimeHours * 24) - CGFloat(wakeupHours)
        let wakeupEach5minutes = Int(wakeupMinutes * 12) * 5
        
        // Set calculated times
        currentSleepingHours = hours
        currentSleepingMinutes = each5minutes
        currentbedtimeHours = bedtimeHours
        currentbedtimeMinutes = bedtimeEach5minutes
        currentwakeupTimeHours = wakeupHours
        currentwakeupTimeMinutes = wakeupEach5minutes
        
        let sleepGoal = UserDefaults.standard.object(forKey: "SleepGoal") as! CGFloat
        
        if sleepGoal <= percentageOf24Hours * 24{
            if isValidatingSleepGoal != (sleepGoal <= percentageOf24Hours * 24) {
                isValidatingSleepGoal = true
            }
        }else{
            if isValidatingSleepGoal != (sleepGoal <= percentageOf24Hours * 24) {
                isValidatingSleepGoal = false
            }
        }

        // Create radial shape mask
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath()
        path.move(to: center)
        path.addArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.close()
        
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
    }
        
}


//MARK: - Actions:
extension CircularSliderView{
    @objc private func iconMoved(_ pan : UIPanGestureRecognizer){
                
        isbedtimeSelected = pan.view == bedtimeIcon
        switch pan.state{
        
        case .changed, .began:
            // Get the location of the gesture
            let location = pan.location(in: self)
            let origin = sliderIVContainer.center

            // Calculate the angle between the origin and the current touch location
            let dx = location.x - origin.x
            let dy = location.y - origin.y
            let angle = atan2(dy, dx) // Angle in radians
            
            if isbedtimeSelected{
                bedTimeDegree = angle * 180 / .pi
            }else{
                wakeuptimeDegree = angle * 180 / .pi
            }

            UIView.animate(withDuration: 0.4) {
                if (self.isValidatingSleepGoal && self.isbedtimeSelected) {self.bedtimeIcon.backgroundColor = #colorLiteral(red: 0.9071688056, green: 0.5223704576, blue: 0, alpha: 1)}
                if (!self.isValidatingSleepGoal && self.isbedtimeSelected) {self.bedtimeIcon.backgroundColor = #colorLiteral(red: 0.1240680292, green: 0.1092830375, blue: 0.1309801042, alpha: 1)}
                if (self.isValidatingSleepGoal && !self.isbedtimeSelected) {self.wakeupIcon.backgroundColor = #colorLiteral(red: 0.9071688056, green: 0.5223704576, blue: 0, alpha: 1)}
                if (!self.isValidatingSleepGoal && !self.isbedtimeSelected) {self.wakeupIcon.backgroundColor = #colorLiteral(red: 0.1240680292, green: 0.1092830375, blue: 0.1309801042, alpha: 1)}

            }
            
            // Define the radius of the circular path
            let radius: CGFloat =  (minSide-8-42)/2

            // Calculate the new position using polar coordinates
            let newX = origin.x + radius * cos(angle)
            let newY = origin.y + radius * sin(angle)
            
            if isbedtimeSelected { bedTimeIconPosition = CGPoint(x: newX, y: newY)}
            else{ wakeupTimeIconPosition = CGPoint(x: newX, y: newY)}

            // Update the position of the view
            pan.view?.center = CGPoint(x: newX, y: newY)
            
        case .ended:
            UIView.animate(withDuration: 0.4) {
                self.bedtimeIcon.backgroundColor = (self.isValidatingSleepGoal) ?  .systemOrange : #colorLiteral(red: 0.1860291362, green: 0.1761325896, blue: 0.1934812367, alpha: 1)
                self.wakeupIcon.backgroundColor = (self.isValidatingSleepGoal) ?  .systemOrange : #colorLiteral(red: 0.1860291362, green: 0.1761325896, blue: 0.1934812367, alpha: 1)
            }
        
        default:
            return
        }
    }
    
    @objc private func timeSpanMoved(_ pan: UIPanGestureRecognizer) {
    }
    
    
}




// MARK: - UI Configurations:
extension CircularSliderView {
    
    private func setupView(){
        minSide = (bounds.width > bounds.height) ? bounds.height : bounds.width
        backgroundColor = .clear
        
        // Container Configurations:
        insertSubview(mainContainer, at: 0)
        insertSubview(sliderIVContainer, at: 1)
        insertSubview(centerIVContainer, at: 2)
        
        mainContainer.backgroundColor = .black
        centerIVContainer.backgroundColor = .black
                
        
        mainContainer.layer.cornerRadius = minSide / 2
        sliderIVContainer.layer.cornerRadius = (minSide - 8) / 2
        centerIVContainer.layer.cornerRadius = minSide * 0.7 / 2
        

        bedtimeIcon.image = createPaddedImage(UIImage(systemName: "bed.double.fill")!, padding: 20)
        bedtimeIcon.backgroundColor = .systemOrange
        bedtimeIcon.layer.cornerRadius = 42 / 2
        bedtimeIcon.clipsToBounds = true
        bedtimeIcon.isUserInteractionEnabled = true
        let bedtimePanGesture = UIPanGestureRecognizer(target: self, action: #selector(iconMoved(_:)))
        bedtimeIcon.addGestureRecognizer(bedtimePanGesture)
        
        
        wakeupIcon.image = createPaddedImage(UIImage(systemName: "clock")!, padding: 20)
        wakeupIcon.backgroundColor = .systemOrange
        wakeupIcon.layer.cornerRadius = 42 / 2
        wakeupIcon.clipsToBounds = true
        wakeupIcon.isUserInteractionEnabled = true
        let wakeupPanGesture = UIPanGestureRecognizer(target: self, action: #selector(iconMoved(_:)))
        wakeupIcon.addGestureRecognizer(wakeupPanGesture)
        
        
        sliderIVContainer.isUserInteractionEnabled = true
        let moveTimeSpanGesture = UIPanGestureRecognizer(target: self, action: #selector(timeSpanMoved(_:)))
        sliderIVContainer.addGestureRecognizer(moveTimeSpanGesture)
        

        
        mainContainer.clipsToBounds = true
        sliderIVContainer.clipsToBounds = true
        centerIVContainer.clipsToBounds = true
        
        // ImageView Configurations:
        sliderIVContainer.insertSubview(sliderImageView, at: 0)
        insertSubview(bedtimeIcon, at: 3)
        insertSubview(wakeupIcon, at: 3)
        
        centerIVContainer.addSubview(centerImageView)
        
        mainContainer.translatesAutoresizingMaskIntoConstraints = false
        sliderIVContainer.translatesAutoresizingMaskIntoConstraints = false
        centerIVContainer.translatesAutoresizingMaskIntoConstraints = false
        sliderImageView.translatesAutoresizingMaskIntoConstraints = false
        centerImageView.translatesAutoresizingMaskIntoConstraints = false
        bedtimeIcon.translatesAutoresizingMaskIntoConstraints = false
        wakeupIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            
            mainContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainContainer.heightAnchor.constraint(equalToConstant: minSide),
            mainContainer.widthAnchor.constraint(equalToConstant: minSide),
            
            
            sliderIVContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            sliderIVContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            sliderIVContainer.heightAnchor.constraint(equalToConstant: minSide - 8),
            sliderIVContainer.widthAnchor.constraint(equalToConstant: minSide - 8),
            
            sliderImageView.centerXAnchor.constraint(equalTo: sliderIVContainer.centerXAnchor),
            sliderImageView.centerYAnchor.constraint(equalTo: sliderIVContainer.centerYAnchor),
            sliderImageView.heightAnchor.constraint(equalToConstant: minSide - 30), // Make sure it is centered between 2 container
            sliderImageView.widthAnchor.constraint(equalToConstant: minSide - 30),
            
            
            centerIVContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            centerIVContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            centerIVContainer.heightAnchor.constraint(equalToConstant: minSide * 0.7),
            centerIVContainer.widthAnchor.constraint(equalToConstant: minSide * 0.7),
            
            // Because i couldnt get the right asset for wallClock i used weird constraints like this:
            centerImageView.leftAnchor.constraint(equalTo: centerIVContainer.leftAnchor, constant: 4),
            centerImageView.topAnchor.constraint(equalTo: centerIVContainer.topAnchor, constant: 4),
            centerImageView.rightAnchor.constraint(equalTo: centerIVContainer.rightAnchor, constant: -2),
            centerImageView.bottomAnchor.constraint(equalTo: centerIVContainer.bottomAnchor, constant: 2),
            
            bedtimeIcon.centerXAnchor.constraint(equalTo: sliderIVContainer.centerXAnchor),
            bedtimeIcon.topAnchor.constraint(equalTo: sliderIVContainer.topAnchor, constant: 0),
            bedtimeIcon.heightAnchor.constraint(equalToConstant: 42), // Make sure it is aligned well inside the circle of clock.
            bedtimeIcon.widthAnchor.constraint(equalToConstant: 42), // Make sure it is aligned well inside the circle of clock.
            
            wakeupIcon.centerYAnchor.constraint(equalTo: sliderIVContainer.centerYAnchor),
            wakeupIcon.rightAnchor.constraint(equalTo: sliderIVContainer.rightAnchor, constant: 0),
            wakeupIcon.heightAnchor.constraint(equalToConstant: 42),
            wakeupIcon.widthAnchor.constraint(equalToConstant: 42)
            
            
        ])
    }
  
    func createPaddedImage(_ image: UIImage, padding: CGFloat) -> UIImage? {
        let newSize = CGSize(width: image.size.width + padding * 2, height: image.size.height + padding * 2)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        let origin = CGPoint(x: padding, y: padding)
        image.draw(in: CGRect(origin: origin, size: image.size))
        let paddedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return paddedImage
    }
    

    
}
