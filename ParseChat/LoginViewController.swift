//
//  LoginViewController.swift
//  ParseChat
//
//  Created by Kevin Nguyen on 2/21/18.
//  Copyright © 2018 KevinVuNguyen. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    let alertController = UIAlertController(title: "Missing Field", message: "Message", preferredStyle: .alert)
     let alertController2 = UIAlertController(title: "Incorrect Username/password", message: "Message", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            print("canceled")
        }
        // add the cancel action to the alertController
        alertController.addAction(cancelAction)
        alertController2.addAction(cancelAction)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    @IBAction func isSignUp(_ sender: Any) {
        let newUser = PFUser()
        
        if(usernameField.text?.isEmpty)! || (passwordField.text?.isEmpty)!{
            print("It was empty in either")
             self.present(self.alertController, animated: true, completion: nil)
        }
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        
        newUser.signUpInBackground{(success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                print("Error for some reason")
                self.present(self.alertController2, animated: true, completion: nil)
            } else {
                print("User Registered successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                // manually segue to logged in view
            }
        }
    }
    
    @IBAction func isLogin(_ sender: Any) {
        
        if(usernameField.text?.isEmpty)! || (passwordField.text?.isEmpty)!{
            self.present(self.alertController, animated: true, completion: nil)
        }
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
                self.present(self.alertController2, animated: true, completion: nil)
            } else {
                print("User logged in successfully")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                // display view controller that needs to shown after successful login
            }
        }
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
