//
//  tmp.swift
//  KNIR
//
//  Created by elena on 19.05.2024.
//

import Foundation

import UIKit
import SwiftUI

class ViewController: UIViewController {
    var selectCampusButton: UIButton!
    var validCampuses = ["Campus 1", "Campus 2", "Campus 3"]
    var selectedCampus: String? {
        didSet {
            selectCampusButton.setTitle(selectedCampus, for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSelectCampusButton()
    }

    private func setupSelectCampusButton() {
        selectCampusButton = UIButton(type: .system)
        selectCampusButton.setTitle("Select Campus", for: .normal)
        selectCampusButton.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
        selectCampusButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(selectCampusButton)
        
        NSLayoutConstraint.activate([
            selectCampusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectCampusButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func openSearch() {
        // This method is left empty since the sheet will be managed by SwiftUI
    }
}

struct ViewControllerRepresentable: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var selectedCampus: String?
    let validCampuses: [String]

    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        if isPresented {
            let searchSwiftUIView = SearchSwiftUIView(isPresented: $isPresented, selectedCampus: $selectedCampus, validCampuses: validCampuses)
            let hostingController = UIHostingController(rootView: searchSwiftUIView)
            hostingController.modalPresentationStyle = .automatic
            uiViewController.present(hostingController, animated: true)
        } else {
            uiViewController.dismiss(animated: true)
        }
    }
}
