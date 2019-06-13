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
    
    var userId = ""
    
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
            
            var likeOrUnlike = "" //Resmin beğenilip beğenilmediğini tutan string değişkeni.
            
            
            if pictureView.center.x < 50{//sola kaydırma animasyonu
                UIView.animate(withDuration: 0.5, animations: {
                    pictureView.center = CGPoint(x: pictureView.center.x - 210, y: pictureView.center.y)
                    //bu kısım resmi beğenmediğimizi ifade ediyor.
                    likeOrUnlike = "unliked"
                })
                showNewImg(likeOrUnlike: likeOrUnlike)
                animation()
                return
            } else if pictureView.center.x > (view.frame.width - 50){//sağa kaydırma animasyonu
                UIView.animate(withDuration: 0.5, animations: {
                    pictureView.center = CGPoint(x: pictureView.center.x + 210, y: pictureView.center.y)
                    //beğenilen resimler
                    likeOrUnlike = "liked"
                })
                showNewImg(likeOrUnlike: likeOrUnlike)
                animation()
                return
            }
            
        }
        
    }
    
    func showNewImg(likeOrUnlike:String){//Yeni resmi gösterme işlemi
        if likeOrUnlike != "" && userId != ""{
            PFUser.current()?.addUniqueObject(userId, forKey: likeOrUnlike)//objeyi ekliyoruz.
            PFUser.current()?.saveInBackground(block: { (success, error) in
                if success{//kaydetme işlemi başarılıysa
                    self.retrieveUsers()//yeni kullanıcı çağırıyor.
                }
            })
        }
    }
    
    func animation(){
        UIView.animate(withDuration: 0.5) {
            self.pictureView.center = self.view.center // Resmi merkeze döndürme animasyonu
            self.likeImageView.alpha = 0
            self.pictureView.transform = CGAffineTransform.identity
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
            //let gender = PFUser.current()?["gender"]
            //let interest = PFUser.current()?["interest"]
            query.whereKey("interest", equalTo: "Kadın")//İlgi alanı
            query.whereKey("gender", equalTo: "Erkek")//Cinsiyet
            
            //Sola veya sağa kaydırılan resmin bir daha gelmemesi gerekiyor.
            
            var dontShow = [String]()
            
            if let likedUser = PFUser.current()?["liked"] as? [String]{
                dontShow.append(contentsOf: likedUser)//beğenilen kullanıcı dontShow a eklendi.
            }
            
            if let unlikedUser = PFUser.current()?["unliked"] as? [String]{
                dontShow.append(contentsOf: unlikedUser)//beğenilmeyen kullanıcı dontShow a eklendi.
            }
            
            query.whereKey("objectId", notContainedIn: dontShow)//objectIDsi dontshow da olanları gösterme
            
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
                                    if let objectId = object.objectId{
                                        self.userId = objectId
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
