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

        // MARK: - Bottom input UI
        private let bottomBar = UIView()
        private let bottomTextView = UITextView()
        private let bottomButton = UIButton(type: .system)
        private var bottomBarBottomConstraint: NSLayoutConstraint?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            setupBottomInputBar()
            setupUI()
            setupKeyboardHandling()
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
                // IMPORTANT: cView stays above the bottom bar
                cView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor)
            ])
        }

        private func setupBottomInputBar() {
            bottomBar.translatesAutoresizingMaskIntoConstraints = false
            bottomBar.backgroundColor = .secondarySystemBackground
            bottomBar.layer.borderWidth = 0.5
            bottomBar.layer.borderColor = UIColor.separator.cgColor
            view.addSubview(bottomBar)

            bottomTextView.translatesAutoresizingMaskIntoConstraints = false
            bottomTextView.font = .systemFont(ofSize: 15)
            bottomTextView.isScrollEnabled = false
            bottomTextView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
            bottomTextView.layer.cornerRadius = 10
            bottomTextView.layer.borderWidth = 0.5
            bottomTextView.layer.borderColor = UIColor.separator.cgColor
            bottomTextView.backgroundColor = .systemBackground
            bottomBar.addSubview(bottomTextView)

            bottomButton.translatesAutoresizingMaskIntoConstraints = false
            bottomButton.setTitle("Send", for: .normal)
            bottomButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
            bottomButton.addTarget(self, action: #selector(bottomSendTapped), for: .touchUpInside)
            bottomBar.addSubview(bottomButton)

            // Done button on keyboard
            addDoneButtonOnKeyboard()

            // Bottom bar constraints
            bottomBarBottomConstraint = bottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            bottomBarBottomConstraint?.isActive = true

            NSLayoutConstraint.activate([
                bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

                bottomTextView.topAnchor.constraint(equalTo: bottomBar.topAnchor, constant: 10),
                bottomTextView.leadingAnchor.constraint(equalTo: bottomBar.leadingAnchor, constant: 12),
                bottomTextView.bottomAnchor.constraint(equalTo: bottomBar.bottomAnchor, constant: -10),
                bottomTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),

                bottomButton.leadingAnchor.constraint(equalTo: bottomTextView.trailingAnchor, constant: 10),
                bottomButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -12),
                bottomButton.centerYAnchor.constraint(equalTo: bottomTextView.centerYAnchor),
                bottomButton.widthAnchor.constraint(equalToConstant: 70)
            ])
        }

        private func addDoneButtonOnKeyboard() {
            let toolbar = UIToolbar()
            toolbar.sizeToFit()

            let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
            toolbar.items = [flex, done]

            bottomTextView.inputAccessoryView = toolbar
        }

        @objc private func doneTapped() {
            view.endEditing(true)
        }

        @objc private func bottomSendTapped() {
            let text = bottomTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !text.isEmpty else { return }

            print("Bottom message: \(text)")
            DeenIslamGPSDK.shared.openFromRC(code: text)
        }

        private func setupKeyboardHandling() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }

        @objc private func keyboardWillChangeFrame(_ notification: Notification) {
            guard
                let info = notification.userInfo,
                let endFrame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
                let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
                let curveRaw = (info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue
            else { return }

            // Convert keyboard frame to this view's coordinate system
            let endFrameInView = view.convert(endFrame, from: nil)
            let keyboardHeight = max(0, view.bounds.maxY - endFrameInView.minY)

            // When keyboard is shown, we move the bottom bar up by keyboard height (minus safe area).
            let safeBottom = view.safeAreaInsets.bottom
            bottomBarBottomConstraint?.constant = -(keyboardHeight - safeBottom)

            let options = UIView.AnimationOptions(rawValue: curveRaw << 16)
            UIView.animate(withDuration: duration, delay: 0, options: options) {
                self.view.layoutIfNeeded()
            }
        }

        @objc private func keyboardWillHide(_ notification: Notification) {
            guard
                let info = notification.userInfo,
                let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
                let curveRaw = (info[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue
            else {
                bottomBarBottomConstraint?.constant = 0
                return
            }

            bottomBarBottomConstraint?.constant = 0
            let options = UIView.AnimationOptions(rawValue: curveRaw << 16)
            UIView.animate(withDuration: duration, delay: 0, options: options) {
                self.view.layoutIfNeeded()
            }
        }

        deinit {
            NotificationCenter.default.removeObserver(self)
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
                    baseGPHomeUrl: "https://mygp-home.deenislamic.com/"    // Replace with actual URL
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
    
    func onDeenSDKRCFailed(RC_Code: String) {
        
        AlertToastHelper.shared.showToast(
            message: "RC: \(RC_Code)",
            type: .error
        )
    }
    
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
