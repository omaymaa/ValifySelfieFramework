//
//  CameraViewController.swift
//  
//
//  Created by Omayma Marouf on 13/10/2024.
//

import UIKit
import AVFoundation

public protocol ValifySelfieFrameworkDelegate: AnyObject {
    func didCaptureImage(_ image: UIImage)
}

public class CameraViewController: UIViewController {

    public weak var delegate: ValifySelfieFrameworkDelegate?

    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var currentCameraPosition: AVCaptureDevice.Position = .front

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupUI() // Setup buttons and UI elements
        setupCamera()
    }

    func setupUI() {
        // Capture button
        let captureButton = UIButton(type: .system)
        captureButton.setTitle("Capture", for: .normal)
        captureButton.backgroundColor = UIColor.systemBlue
        captureButton.setTitleColor(.white, for: .normal)
        captureButton.layer.cornerRadius = 10
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(captureButton)

        // Switch camera button
        let switchCameraButton = UIButton(type: .system)
        switchCameraButton.setTitle("Switch", for: .normal)
        switchCameraButton.backgroundColor = UIColor.systemGreen
        switchCameraButton.setTitleColor(.white, for: .normal)
        switchCameraButton.layer.cornerRadius = 10
        switchCameraButton.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
        switchCameraButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(switchCameraButton)

        // Layout constraints
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            captureButton.widthAnchor.constraint(equalToConstant: 120),
            captureButton.heightAnchor.constraint(equalToConstant: 50),

            switchCameraButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            switchCameraButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            switchCameraButton.widthAnchor.constraint(equalToConstant: 120),
            switchCameraButton.heightAnchor.constraint(equalToConstant: 50)
        ])
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
    }

    func configureCamera(for position: AVCaptureDevice.Position) {
        captureSession.beginConfiguration()

        // Remove existing inputs
        if let currentInput = captureSession.inputs.first {
            captureSession.removeInput(currentInput)
        }

        // Add new input
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

    @objc func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        cameraOutput.capturePhoto(with: settings, delegate: self)
    }

    @objc func switchCamera() {
        currentCameraPosition = (currentCameraPosition == .back) ? .front : .back
        configureCamera(for: currentCameraPosition)
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Update preview layer to match view bounds after rotation or layout changes
        previewLayer.frame = view.bounds
    }
}

// MARK: - Photo Capture Delegate

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else { return }

        // Present the ImagePreviewViewController to preview the image
        let previewVC = ImagePreviewViewController(image: image)
        previewVC.delegate = self
        present(previewVC, animated: true)
    }
}

// MARK: - Image Preview Delegate

extension CameraViewController: ImagePreviewDelegate {
    public func didApproveImage(_ image: UIImage) {
        // Notify the app that the image was approved via the delegate
        delegate?.didCaptureImage(image)
    }

    public func didRequestRecapture() {
        // Restart the camera session to allow the user to take a new selfie
        captureSession.startRunning()
    }
}
