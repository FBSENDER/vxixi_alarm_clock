//
//  AlarmTypePickerViewController.swift
//  vxixi_alarm_clock
//
//  Created by user on 16/2/22.
//  Copyright © 2016年 vxixi. All rights reserved.
//

import UIKit

class AlarmTypePickerViewController : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate{
    
    let alarmTypes = ["法定工作日", "每天", "只闹一次", "周一至周五"]
    

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int)->Int {
        return alarmTypes.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return alarmTypes[row]
    }
}
