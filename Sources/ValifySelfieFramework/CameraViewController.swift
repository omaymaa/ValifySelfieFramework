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

    var captureSession: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var currentCameraPosition: AVCaptureDevice.Position = .front
    public weak var delegate: ValifySelfieFrameworkDelegate?

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupCaptureButton()
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

        // Start the capture session on a background thread
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }

    func configureCamera(for position: AVCaptureDevice.Position) {
        // Configure the camera based on the position (front/back)
        captureSession.beginConfiguration()
        if let currentInput = captureSession.inputs.first as? AVCaptureDeviceInput {
            captureSession.removeInput(currentInput)
        }
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

    func setupCaptureButton() {
        let captureButton = UIButton(type: .system)
        captureButton.setTitle("Capture Selfie", for: .normal)
        captureButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20) // Make the font bold and larger
        captureButton.backgroundColor = .systemBlue // Set a background color
        captureButton.setTitleColor(.white, for: .normal) // Set title color to white
        captureButton.layer.cornerRadius = 10 // Add corner radius
        captureButton.addTarget(self, action: #selector(captureSelfie), for: .touchUpInside)

        captureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(captureButton)

        // Set up constraints to position the button
        NSLayoutConstraint.activate([
            captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20), // Use safe area
            captureButton.widthAnchor.constraint(equalToConstant: 200), // Set a fixed width
            captureButton.heightAnchor.constraint(equalToConstant: 50) // Set a fixed height
        ])
    }

    @objc func captureSelfie() {
        let settings = AVCapturePhotoSettings()
        cameraOutput.capturePhoto(with: settings, delegate: self)
    }

    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds // Update preview layer frame
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession.stopRunning() // Stop the camera session
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }

        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else { return }

        // Notify the delegate about the captured image
        delegate?.didCaptureImage(image)
        dismiss(animated: true)
    }
}
