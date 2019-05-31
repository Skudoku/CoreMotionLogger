//
//  ViewController.swift
//  RoutePlotter
//
//  Created by Ties Baltissen on 27/05/2019.
//  Copyright © 2019 RazorBit. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var accelerometerDataLabel: UILabel!
    @IBOutlet weak var deviceMotionLabel: UILabel!
    @IBOutlet weak var pedoMeterDataLabel: UILabel!
    @IBOutlet weak var numberOfRecordsThisLogLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let motionManager = CMMotionManager()
    let pedoMeter = CMPedometer()
    
    var pedometerData: CMPedometerData?
    var accelerometerData: CMAccelerometerData?
    var deviceMotionData: CMDeviceMotion?
    var heading: CLLocationDirection?
    
    var isRecordingRecords = false
    
    var startLogTimestamp: Date?
    var currentRecords: [Record] = []
    
    
    let dateformatter : DateFormatter = {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        return dateformatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.startUpdatingHeading()
        
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.5
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) { (data, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.accelerometerDataLabel.text = "Accelerometer Data:\nx: \(data.acceleration.x)\ny: \(data.acceleration.y)\nz: \(data.acceleration.z)"
                        self.accelerometerData = data
                    }
                }
            }
        }
        
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.5
            motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.deviceMotionLabel.text = "Device Motion Data:\nQuaternionX: \(data.attitude.quaternion.x)\nQuaternionY: \(data.attitude.quaternion.y)\nQuaternionZ: \(data.attitude.quaternion.z)\nQuaternionW: \(data.attitude.quaternion.w)\nUserAccelX: \(data.userAcceleration.x)\nUserAccelY: \(data.userAcceleration.y)\nUserAccelZ: \(data.userAcceleration.z)"
                        self.deviceMotionData = data
                        if self.isRecordingRecords {
                            self.updateLog()
                        }
                    }
                }
            }
            
            
        }
        
        if CMPedometer.isStepCountingAvailable() {
            pedoMeter.startUpdates(from: Date()) { (data, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.pedoMeterDataLabel.text = "Pedometer Data:\nSteps: \(data.numberOfSteps)\nDistance(m): \(data.distance ?? 0)\nCurrentPace: \(data.currentPace ?? 0)\nCurrentCadence: \(data.currentCadence ?? 0)\nAverageActivePace:\(data.averageActivePace ?? 0)"
                        self.pedometerData = data
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.headingLabel.text = "Heading:\n\(newHeading.magneticHeading.rounded(.down))"
        self.heading = newHeading.magneticHeading
    }
    
    func updateLog() {
        guard let accelerometerData = accelerometerData, let deviceMotionData = deviceMotionData, let heading = heading else { return }
        currentRecords.append(Record(timestamp: dateformatter.string(from: Date()), numberOfSteps: pedometerData?.numberOfSteps.intValue, distance: pedometerData?.distance?.floatValue, currentPace: pedometerData?.currentPace?.floatValue, currentCadence: pedometerData?.currentCadence?.floatValue, averageActivePace: pedometerData?.averageActivePace?.floatValue, acceleration: Acceleration(x: Float(accelerometerData.acceleration.x), y: Float(accelerometerData.acceleration.y), z: Float(accelerometerData.acceleration.z)), userAcceleration: Acceleration(x: Float(deviceMotionData.userAcceleration.x), y: Float(deviceMotionData.userAcceleration.y), z: Float(deviceMotionData.userAcceleration.z)), attitudeQuaternion: Quaternion(x: Float(deviceMotionData.attitude.quaternion.x), y: Float(deviceMotionData.attitude.quaternion.y), z: Float(deviceMotionData.attitude.quaternion.z), w: Float(deviceMotionData.attitude.quaternion.w)), heading: Float(heading.rounded(.down))))
        self.numberOfRecordsThisLogLabel.text = "\(currentRecords.count)"
    }
    
    @IBAction func startLogTapped(_ sender: Any) {
        isRecordingRecords = true
        currentRecords = []
        startLogTimestamp = Date()
        self.startButton.isEnabled = false
        self.stopButton.isEnabled = true
    }
    
    @IBAction func stopLogTapped(_ sender: Any) {
        isRecordingRecords = false
        guard let start = startLogTimestamp else { return }
        let log = RecordLog(timestamp: dateformatter.string(from: start), records: currentRecords)
        currentRecords = []
        RecordHistoryRepository.shared.addLog(log)
        self.startButton.isEnabled = true
        self.stopButton.isEnabled = false
        
    }
}

