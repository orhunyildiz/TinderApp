//
//  SignUpViewController.swift
//  TinderApp
//
//  Created by Orhun YILDIZ on 5.05.2019.
//  Copyright © 2019 Orhun YILDIZ. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveUser(_ sender: Any) {
        
        let user = PFUser()
        user.username = usernameTextField.text
        user.email = emailTextField.text
        user.password = passwordTextField.text
        
        user.signUpInBackground { (success, error) in
            if error != nil{
                if let signUpError = error as NSError?{
                    if let errorDetail = signUpError.userInfo["error"] as? String{//Hatanın ne olduğu dönecek
                        self.errorLabel.isHidden = false
                        self.errorLabel.text = errorDetail//Hatayı yazdırdık
                    }
                }
            }else{
                let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LogInViewController
                self.present(loginVC, animated: true, completion: nil)
                print("Kaydınız Başarıyla Tamamlanmıştır.")
            }
        }
        
    }
}
