//
//  AlarmNotify.swift
//  vxixi_alarm_clock
//
//  Created by user on 16/2/26.
//  Copyright © 2016年 vxixi. All rights reserved.
//

import Foundation
import UIKit

class Notify{
    static func setupNotificationSettings() {
        let notificationTypes: UIUserNotificationType = [UIUserNotificationType.Alert, UIUserNotificationType.Sound]
        
        
        // Specify the notification actions.
        let stopAction = UIMutableUserNotificationAction()
        stopAction.identifier = "myStop"
        stopAction.title = "OK"
        stopAction.activationMode = UIUserNotificationActivationMode.Background
        stopAction.destructive = false
        stopAction.authenticationRequired = false
        
        let snoozeAction = UIMutableUserNotificationAction()
        snoozeAction.identifier = "mySnooze"
        snoozeAction.title = "Snooze"
        snoozeAction.activationMode = UIUserNotificationActivationMode.Background
        snoozeAction.destructive = false
        snoozeAction.authenticationRequired = false
        
        
        let actionsArray = [UIUserNotificationAction](arrayLiteral: stopAction, snoozeAction)
        let actionsArrayMinimal = [UIUserNotificationAction](arrayLiteral: snoozeAction, stopAction)
        // Specify the category related to the above actions.
        let alarmCategory = UIMutableUserNotificationCategory()
        alarmCategory.identifier = "myAlarmCategory"
        alarmCategory.setActions(actionsArray, forContext: .Default)
        alarmCategory.setActions(actionsArrayMinimal, forContext: .Minimal)
        
        
        let categoriesForSettings = Set(arrayLiteral: alarmCategory)
        
        
        // Register the notification settings.
        let newNotificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: categoriesForSettings)
        UIApplication.sharedApplication().registerUserNotificationSettings(newNotificationSettings)
        //}
    }
    static func setNotify(){
        
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Year, .Month, .Day, .Hour, .Minute], fromDate: date)
        let dateComp:NSDateComponents = NSDateComponents()
        dateComp.year = components.year
        dateComp.month = components.month
        dateComp.day = components.day
        dateComp.timeZone = NSTimeZone.defaultTimeZone()
        Alarms.sharedInstance.preLoop()
        for alarm in Alarms.sharedInstance {
            let AlarmNotification: UILocalNotification = UILocalNotification()
            AlarmNotification.alertBody = "起床了！！！！"
            AlarmNotification.alertAction = "Open App"
            AlarmNotification.category = "AlarmCategory"
            AlarmNotification.timeZone = NSTimeZone.defaultTimeZone()
            AlarmNotification.soundName = "bell.mp3"
            AlarmNotification.userInfo = ["snooze" : "1", "index": "2", "soundName": "3"]
            if(alarm.alarmType == 1){
                dateComp.hour = alarm.alarmDayOrNight == 0 ? alarm.alarmHour : alarm.alarmHour + 12;
                dateComp.minute = alarm.alarmMinute
                dateComp.timeZone = NSTimeZone.defaultTimeZone()
                let alarmCalender = NSCalendar.currentCalendar()
                let alarmDate:NSDate = alarmCalender.dateFromComponents(dateComp)!
                AlarmNotification.fireDate = alarmDate
                AlarmNotification.repeatInterval = .Day
                UIApplication.sharedApplication().scheduleLocalNotification(AlarmNotification)
            }else if(alarm.alarmType == 3){
                dateComp.hour = alarm.alarmDayOrNight == 0 ? alarm.alarmHour : alarm.alarmHour + 12;
                dateComp.minute = alarm.alarmMinute
                dateComp.timeZone = NSTimeZone.defaultTimeZone()
                let alarmCalender:NSCalendar = NSCalendar.currentCalendar()
                let alarmDate:NSDate = alarmCalender.dateFromComponents(dateComp)!
                AlarmNotification.fireDate = alarmDate
                AlarmNotification.repeatInterval = .Weekday
                UIApplication.sharedApplication().scheduleLocalNotification(AlarmNotification)
            }else if(alarm.alarmType == 2){
                dateComp.hour = alarm.alarmDayOrNight == 0 ? alarm.alarmHour : alarm.alarmHour + 12;
                dateComp.minute = alarm.alarmMinute
                dateComp.timeZone = NSTimeZone.defaultTimeZone()
                let alarmCalender:NSCalendar = NSCalendar.currentCalendar()
                let alarmDate:NSDate = alarmCalender.dateFromComponents(dateComp)!
                AlarmNotification.fireDate = alarmDate.compare(NSDate()) == .OrderedDescending ? alarmDate : NSDate(timeInterval: 24 * 60 * 60, sinceDate: alarmDate)
                UIApplication.sharedApplication().scheduleLocalNotification(AlarmNotification)
            }else{
                for num in (0...7){
                    if(GlobalParams.dayOff.contains("\(components.month),\(components.day + num)")){
                        continue
                    }
                    dateComp.hour = alarm.alarmDayOrNight == 0 ? alarm.alarmHour : alarm.alarmHour + 12;
                    dateComp.minute = alarm.alarmMinute
                    dateComp.timeZone = NSTimeZone.defaultTimeZone()
                    let alarmCalender:NSCalendar = NSCalendar.currentCalendar()
                    let alarmDate:NSDate = alarmCalender.dateFromComponents(dateComp)!
                    let timeI = NSTimeInterval(num * 24 * 60 * 60)
                    AlarmNotification.fireDate = NSDate(timeInterval: timeI, sinceDate: alarmDate)
                    let notify = AlarmNotification.copy()
                    UIApplication.sharedApplication().scheduleLocalNotification(notify as! UILocalNotification)
                }
            }
            
            
        }
    }
}