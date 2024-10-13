//
//  ImagePreviewViewController.swift
//  
//
//  Created by Omayma Marouf on 13/10/2024.
//

import UIKit

// Protocol to notify the delegate when the image is approved or recapture is requested.
public protocol ImagePreviewDelegate: AnyObject {
    func didApproveImage(_ image: UIImage)
    func didRequestRecapture()
}

public class ImagePreviewViewController: UIViewController {

    public weak var delegate: ImagePreviewDelegate?

    private var capturedImage: UIImage
    private let imageView = UIImageView()
    private let approveButton = UIButton(type: .system)
    private let recaptureButton = UIButton(type: .system)

    // Initializer to pass the captured image to the view controller
    public init(image: UIImage) {
        self.capturedImage = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    private func setupView() {
        view.backgroundColor = .white

        // Configure the imageView
        imageView.image = capturedImage
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        // Configure the approve button
        approveButton.setTitle("Approve", for: .normal)
        approveButton.addTarget(self, action: #selector(approveImage), for: .touchUpInside)
        approveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(approveButton)

        // Configure the recapture button
        recaptureButton.setTitle("Recapture", for: .normal)
        recaptureButton.addTarget(self, action: #selector(requestRecapture), for: .touchUpInside)
        recaptureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recaptureButton)

        // Layout the elements using Auto Layout
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Image view constraints
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 300),

            // Approve button constraints
            approveButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            approveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Recapture button constraints
            recaptureButton.topAnchor.constraint(equalTo: approveButton.bottomAnchor, constant: 20),
            recaptureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    @objc private func approveImage() {
        // Notify the delegate that the image has been approved
        delegate?.didApproveImage(capturedImage)
        dismiss(animated: true)
    }

    @objc private func requestRecapture() {
        // Notify the delegate that the user wants to recapture the image
        delegate?.didRequestRecapture()
        dismiss(animated: true)
    }
}
