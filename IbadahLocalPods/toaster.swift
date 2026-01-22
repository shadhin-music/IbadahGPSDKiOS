//
//  toaster.swift
//  DeenIslamSDK
//
//  Created by Talut Mahamud on 1/2/25.
//

import UIKit

// Alert Toast Helper
class AlertToastHelper {
    static let shared = AlertToastHelper()
    
    private init() {}
    
    func showToast(message: String, type: ToastType = .error, duration: TimeInterval = 4.0) {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }
            
            let toastView = UIView()
            toastView.backgroundColor = type.backgroundColor
            toastView.layer.cornerRadius = 8
            toastView.clipsToBounds = true
            
            let label = UILabel()
            label.text = message
            label.textColor = .white
            label.numberOfLines = 0
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 14)
            
            toastView.addSubview(label)
            window.addSubview(toastView)
            
            // Setup constraints
            toastView.translatesAutoresizingMaskIntoConstraints = false
            label.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                toastView.bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -20),
                toastView.leadingAnchor.constraint(equalTo: window.leadingAnchor, constant: 20),
                toastView.trailingAnchor.constraint(equalTo: window.trailingAnchor, constant: -20),
                
                label.topAnchor.constraint(equalTo: toastView.topAnchor, constant: 12),
                label.bottomAnchor.constraint(equalTo: toastView.bottomAnchor, constant: -12),
                label.leadingAnchor.constraint(equalTo: toastView.leadingAnchor, constant: 12),
                label.trailingAnchor.constraint(equalTo: toastView.trailingAnchor, constant: -12)
            ])
            
            // Animation
            toastView.alpha = 0
            UIView.animate(withDuration: 0.3) {
                toastView.alpha = 1
            }
            
            // Dismiss after duration
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                UIView.animate(withDuration: 0.3, animations: {
                    toastView.alpha = 0
                }) { _ in
                    toastView.removeFromSuperview()
                }
            }
        }
    }
}

// Toast types with different colors
enum ToastType {
    case error
    case success
    case warning
    
    var backgroundColor: UIColor {
        switch self {
        case .error:
            return UIColor(red: 1, green: 0.2, blue: 0.2, alpha: 0.9)
        case .success:
            return UIColor(red: 0.2, green: 0.8, blue: 0.2, alpha: 0.9)
        case .warning:
            return UIColor(red: 1, green: 0.6, blue: 0, alpha: 0.9)
        }
    }
}



