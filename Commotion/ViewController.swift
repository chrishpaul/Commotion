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
    
    //TODO: ===should we have a model for proper MVC separation?===
    //MARK: class variables
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    let motion = CMMotionManager()
    
    var totalSteps: Float = 0.0 {
        willSet(newtotalSteps){ // observer
            DispatchQueue.main.async{
                // set value with subtle animation
                self.stepsSlider.setValue(newtotalSteps, animated: true)
                self.stepsLabel.text = "Steps: \(newtotalSteps)"

            }
        }
    }
    
    //MARK: UI Elements
    @IBOutlet weak var stepsSlider: UISlider!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var isWalking: UILabel!
    
    
    //MARK: View Hierarchy
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.totalSteps = 0.0
        self.startActivityMonitoring()
        self.startPedometerMonitoring()
        self.startMotionUpdates()
    }
   
    
}

// MARK: Extension for Raw Motion
extension ViewController{
    
    // MARK: Raw Motion Functions
    func startMotionUpdates(){
        // some internal inconsistency here: we need to ask the device manager for device
        
        // TODO: should we be doing this from the MAIN queue? You may need to fix that!  ...
        if self.motion.isDeviceMotionAvailable{
            self.motion.startDeviceMotionUpdates(to: OperationQueue.main,
                                                 withHandler: handleMotion)
        }
    }
    
    // Raw motion handler, update a label
    func handleMotion(_ motionData:CMDeviceMotion?, error:Error?){
        if let gravity = motionData?.gravity {
            // assume phone is in portrait
            // atan give angle of opposite over adjacent
            //   (y is out top of phone, x is out the side)
            //   but UI origin is top left with increasing down and to the right
            //   therefore proper rotation is the angle pointing opposite of motion (i.e., subtract pi)
            //
            let rotation = atan2(gravity.x, gravity.y) - Double.pi
            self.isWalking.transform = CGAffineTransform(rotationAngle:
                                                            CGFloat(rotation))
        }
    }
}

// MARK: Extension for Pedometer and Activity
extension ViewController{
    // ========Pedometer Functions========
    func startPedometerMonitoring(){
        //separate out the handler for better readability
        if CMPedometer.isStepCountingAvailable(){
            pedometer.startUpdates(from: Date(),withHandler: self.handlePedometer )
        }
    }
    
    //ped handler, show steps on slider
    func handlePedometer(_ pedData:CMPedometerData?, error:Error?){
        if let steps = pedData?.numberOfSteps {
            self.totalSteps = steps.floatValue
        }
    }
    
    // ========Activity Functions========
    func startActivityMonitoring(){
        // is activity is available
        if CMMotionActivityManager.isActivityAvailable(){
            // update from this queue (should we use the MAIN queue here??.... )
            self.activityManager.startActivityUpdates(to: OperationQueue.main, withHandler: self.handleActivity)
        }
        
    }
    
    // activity function handler, display activity in label
    func handleActivity(_ activity:CMMotionActivity?)->Void{
        // unwrap the activity and disp
        if let unwrappedActivity = activity {
            DispatchQueue.main.async{
                self.isWalking.text = "Walking: \(unwrappedActivity.walking)\n Still: \(unwrappedActivity.stationary)"
            }
        }
    }
}
