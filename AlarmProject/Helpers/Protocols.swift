//
//  Protocols.swift
//  AlarmProject
//
//  Created by Mert Ziya on 22.01.2025.
//

import Foundation

protocol CircularSliderDelegate : AnyObject{
    func didGetSleepingTime(hours: Int , minutes : Int)
    func didGetBedtime(hours: Int , minutes: Int)
    func didGetWakeuptime(hours : Int , minutes: Int)
    func didGetSleepscheduleValidation(isValid: Bool)
}
