//
//  ViewController.swift
//  vxixi_alarm_clock
//
//  Created by user on 16/2/19.
//  Copyright © 2016年 vxixi. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()

        //编辑状态下可以选择行
        tableView.allowsSelectionDuringEditing = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        setEditButtonItem()
    }
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if (editing){
            self.navigationItem.leftBarButtonItem?.title = "完成"
        }
        else{
            self.navigationItem.leftBarButtonItem?.title = "编辑"
        }
    }
    
    func setEditButtonItem(){
        if Alarms.sharedInstance.count != 0
        {
            self.navigationItem.leftBarButtonItem = editButtonItem()
            self.navigationItem.leftBarButtonItem?.possibleTitles = ["编辑", "完成"]
            self.navigationItem.leftBarButtonItem?.title = "编辑"
            self.editing = false
        }
        else
        {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Alarms.sharedInstance.count
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = Alarms.sharedInstance[indexPath.row].label
        
        
        let sw = UISwitch(frame: CGRect())
        //sw.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
        //tag is used to indicate which row had been touched
        sw.tag = indexPath.row
        sw.addTarget(self, action: "switchTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        let isOn = Alarms.sharedInstance[indexPath.row].isEnabled
        sw.setOn(isOn, animated: false)
        if(!isOn){
            cell.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)

        }
        cell.accessoryView = sw

        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            Alarms.sharedInstance.deleteAlarm(indexPath.row)
            Alarms.sharedInstance.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            setEditButtonItem()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if editing
        {
            //Global.indexOfCell = indexPath.row
            GlobalParams.editCurrentAlarm = Alarms.sharedInstance[indexPath.row]
            GlobalParams.editCurrentCellIndex = indexPath.row
            performSegueWithIdentifier("editAlarmSegue", sender: self)
        }
    }
    
    @IBAction func unwindToMainTableView(segue: UIStoryboardSegue) {
        GlobalParams.editCurrentAlarm = nil
        GlobalParams.editCurrentCellIndex = nil
        tableView.reloadData()
    }
    
    @IBAction func switchTapped(sender: UISwitch)
    {
        if sender.on
        {
            //print("switch on")
            sender.superview?.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            Alarms.sharedInstance.setAlarmOnOrOff(true, index: sender.tag)
            Alarms.sharedInstance.PersistAlarm(sender.tag)
        }
        else
        {
            //print("switch off")
            sender.superview?.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
            Alarms.sharedInstance.setAlarmOnOrOff(false, index: sender.tag)
            Alarms.sharedInstance.PersistAlarm(sender.tag)

        }
    }

}
