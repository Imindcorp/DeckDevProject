//
//  AppDelegate.swift
//  DeckDevProject
//
//  Created by Ilnur Mindubayev on 28.04.2023.
//

import UIKit
import RxSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Private Properties
    
    private enum Constants {
        static let notificationTimeInterval: Double = 0.5
    }
    
    private let notificationCenter = UNUserNotificationCenter.current()
    var notificationsSubject = PublishSubject<String>()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else { return }
            self.notificationCenter.getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else {
                    return
                }
            }
        }
        notificationCenter.delegate = self
        
        return true
    }
}

// MARK: - sendMockNotification method

extension AppDelegate {
    func sendMockNotification() {
        let content = UNMutableNotificationContent()
        content.title = R.string.localizable.mockNotificationTitle()
        content.body = R.string.localizable.mockNotificationBody()
        content.sound = UNNotificationSound.default
        content.userInfo = [R.string.localizable.categoryIdentifier(): R.string.localizable.tableNeedsUpdate()]
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: Constants.notificationTimeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: R.string.localizable.mockNotificationId(), content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            print(error?.localizedDescription as Any)
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate methods

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
        
        if let stringEvent = notification.request.content.userInfo[R.string.localizable.categoryIdentifier()] {
            notificationsSubject.onNext(stringEvent as? PublishSubject<String>.Element ?? .empty)
        }
    }
}


