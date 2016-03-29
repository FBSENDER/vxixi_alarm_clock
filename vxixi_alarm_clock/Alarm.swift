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
    
    static let dayOff = ["3,12", "3,13", "3,19", "3,20", "3,26", "3,27", "3,33", "3,34", "3,35", "3,40", "3,41", "3,47", "3,48", "3,54", "3,55", "3,61", "3,62", "4,2", "4,3", "4,4", "4,9", "4,10", "4,16", "4,17", "4,23", "4,24", "4,30", "4,31", "4,32", "4,37", "4,38", "4,44", "4,45", "4,51", "4,52", "4,58", "4,59", "5,1","5,2","5,7","5,8","5,14","5,15", "5,21", "5,22", "5,28", "5,29"]
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