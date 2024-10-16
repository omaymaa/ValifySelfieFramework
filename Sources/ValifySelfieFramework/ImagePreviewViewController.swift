//
//  ImagePreviewViewController.swift
//  
//
//  Created by Omayma Marouf on 13/10/2024.
//

import UIKit

public protocol ImagePreviewDelegate: AnyObject {
    func didApproveImage(_ image: UIImage)
    func didRequestRecapture()
}

public class ImagePreviewViewController: UIViewController {
    var image: UIImage
    public weak var delegate: ImagePreviewDelegate?

    public init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Image View
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)

        // Approval Button
        let approveButton = UIButton(type: .system)
        approveButton.setTitle("Approve", for: .normal)
        approveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20) // Bold font
        approveButton.setTitleColor(.white, for: .normal) // Text color
        approveButton.backgroundColor = .systemGreen // Background color
        approveButton.layer.cornerRadius = 10 // Rounded corners
        approveButton.addTarget(self, action: #selector(approveImage), for: .touchUpInside)
        approveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(approveButton)

        // Recapture Button
        let recaptureButton = UIButton(type: .system)
        recaptureButton.setTitle("Recapture", for: .normal)
        recaptureButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20) // Bold font
        recaptureButton.setTitleColor(.white, for: .normal) // Text color
        recaptureButton.backgroundColor = .systemRed // Background color
        recaptureButton.layer.cornerRadius = 10 // Rounded corners
        recaptureButton.addTarget(self, action: #selector(requestRecapture), for: .touchUpInside)
        recaptureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recaptureButton)

        // Layout Constraints
        NSLayoutConstraint.activate([
            // ImageView Constraints (300x300 and centered horizontally)
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),

            // Approve Button Constraints (beneath the image)
            approveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            approveButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            approveButton.widthAnchor.constraint(equalToConstant: 200), // Fixed width
            approveButton.heightAnchor.constraint(equalToConstant: 50), // Fixed height

            // Recapture Button Constraints (beneath the approve button)
            recaptureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recaptureButton.topAnchor.constraint(equalTo: approveButton.bottomAnchor, constant: 20),
            recaptureButton.widthAnchor.constraint(equalToConstant: 200), // Fixed width
            recaptureButton.heightAnchor.constraint(equalToConstant: 50) // Fixed height
        ])
    }

    @objc func approveImage() {
        delegate?.didApproveImage(image)
        dismiss(animated: true)
    }

    @objc func requestRecapture() {
        delegate?.didRequestRecapture()
        dismiss(animated: true)
    }
}
