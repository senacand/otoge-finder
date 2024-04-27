//
//  KeyboardHeight.swift
//  OtogeFinder
//
//  Credit: https://programmingwithswift.com/get-keyboard-height-swiftui/
//

import Foundation
import UIKit

class KeyboardHeight: ObservableObject {
    @Published var value: CGFloat = 0
    
    init() {
        listenForKeyboardNotifications()
    }
    
    private func listenForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardDidShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] (notification) in
            guard let userInfo = notification.userInfo,
                let keyboardRect = userInfo[
                    UIResponder.keyboardFrameEndUserInfoKey
                ] as? CGRect else
            {
                return
            }
            
            if keyboardRect.height > 0 {
                self?.value = keyboardRect.height
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardDidHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] (notification) in
            self?.value = 0
        }
    }
}
