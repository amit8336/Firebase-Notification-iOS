//
//  AppDelegate.swift
//  DemoFirebase
//
//  Created by Cloudus on 16/02/23.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        registerNotification()
        return true
    }
    
}

//MARK: - For Notification Extention
extension AppDelegate {
    
    // to Get Device Token
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("DeviceToken:- \(deviceToken)")
        FirebaseMessaging.Messaging.messaging().apnsToken = deviceToken
        connectToFcm()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        
    }
    
    // To Register Notification
    func registerNotification() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
            
            UNUserNotificationCenter.current().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    // To Get FCM Token
    func connectToFcm() {
        Messaging.messaging().token { token, error in
            
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
    }
    
    //To Get Notification Data
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        if let data = userInfo["aps"] as? Dictionary<String, AnyObject> {
            if let dict = data as? [String:Any] {
                notificationData = Model_Notification.init(dict: dict).alert
                NotificationCenter.default.post(name: NOTIFICATION_CALL, object: nil)
            }
            if let dictImage = userInfo["fcm_options"] as? Dictionary<String, AnyObject> {
                if let dict = dictImage["image"] as? String {
                    notificationImage = Model_Notification_image.init(imageURL: dict)
                    NotificationCenter.default.post(name: NOTIFICATION_CALL, object: nil)
                }
            }
        }
        
    }
    
    @available(iOS 12.4.0, *)
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])  {
        
        print("Recived: \(userInfo)")
        var temp : NSDictionary = userInfo as NSDictionary
        if let info = userInfo["aps"] as? Dictionary<String, AnyObject>  {
            
            let alertMsg = info["alert"] as? String
            var alert: UIAlertView?
            alert = UIAlertView(title: "Successfull.....", message: alertMsg, delegate: nil, cancelButtonTitle: "OK")
            alert?.show()
        }
    }
}

