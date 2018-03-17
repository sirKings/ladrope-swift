//
//  VideoViewController.swift
//  app
//
//  Created by MAC on 3/16/18.
//  Copyright © 2018 Ladrope. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Cloudinary
import Firebase
import SCLAlertView

class VideoViewController: UIViewController, AVCaptureFileOutputRecordingDelegate {
    
    
    
    @IBOutlet var camPreview: UIView!
    var progressTimer : Timer!
    var progress : Int! = 0
    
    let avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    let config = CLDConfiguration(cloudName: "ladrope", apiKey: "676132983176963")
    var cloudinary: CLDCloudinary?
    

    
    @IBOutlet weak var recordButtonText: UIButton!
    
    @IBOutlet weak var timerText: UIButton!
    
    let captureSession = AVCaptureSession()
    
    let movieOutput = AVCaptureMovieFileOutput()
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var activeInput: AVCaptureDeviceInput!
    
    var outputURL: URL!
    var videoURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if setupSession() {
            setupPreview()
            startSession()
        }
        
        cloudinary = CLDCloudinary(configuration: config)
        
    }

    
    @objc func updateProgress() {

        //let maxDuration = CGFloat(15) // max duration of the recordButton

        progress = progress + 1
        if progress < 10 {
            timerText.setTitle("00:0\(progress!)", for: .normal)
        }else {
            timerText.setTitle("00:\(progress!)", for: .normal)
        }
        
        timerText.setTitleColor(.red, for: .normal)
        if progress >= 15 {
            progressTimer.invalidate()
            stopRecording()
        }

    }

    @IBAction func RetryPressed(_ sender: Any) {
        
    }
    
    @IBAction func recordButton(_ sender: Any) {
        startRecording()
    }
    
    @IBAction func DonePressed(_ sender: Any) {
        if videoURL != nil {
            UploadVideo(url: videoURL!)
            self.dismiss(animated: true){
                SCLAlertView().showSuccess("Success", subTitle: "Video submitted")
            }
        }else{
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupPreview() {
        // Configure previewLayer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = camPreview.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        camPreview.layer.addSublayer(previewLayer)
    }
    
    func setupSession() -> Bool {
        
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        // Setup Camera
        //let camera = AVCaptureDevice.default(., for: AVMediaType.video, position: AVCaptureDevice.front)
        var defaultVideoDevice: AVCaptureDevice?
        
        // Choose the back dual camera if available, otherwise default to a wide angle camera.
        if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            defaultVideoDevice = frontCameraDevice
        } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            // If the back dual camera is not available, default to the back wide angle camera.
            defaultVideoDevice = backCameraDevice
        }
        
        //let videoDeviceInput = try AVCaptureDeviceInput(device: defaultVideoDevice!)
        
        do {
            let input = try AVCaptureDeviceInput(device: defaultVideoDevice!)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
            }
        } catch {
            print("Error setting device video input: \(error)")
            return false
        }
        
        
        // Movie output
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        
        return true
    }
    
    func setupCaptureMode(_ mode: Int) {
        // Video Mode
        
    }
    
    //MARK:- Camera Session
    func startSession() {
        
        
        if !captureSession.isRunning {
            videoQueue().async {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        if captureSession.isRunning {
            videoQueue().async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func videoQueue() -> DispatchQueue {
        return DispatchQueue.main
    }
    
    
    
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        var orientation: AVCaptureVideoOrientation
        
        switch UIDevice.current.orientation {
        case .portrait:
            orientation = AVCaptureVideoOrientation.portrait
        case .landscapeRight:
            orientation = AVCaptureVideoOrientation.landscapeLeft
        case .portraitUpsideDown:
            orientation = AVCaptureVideoOrientation.portraitUpsideDown
        default:
            orientation = AVCaptureVideoOrientation.landscapeRight
        }
        
        return orientation
    }
    
    func startCapture() {
        
        self.progressTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(VideoViewController.updateProgress), userInfo: nil, repeats: true)

    }
    
    //EDIT 1: I FORGOT THIS AT FIRST
    
    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        
        if directory != "" {
            let path = directory.appendingPathComponent(NSUUID().uuidString + ".mp4")
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
    
    
    @objc func startRecording() {
        
        if movieOutput.isRecording == false {
            
            startCapture()
            recordButtonText.setImage(#imageLiteral(resourceName: "stop"), for: .normal)
            let connection = movieOutput.connection(with: AVMediaType.video)
            if (connection?.isVideoOrientationSupported)! {
                connection?.videoOrientation = currentVideoOrientation()
            }
            
            if (connection?.isVideoStabilizationSupported)! {
                connection?.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }
            
            let device = activeInput.device
            if (device.isSmoothAutoFocusSupported) {
                do {
                    try device.lockForConfiguration()
                    device.isSmoothAutoFocusEnabled = false
                    device.unlockForConfiguration()
                } catch {
                    print("Error setting configuration: \(error)")
                }
                
            }
            
            //EDIT2: And I forgot this
            outputURL = tempURL()
            movieOutput.startRecording(to: outputURL, recordingDelegate: self)
            
        }
        else {
            stopRecording()
        }
        
    }
    
    func stopRecording() {
        
        if movieOutput.isRecording == true {
            movieOutput.stopRecording()
            recordButtonText.setImage(#imageLiteral(resourceName: "capture"), for: .normal)
            timerText.setTitleColor(UIColor.init(red: 0, green: 74/255, blue: 0, alpha: 1), for: .normal)
        }
    }
    
    func capture(_ captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAt fileURL: URL!, fromConnections connections: [Any]!) {
        
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if (error != nil) {
            print("Error recording movie: \(error!.localizedDescription)")
        } else {
            
            //_ = outputURL as URL
            
            outputURL = outputFileURL
            setUpPlay(videoURL: outputURL)
            videoURL = outputURL
            progress! = 0
            
        }
        outputURL = nil
    }
    

    func setUpPlay(videoURL: URL){
    
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func UploadVideo(url: URL){
        print("Upload Url", url)
        let params = CLDUploadRequestParams().setPublicId((Auth.auth().currentUser?.uid)!).setResourceType("video")
        //let request = cloudinary.createUploader().upload(file: url, params: params)
        _ = cloudinary?.createUploader().upload(url: url, uploadPreset: "hsivazse", params: params as? CLDUploadRequestParams, progress: nil) {
            (res, error) in
            if error == nil {
                print(res?.url!)
                checkAndSubmitPendingOrders()
            }else{
                SCLAlertView().showError("Ooops", subTitle: "There was an error submitting your video. Try that again later")
            }
        }
    }
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
