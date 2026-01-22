//
//  ViewController.swift
//  IbadahLocalPods
//
//  Created by Talut Mahamud on 21/1/25.
//

import UIKit
import DeenIslamSDK
import Vmax

class ViewController: UIViewController{
    
    
    private var cView: UIView!
        private var ibadahHomeView: IbadahHome!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            initializeSDK()
            UserDefaults.standard.set("en", forKey: "language")
        }
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            // Initialize SDK after view appears and navigation controller is definitely set
            
        }
        
        private func setupUI() {
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
        }
        
        private func initializeSDK() {
            // Safely unwrap navigation controller
            guard let navigationController = self.navigationController else {
                print("Error: Navigation controller is not available")
                return
            }
            
            // Initialize SDK with proper error handling
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                // Initialize SDK
                DeenIslamGPSDK.shared.initialize(
                    with: navigationController,
                    delegate: self,
                    baseApiUrl: "",        // Replace with actual URL
                    baseServiceUrl: "", // Replace with actual URL
                    baseResourceUrl: "", // Replace with actual URL
                    baseGPHomeUrl: ""    // Replace with actual URL
                )
                
                DeenIslamVmaxInitializer.shared.initialize(accountKey: "grameenphone", appId: "4408990", privateKey: "MdNu7w/hwDiLqeXJ/txC+wVoojWIW/HQ+d6sAhcJXNA=", keyId: "fe7144aad27afba69d4c7090046d7c2a875c9e10b0a36d7969c882b3069e02e8", delegate: self)
                
                // Setup IbadahHome after SDK initialization
                self.setupIbadahHomeView()
            }
        }
        
        private func setupIbadahHomeView() {
            guard cView != nil else {
                print("Error: Container view not initialized")
                return
            }
            
            // Create IbadahHome
            ibadahHomeView = IbadahHome(sdk: DeenIslamGPSDK.shared, designType: "default", DeenAIVisible: true)
            
            // Add to container
            cView.addSubview(ibadahHomeView)
            
            // Setup constraints
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
    func notificationURL(url: String) {
        print("azan url: \(url)")
    }
    
        func tokenStatus(token isValid: Bool, completion: ((String) -> Void)?) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
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
        
        func onDeenTriggerEvent(event_name: String, param: String) {
            DispatchQueue.main.async {
                AlertToastHelper.shared.showToast(
                    message: "event: \(event_name) param: \(param)",
                    type: .error
                )
            }
        }
        
        func getToken(completion: @escaping (String) -> Void) {
            
            DispatchQueue.main.async { [weak self] in
                DeenIslamGPSDK.shared.logIn(with: "8801738609138") { token, error in
                    if let token = token {
                        completion(token)
                    } else {
                        print("Failed to get token: \(error ?? "Unknown error")")
                        completion("")
                    }
                }
            }
        }
        
        func errorMessage(error: String) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                print("SDK Error: \(error)")
                
                // Show error to user
                let alert = UIAlertController(
                    title: "Error",
                    message: error,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }

extension ViewController: InitializationStatusDelegate {
    func onSuccess() {
        print("Developer: VmaxManager initialization Success")
    }
    func onFailure(error: VmaxError) {
        print("Developer: VmaxManager initialization Failed, Error: \(error.description)")
    }
}
