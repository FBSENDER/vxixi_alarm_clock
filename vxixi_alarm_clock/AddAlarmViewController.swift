//
//  AddAlarmViewController.swift
//  vxixi_alarm_clock
//
//  Created by user on 16/2/21.
//  Copyright © 2016年 vxixi. All rights reserved.
//


import UIKit

class AddAlarmViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker1?.dataSource = self
        picker1?.delegate = self
        
        if(GlobalParams.editCurrentAlarm == nil){
            picker1?.selectRow(502, inComponent: 2, animated: false)
            picker1?.selectRow(480, inComponent: 3, animated: false)
        }
        else{
            picker1?.selectRow((GlobalParams.editCurrentAlarm?.alarmType)!, inComponent: 0, animated: false)
            picker1?.selectRow((GlobalParams.editCurrentAlarm?.alarmDayOrNight)!, inComponent: 1, animated: false)
            picker1?.selectRow((GlobalParams.editCurrentAlarm?.alarmHour)! + 494, inComponent: 2, animated: false)
            picker1?.selectRow((GlobalParams.editCurrentAlarm?.alarmMinute)! + 480, inComponent: 3, animated: false)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var picker1: UIPickerView?
    
    @IBAction func saveBtnClick(sender : AnyObject){
        if(GlobalParams.editCurrentAlarm == nil){
            Alarms.sharedInstance.append(Alarm(key: "\((picker1?.selectedRowInComponent(0))!),1,\((picker1?.selectedRowInComponent(1))!),\((picker1?.selectedRowInComponent(2))! % 13),\((picker1?.selectedRowInComponent(3))! % 60)"))
        }
        else{
            Alarms.sharedInstance[GlobalParams.editCurrentCellIndex!].alarmType = (picker1?.selectedRowInComponent(0))!
            Alarms.sharedInstance[GlobalParams.editCurrentCellIndex!].alarmDayOrNight = (picker1?.selectedRowInComponent(1))!
            Alarms.sharedInstance[GlobalParams.editCurrentCellIndex!].alarmHour = (picker1?.selectedRowInComponent)!(2) % 13
            Alarms.sharedInstance[GlobalParams.editCurrentCellIndex!].alarmMinute = (picker1?.selectedRowInComponent)!(3) % 60
            Alarms.sharedInstance[GlobalParams.editCurrentCellIndex!].alarmIsOn = 1
            Alarms.sharedInstance.PersistAlarm(GlobalParams.editCurrentCellIndex!)
        }
        Notify.setNotify()
        self.performSegueWithIdentifier("saveAlarm", sender: self)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int)->Int {
        switch component {
        case 0:
            return GlobalParams.alarmTypes.count
        case 1:
            return GlobalParams.alarmDayOrNight.count
        case 2:
            return 1000
        case 3:
            return 1000
        default:
            return 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
            case 0:
                return GlobalParams.alarmTypes[row]
            case 1:
                return GlobalParams.alarmDayOrNight[row]
            case 2:
                return GlobalParams.alarmHour[row % 13]
            case 3:
                return GlobalParams.alarmMinute[row % 60]
            default:
                return ""
        }
    }
    
    
}
