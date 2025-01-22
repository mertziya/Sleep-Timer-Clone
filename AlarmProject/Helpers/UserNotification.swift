//
//  UserNotification.swift
//  AlarmProject
//
//  Created by Mert Ziya on 22.01.2025.
//

import Foundation
import UserNotifications

class UserNotification{
    
    static let shared = UserNotification()
    
    init(){}
    
    
    func checkForPermission(){
        let userNotification = UNUserNotificationCenter.current()
        userNotification.getNotificationSettings { settings in
            switch settings.authorizationStatus{
            case .authorized:
                print("authorized")
            case .denied:
                print("denied")
            case .notDetermined:
                userNotification.requestAuthorization(options: [.alert , .sound]) { didAllow, error in
                    if didAllow{
                        print("authorizerd")
                    }
                }
            default:
                return
            }
        }
    }
    
    
    func dispatchNotification(id: String , title: String , body : String, hour: Int, minutes: Int){
        let isDaily = true
        
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let calender = Calendar.current
        var dateComp = DateComponents(calendar: calender, timeZone: .current)
        dateComp.hour = hour
        dateComp.minute = minutes
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: isDaily)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
        notificationCenter.add(request)
    }
    
}
