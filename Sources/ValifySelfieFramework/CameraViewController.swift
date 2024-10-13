//
//  CameraViewController.swift
//  
//
//  Created by Omayma Marouf on 13/10/2024.
//

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

        // Add a button to capture image
        let captureButton = UIButton(frame: CGRect(x: (view.bounds.width - 70) / 2, y: view.bounds.height - 100, width: 70, height: 70))
        captureButton.layer.cornerRadius = 35
        captureButton.backgroundColor = .white
        captureButton.setTitle("Capture", for: .normal)
        captureButton.setTitleColor(.black, for: .normal)
        captureButton.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
        view.addSubview(captureButton)
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

    @objc func captureImage() {
        let settings = AVCapturePhotoSettings()
        cameraOutput.capturePhoto(with: settings, delegate: self)
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

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto) {
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }

        let previewVC = ImagePreviewViewController(image: image)
        previewVC.delegate = self
        present(previewVC, animated: true)
    }
}

// MARK: - ImagePreviewDelegate
extension CameraViewController: ImagePreviewDelegate {
    public func didApproveImage(_ image: UIImage) {
        // Handle approved image
        print("Image approved")
        // You can pass the image to your ViewController or delegate it back.
    }

    public func didRequestRecapture() {
        // Handle recapture request
        print("User requested to recapture the image.")
    }
}
