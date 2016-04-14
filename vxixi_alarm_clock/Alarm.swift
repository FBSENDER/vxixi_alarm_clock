//
//  Alarm.swift
//  vxixi_alarm_clock
//
//  Created by user on 16/2/24.
//  Copyright © 2016年 vxixi. All rights reserved.
//
import UIKit
import Foundation

//使用类的静态属性记录一些全局变量
class GlobalParams{
    
    static let alarmTypes = ["工作日", "每天", "闹一次", "周1至5"]
    
    static let alarmDayOrNight = ["上午","下午"]
    
    static let alarmHour = Array(0...12).map({String($0)})
    
    static let alarmMinute = Array(0...59).map({ m in String(format: "%02d", m)})
    
    static var editCurrentAlarm : Alarm? = nil
    
    static var editCurrentCellIndex : Int? = nil
    
    static let dayOff = ["3,41", "3,47", "3,48", "3,54", "3,55", "3,61", "3,62", "4,2", "4,3", "4,4", "4,9", "4,10", "4,16", "4,17", "4,23", "4,24", "4,30", "4,31", "4,32", "4,37", "4,38", "4,44", "4,45", "4,51", "4,52", "4,58", "4,59", "5,1","5,2","5,7","5,8","5,14","5,15", "5,21", "5,22", "5,28", "5,29", "5,35", "5,36", "5,40", "5,41", "5,42", "5,49", "5,50", "5,56", "5,57", "6,4", "6,5", "6,9", "6,10", "6,11", "6,18", "6,19", "6,25", "6,26", "6,32", "6,33", "6,39", "6,40",
        "6,46", "6,47", "6,53", "6,54", "6,60", "6,61", "7,2", "7,3", "7,9", "7,10", "7,16", "7,17", "7,23", "7,24", "7,30", "7,31",
        "7,37", "7,38", "7,44", "7,45", "7,51", "7,52", "7,58", "7,59", "8,6", "8,7", "8,13", "8,14", "8,20", "8,21", "8,27", "8,28",
        "8,34", "8,35", "8,41", "8,42", "8,46", "8,47", "8,48", "8,55", "8,56", "8,62", "8,63", "9,3", "9,4", "9,10", "9,11", "9,15", "9,16", "9,17", "9,24", "9,25", "9,31", "9,32", "9,33", "9,34", "9,35", "9,36", "9,37", "9,45", "9,46", "9,52", "9,53",
        "9,59", "9,60", "10,1", "10,2", "10,3", "10,4", "10,5", "10,6", "10,7", "10,15", "10,16", "10,22", "10,23", "10,29", "10,30"]
}

//Alarm 闹钟类
class Alarm{
    
    var alarmType : Int
    var alarmIsOn : Int
    var alarmDayOrNight : Int
    var alarmHour : Int
    var alarmMinute: Int
    
    init(key: String){
        var alarmKeys = key.characters.split{$0 == ","}.map(String.init)
        alarmType = Int(alarmKeys[0])!
        alarmIsOn = Int(alarmKeys[1])!
        alarmDayOrNight = Int(alarmKeys[2])!
        alarmHour = Int(alarmKeys[3])!
        alarmMinute = Int(alarmKeys[4])!
    }
    
    func getKey() -> String {
        return "\(alarmType),\(alarmIsOn),\(alarmDayOrNight),\(alarmHour),\(alarmMinute)"
    }
    
    var label : String{
        return "\(GlobalParams.alarmTypes[alarmType]) \(GlobalParams.alarmDayOrNight[alarmDayOrNight]) \(GlobalParams.alarmHour[alarmHour]):\(GlobalParams.alarmMinute[alarmMinute])"
    }
    
    var isEnabled : Bool{
        return alarmIsOn == 1
    }
}

//singleton, for-in loop supporting
class Alarms: SequenceType{
    
    //ensure can not be instantiated outside
    private init(){
        ud = NSUserDefaults.standardUserDefaults()
        alarmKey = "vxixiAlarm"
        alarms = getAllAlarm()
    }
    
    private let ud:NSUserDefaults
    
    private let alarmKey: String
    
    private var alarms:[Alarm] = [Alarm]()
    
    static let sharedInstance = Alarms()
    
    
    //开启或关闭指定位置的闹钟
    func setAlarmOnOrOff(isOn: Bool, index: Int){
        
        alarms[index].alarmIsOn = isOn ? 1 : 0
        
    }
    
    //setObject only support "property list objects",so we cannot persist alarms directly
    func append(alarm: Alarm){
        
        alarms.append(alarm)
        
        PersistAlarm(alarm, index: alarms.count-1)
        
    }
    
    //将数组alarms中的闹钟数据持久化到NSUserDefaults中,key 为 alarmKey,append 闹钟时使用
    func PersistAlarm(alarm: Alarm, index: Int){
        
        var alarmArray = ud.arrayForKey(alarmKey) ?? []
        
        alarmArray.append(alarm.getKey())
        
        ud.setObject(alarmArray, forKey: alarmKey)
        
        ud.synchronize()
    }
    
    //将数组alarms中的闹钟数据持久化到NSUserDefaults中,key 为 alarmKey,update 闹钟时使用
    func PersistAlarm(index: Int){
        
        var alarmArray = ud.arrayForKey(alarmKey) ?? []
        
        alarmArray[index] = alarms[index].getKey()
        
        ud.setObject(alarmArray, forKey: alarmKey)
        
        ud.synchronize()
    }
    
    //删除闹钟
    func deleteAlarm(index: Int){
        
        var alarmArray = ud.arrayForKey(alarmKey) ?? []
        
        alarmArray.removeAtIndex(index)
        
        ud.setObject(alarmArray, forKey: alarmKey)
        
        ud.synchronize()
    }
    

    private func getAllAlarm() -> [Alarm] {
        
        let alarmArray = NSUserDefaults.standardUserDefaults().arrayForKey(alarmKey)
        if alarmArray != nil{
            return alarmArray!.map(){Alarm(key: $0 as! String)}
        }
        else
        {
            return [Alarm]()
        }
    }
    
    var count:Int{
        
        return alarms.count
    }
    
    subscript(index: Int) -> Alarm{
        get{
            assert((index < alarms.count && index >= 0), "Index out of range")
            return alarms[index]
        }
        set{
            assert((index < alarms.count && index >= 0), "Index out of range")
            alarms[index] = newValue
        }
        
    }
    
    func removeAtIndex(index: Int){
        
        alarms.removeAtIndex(index)
    }

    
    var isEmpty: Bool{
        
        return alarms.isEmpty
    }
    
    //SequenceType Protocol
    private var currentIndex = 0
    func preLoop(){
        self.currentIndex = 0
    }
    func generate() -> AnyGenerator<Alarm> {
        
        return anyGenerator(){self.currentIndex < self.alarms.count ? self.alarms[self.currentIndex++] : nil}
    }
    
    
}