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
        view.backgroundColor = .black

        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds
        view.addSubview(imageView)

        // Approval Button
        let approveButton = UIButton(type: .system)
        approveButton.setTitle("Approve", for: .normal)
        approveButton.addTarget(self, action: #selector(approveImage), for: .touchUpInside)
        approveButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(approveButton)

        // Recapture Button
        let recaptureButton = UIButton(type: .system)
        recaptureButton.setTitle("Recapture", for: .normal)
        recaptureButton.addTarget(self, action: #selector(requestRecapture), for: .touchUpInside)
        recaptureButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recaptureButton)

        // Layout Constraints
        NSLayoutConstraint.activate([
            approveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            approveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            recaptureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recaptureButton.bottomAnchor.constraint(equalTo: approveButton.topAnchor, constant: -20)
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
