//
//  ViewController.swift
//  Commotion
//
//  Created by Eric Larson.
//  Copyright Eric Larson. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    @IBOutlet weak var activityLabel: UILabel!
    
    let motionModel = MotionModel()

    // MARK: ======UI Lifecycle Methods======
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adopt the protocol from model
        motionModel.delegate = self
        
        // just start doing motion updates
        motionModel.startActivityMonitoring()
    }

    
    
}

//MARK: Extension for Delegate
extension ViewController: ActivityDelegate{
    // MARK: ======Motion Methods======
    func activityUpdated(activity:CMMotionActivity){

        // debug, print out the activity decsription into the console
        print(activity.description)
        
        // update label with one of three activities
        if(activity.walking){
            self.activityLabel.text = "🚶Walking, conf: \(activity.confidence.rawValue)"
        }
        else if(activity.running){
            self.activityLabel.text = "🏃Running, conf: \(activity.confidence.rawValue)"
        }
        else if(activity.stationary){
            self.activityLabel.text = "📱Stationary, conf: \(activity.confidence.rawValue)"
        }
        else{
            self.activityLabel.text = "Not Walking or Running"
        }
    }
}
