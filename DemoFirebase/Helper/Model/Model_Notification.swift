//
//  Model_Notification.swift
//  DemoFirebase
//
//  Created by Cloudus on 16/02/23.
//

import Foundation

class Model_Notification: NSObject {
    
    var alert : Model_Notification_alert?
    var muteable_content : String = ""
    
    init(dict : [String:Any]){
        if let dt = dict["alert"] as? [String:Any] {
            alert = Model_Notification_alert.init(dict: dt)
        }
        if let dt = dict["mutable-content"] as? String {
            muteable_content = dt
        }
    }
    
}

class Model_Notification_alert: NSObject {
    
    var body : String = ""
    var title : String = ""
    
    init(dict : [String:Any]) {
        if let bodyOfNotification = dict["body"] as? String {
            body = bodyOfNotification
        }
        if let titleOfNotification = dict["title"] as? String {
            title = titleOfNotification
        }
    }
}

class Model_Notification_image : NSObject {
    var imageURL : String = ""
    
    init(imageURL : String) {
        if let image = imageURL as? String {
            self.imageURL = image
        }
    }
    
}
