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

    override public func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
    }

    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo

        guard let camera = AVCaptureDevice.default(for: .video) else { return }
        let input = try! AVCaptureDeviceInput(device: camera)
        captureSession.addInput(input)

        cameraOutput = AVCapturePhotoOutput()
        captureSession.addOutput(cameraOutput)

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    @objc func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        cameraOutput.capturePhoto(with: settings, delegate: self)
    }
}


extension CameraViewController: AVCapturePhotoCaptureDelegate {
    public func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(), let image = UIImage(data: imageData) else { return }

        // Present the ImagePreviewViewController to preview the image
        let previewVC = ImagePreviewViewController(image: image)
        previewVC.delegate = self
        present(previewVC, animated: true)
    }
}

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


