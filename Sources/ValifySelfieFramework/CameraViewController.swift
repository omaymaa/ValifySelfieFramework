//
//  CameraViewController.swift
//  
//
//  Created by Omayma Marouf on 13/10/2024.
//

import UIKit
import AVFoundation

import UIKit
import AVFoundation

public class CameraViewController: UIViewController {

    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var currentCameraPosition: AVCaptureDevice.Position = .front

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
        configureCamera(for: currentCameraPosition)

        cameraOutput = AVCapturePhotoOutput()
        captureSession.addOutput(cameraOutput)

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.insertSublayer(previewLayer, at: 0)

        captureSession.startRunning()

        // Add pinch gesture recognizer to switch cameras
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(switchCamera))
        view.addGestureRecognizer(pinchGesture)
    }

    func configureCamera(for position: AVCaptureDevice.Position) {
        // Begin configuring the session
        captureSession.beginConfiguration()

        // Remove existing inputs
        if let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput {
            captureSession.removeInput(currentInput)
        }

        // Add new camera input
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position) else {
            print("Error: No camera available")
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: camera)
            captureSession.addInput(input)
        } catch {
            print("Error: Unable to add camera input: \(error.localizedDescription)")
        }

        captureSession.commitConfiguration()
    }

    @objc func switchCamera() {
        // Toggle camera position
        currentCameraPosition = (currentCameraPosition == .back) ? .front : .back
        configureCamera(for: currentCameraPosition)
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update preview layer to match view bounds after rotation or layout changes
        previewLayer.frame = view.bounds
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop the camera session when the view disappears
        captureSession.stopRunning()
    }
}
