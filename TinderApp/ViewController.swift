//
//  ViewController.swift
//  TinderApp
//
//  Created by Orhun YILDIZ on 27.04.2019.
//  Copyright © 2019 Orhun YILDIZ. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    @IBOutlet weak var pictureView: UIView!
    @IBOutlet weak var likeImageView: UIImageView!    
    @IBOutlet weak var userProfilePhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        retrieveUsers()
    }
    
    @IBAction func swipePicture(_ sender: UIPanGestureRecognizer) {
        guard let pictureView = sender.view else {return} // if koşulunun alternatifi ve daha etkili kullanımı. pictureView'in koordinatları alındı.
        let shift = sender.translation(in: view) // kaydırma-yer değiştirme miktarı belirlendi.
        pictureView.center = CGPoint(x: view.center.x + shift.x, y: view.center.y + shift.y)
        // pictureView'in yeni merkezi koordinat bazında kaydırma miktarı kadar x ekseni ve y eksenine eklenerek bulunur.
        
        let xDistanceFromCenter = pictureView.center.x - view.center.x // X eksenin değişimini bulma ve buna göre görüntünün sağa mı yoksa sola mı kaydığını belirleme.
        
        if xDistanceFromCenter > 0{
            likeImageView.alpha = 1
            likeImageView.image = UIImage(named: "like.png")
        }else{
            likeImageView.alpha = 1
            likeImageView.image = UIImage(named: "dislike.png")
        }
        
        likeImageView.alpha = abs(xDistanceFromCenter) / view.center.x
        let rotate = CGAffineTransform(rotationAngle: 0.45) //Radyan türünde döndürme açısı
        let scaleAndRotate = rotate.scaledBy(x: 0.8, y: 0.8)// Küçültme işlemi
        pictureView.transform = scaleAndRotate
        
        if sender.state == UIGestureRecognizer.State.ended{ //Sürükleme işleminin bittiğinin konrolü
            
            if pictureView.center.x < 50{
                UIView.animate(withDuration: 0.5, animations: {
                    pictureView.center = CGPoint(x: pictureView.center.x - 210, y: pictureView.center.y)
                })
                return
            } else if pictureView.center.x > (view.frame.width - 50){
                UIView.animate(withDuration: 0.5, animations: {
                    pictureView.center = CGPoint(x: pictureView.center.x + 210, y: pictureView.center.y)
                })
                return
            }
            
            
            
            UIView.animate(withDuration: 0.5) {
                pictureView.center = self.view.center // Resmi merkeze döndürme animasyonu
                self.likeImageView.alpha = 0
                pictureView.transform = CGAffineTransform.identity
            }
        }
        
    }
    @IBAction func logout(_ sender: Any) {
        PFUser.logOut()
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpViewController
        self.present(signUpVC, animated: true, completion: nil)
    }
    
    //Veritabanındaki kullanıcıların resimlerini belli koşula göre çekme.
    //Parse iOS dokümanına göre
    func retrieveUsers(){
        if let query = PFUser.query(){
            query.whereKey("interest", equalTo: "Erkek")//İlgi alanı erkek olanlar
            query.whereKey("gender", equalTo: "Kadın")//Cinsiyeti kadın olanlar
            query.limit = 2
            
            query.findObjectsInBackground { (objects, error) in
                if let users = objects{
                    for object in users{
                        if let user = object as? PFUser{//Resmi çekiyoruz.
                            if let imgFile = user["profilePhoto"] as? PFFileObject{
                                imgFile.getDataInBackground(block: { (data, error) in
                                    if let imgData = data{//img datayı aldıktan sonra resmi göstereceğiz
                                        self.userProfilePhoto.image = UIImage(data: imgData)
                                    }
                                })
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
}
