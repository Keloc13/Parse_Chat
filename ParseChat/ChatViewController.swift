//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Kevin Nguyen on 2/21/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource,  UITableViewDelegate {
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var insertMessageField: UITextField!
    let query = PFQuery(className: "Message")
    var timer: Timer!
    var messageList: [PFObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "CHAT"
        messageTableView.dataSource = self
        messageTableView.delegate = self
        
        // Auto size row height based on cell autolayout constraints
        messageTableView.rowHeight = UITableViewAutomaticDimension
        // Provide an estimated row height. Used for calculating scroll indicator
        messageTableView.estimatedRowHeight = 50
        
         timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.onTimer), userInfo: nil, repeats: true)
        // fetch data asynchronously
       
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func isSend(_ sender: Any) {
        let chatMessage = PFObject(className: "Message")
        chatMessage["text"] = insertMessageField.text ?? ""
        chatMessage["user"] = PFUser.current()
        chatMessage.saveInBackground{(success, error) in
            if success {
                print("Data was saved")
            } else if let error = error {
                print("Problem saving message: \(error.localizedDescription)")
            }
        }
        insertMessageField.text = nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        
        let string = messageList[indexPath.row]
        cell.messageLabel.text = (string["text"] as! String)
        let user = string["user"] as? PFUser
        
        if user != nil {
            cell.userLabel.text = user?.username
        } else {
            cell.userLabel.text = "🤖"
        }
        return cell
    }
    
    @objc func onTimer() {
        self.query.includeKey("user")
        self.query.limit = 20
        self.query.addDescendingOrder("createdAt")
        self.query.findObjectsInBackground { (messages: [PFObject]?, error: Error?) in
            if messages != nil {
                // do something with the array of object returned by the call
                self.messageList = messages!
                for i in messages! {
                    // let user = (i["user"] as! PFUser)
                    // print("WOWOWW", user)
                    if i["user"] as? PFUser != nil{
                        print(i["user"] as! PFUser)
                    }
                }
            } else {
                print(error?.localizedDescription)
            }
        }
        self.messageTableView.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
