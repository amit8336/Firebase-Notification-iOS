//
//  NotificaionTitleVC.swift
//  DemoFirebase
//
//  Created by Cloudus on 16/02/23.
//

import UIKit
import SDWebImage

class NotificaionTitleVC: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: NOTIFICATION_CALL, object: nil)
    }
}


extension NotificaionTitleVC {
    func setData() {
        if let n_data = notificationData {
            self.titleLabel.text = n_data.title
            self.textLabel.text = n_data.body
        }
        if let n_image = notificationImage {
            if let url = URL(string: n_image.imageURL) {
                self.imageView.sd_setImage(with: url)
            }
        }
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        setData()
    }
}
