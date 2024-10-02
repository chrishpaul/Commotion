//
//  MotionModel.swift
//  Commotion
//
//  Created by Eric Cooper Larson on 10/2/24.
//  Copyright © 2024 Eric Larson. All rights reserved.
//

import CoreMotion

// setup a protocol for the ViewController to be delegate for
protocol ActivityDelegate {
    // Define delegate functions
    func activityUpdated(activity:CMMotionActivity)
}



class MotionModel {
    
    // MARK: ======Class Variables======
    private let activityManager = CMMotionActivityManager()
    var delegate:ActivityDelegate? = nil
    
    // MARK: ======Motion Methods======
    func startActivityMonitoring(){
        // if active, let's start processing
        if CMMotionActivityManager.isActivityAvailable(){
            // assign updates to the main queue for activity
            self.activityManager.startActivityUpdates(to: OperationQueue.main)
            {(activity:CMMotionActivity?)->Void in
                if let unwrappedActivity = activity,
                    let delegate = self.delegate {
                    
                    delegate.activityUpdated(activity: unwrappedActivity)
                    
                } // end let
            }// end closure
        }// end if activity supported
    }// end func
    
}
