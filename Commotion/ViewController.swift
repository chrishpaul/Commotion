//
//  ViewController.swift
//  Commotion
//
//  Created by Eric Larson on 9/6/16.
//  Copyright © 2016 Eric Larson. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    // MARK: class variables
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    let motion = CMMotionManager()
    var totalSteps: Float = 0.0 {
        willSet(newtotalSteps){
            dispatch_async(dispatch_get_main_queue()){
                self.stepsSlider.setValue(newtotalSteps, animated: true)
                self.stepsLabel.text = "Steps: \(newtotalSteps)"
            }
        }
    }
    
    //MARK: UI Elements
    @IBOutlet weak var stepsSlider: UISlider!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var isWalking: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.stepsLabel.text = "No Steps Data"
        self.startActivityMonitoring()
        self.startPedometerMonitoring()
        self.startMotionUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: RawMotion Functions
    func startMotionUpdates(){
        // some internal inconsistency here: we need to ask the device manager for device 
        
        // should we be doing this from the MAIN queue? You will need to fix that!!!....
        if self.motion.deviceMotionAvailable{
            self.motion.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: self.handleMotion)
        }
    }
    
    func handleMotion(motionData:CMDeviceMotion?, error:NSError?){
        if let gravity = motionData?.gravity {
            let rotation = atan2(gravity.x, gravity.y) - M_PI
            self.isWalking.transform = CGAffineTransformMakeRotation(CGFloat(rotation))
        }
    }
    
    // MARK: Activity Functions
    func startActivityMonitoring(){
        // is activity is available
        if CMMotionActivityManager.isActivityAvailable(){
            // update from this queue (should we use the MAIN queue here??.... )
            self.activityManager.startActivityUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: self.handleActivity)
        }
        
    }
    
    func handleActivity(activity:CMMotionActivity?)->Void{
        // unwrap the activity and disp
        if let unwrappedActivity = activity {
            dispatch_async(dispatch_get_main_queue()){
                self.isWalking.text = "Walking: \(unwrappedActivity.walking)\n Still: \(unwrappedActivity.stationary)"
            }
        }
    }
    
    // MARK: Pedometer Functions
    func startPedometerMonitoring(){
        //separate out the handler for better readability
        if CMPedometer.isStepCountingAvailable(){
            pedometer.startPedometerUpdatesFromDate(NSDate(),
                                                    withHandler: self.handlePedometer)
        }
    }
    
    //ped handler
    func handlePedometer(pedData:CMPedometerData?, error:NSError?){
        if let steps = pedData?.numberOfSteps {
            self.totalSteps = steps.floatValue
        }
    }


}

