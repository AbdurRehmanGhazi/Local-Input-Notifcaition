//
//  AppDelegate.swift
//  Action Category Notification
//
//  Created by Abdur Rehman on 02/03/2023.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate{

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UNUserNotificationCenter.current().delegate = self

        configureCategory()
        triggerNotification()
        requestAuth()

        return true
    }


    private func requestAuth() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
        }
    }

    private func triggerNotification() {
        // Create Notification Content
        let content = UNMutableNotificationContent()
        content.title = "Weekly Staff Meeting"
        content.body = "Every Tuesday at 2pm"
        content.categoryIdentifier = "MEETING_INVITATION"

        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3.0, repeats: false)

        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "test_local_notification", content: content, trigger: notificationTrigger)

        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }

    private func configureCategory() {
        // Define Actions
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION",
              title: "Accept",
              options: [])
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION",
              title: "Decline",
              options: [.destructive])
        // Text input Action
        var textInput: UNTextInputNotificationAction?
        
        if #available(iOS 15.0, *) {
            textInput = UNTextInputNotificationAction(identifier: "INPUT_ACTION", title: "Enter message",options: [], icon: UNNotificationActionIcon(systemImageName: "text.bubble.fill.rtl"), textInputButtonTitle: "Send", textInputPlaceholder: "Enter message here...")
        } else {
            textInput = UNTextInputNotificationAction(identifier: "INPUT_ACTION", title: "Enter message",options: [], textInputButtonTitle: "Send", textInputPlaceholder: "Enter message here...")
        }
        
        // Define the notification type
        let meetingInviteCategory =
              UNNotificationCategory(identifier: "MEETING_INVITATION",
              actions: [acceptAction, declineAction, textInput!],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
              options: .customDismissAction)
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([meetingInviteCategory])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "ACCEPT_ACTION":
            print("ACCEPT_ACTION")
        case "DECLINE_ACTION":
            print("DECLINE_ACTION")
        case "INPUT_ACTION":
            print("INPUT_ACTION")
            if let response = response as? UNTextInputNotificationResponse {
                print(response.userText)
                UIApplication.shared.applicationIconBadgeNumber = 99
                UserDefaults.standard.set(response.userText, forKey: "message")
                if let vc = UIApplication.shared.keyWindow?.rootViewController {
                    vc.viewWillAppear(true)
                }
            }
        default:
            print("Other Action")
        }

        completionHandler()
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

