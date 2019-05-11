//
//  LogInViewController.swift
//  TinderApp
//
//  Created by Orhun YILDIZ on 7.05.2019.
//  Copyright © 2019 Orhun YILDIZ. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logInUser(_ sender: Any) {
        
        let username = userNameTextField.text
        let password = passwordTextField.text
        
        PFUser.logInWithUsername(inBackground: username!, password: password!) { (user, error) in
            
            if error != nil{
                if let logInError = error as NSError?{
                    if let errorDetail = logInError.userInfo["error"] as? String{
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = errorDetail
                    }
                }
            }else{
                let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeViewController
                homeVC.current_username = user?.username //HomeVC'ye kullanıcı adını taşıma
                self.present(homeVC, animated: true, completion: nil)
                print("Başaralı bir şekilde giriş yaptınız.")
            }
            
        }
        
    }
    
}
