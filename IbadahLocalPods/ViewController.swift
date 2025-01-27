//
//  ViewController.swift
//  IbadahLocalPods
//
//  Created by Talut Mahamud on 21/1/25.
//

import UIKit
import DeenIslamSDK

class ViewController: UIViewController {
    private var cView: UIView!  // Changed from IBOutlet to regular property
    private var ibadahHomeView: IbadahHome!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create container view programmatically
        cView = UIView()
        view.addSubview(cView)
        
        // Setup cView constraints
        cView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cView.topAnchor.constraint(equalTo: view.topAnchor),
            cView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Initialize SDK and IbadahHome
        DeenIslamGPSDK.shared.initialize(with: self.navigationController!, delegate: self)
        ibadahHomeView = IbadahHome(sdk: DeenIslamGPSDK.shared)
        
        // Add IbadahHome to container
        cView.addSubview(ibadahHomeView)
        
        // Setup IbadahHome constraints
        ibadahHomeView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ibadahHomeView.topAnchor.constraint(equalTo: cView.topAnchor),
            ibadahHomeView.leadingAnchor.constraint(equalTo: cView.leadingAnchor),
            ibadahHomeView.trailingAnchor.constraint(equalTo: cView.trailingAnchor),
            ibadahHomeView.bottomAnchor.constraint(equalTo: cView.bottomAnchor)
        ])
    }
}


extension ViewController: DeenIslamSDKNotifier {
    
    func getToken(completion: @escaping (String) -> Void) {
            // Login with phone number to get token
            DeenIslamGPSDK.shared.logIn(with: "8801708093636") { token, error in
                if let token = token {
                    // If login successful, return token via completion
                    completion(token)
                } else {
                    // Handle login failure
                    print("Failed to get token: \(error ?? "Unknown error")")
                    // You might want to return an empty string or handle this case differently
                    completion("")
                }
            }
        }
    
    func errorMessage(error: String) {
        print("SDK Error: \(error)")
    }
    
    func tokenStatus(token isValid: Bool, error: String?, completion: ((String) -> Void)?) {
        if !isValid {
            DeenIslamGPSDK.shared.logIn(with: "8801708093636") { token, error in
                if let token = token {
                    completion?(token)
                } else {
                    print("Login failed: \(error ?? "Unknown error")")
                }
            }
        } else {
            print("Token is valid")
        }
    }
}
