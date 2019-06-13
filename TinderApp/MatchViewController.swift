//
//  MatchViewController.swift
//  TinderApp
//
//  Created by Orhun YILDIZ on 10.06.2019.
//  Copyright © 2019 Orhun YILDIZ. All rights reserved.
//

import UIKit
import Parse

class MatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var images = [UIImage]()//Resimleri tuttuğumuz dizi
    var userIds = [String]()//userid
    var userNames = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Birbirleri tarafından beğenilen kullanıcıların eşleştirilmesi.
        if let query = PFUser.query(){
            query.whereKey("liked", contains: PFUser.current()?.objectId)//liked sütunu dolu olanları getirdik.
            
            if let likedUser = PFUser.current()?["liked"] as? [String]{
                query.whereKey("objectId", containedIn: likedUser)//karşılıklı beğenme
            }
            //Koşula göre veri çekme
            query.findObjectsInBackground { (objects, error) in
                if let users = objects{
                    for object in users{
                        if let user = object as? PFUser{
                            if let imgFile = user["profilePhoto"] as? PFFileObject{
                                imgFile.getDataInBackground(block: { (data, error) in//Veri tabanından kullanıcının resmini çekiyoruz. Data olarak gelen resmi yorumlayıp tableviewda gösteriyoruz.
                                    if let imgData = data{
                                        if let img = UIImage(data: imgData){
                                            self.images.append(img)
                                        }
                                        if let objectId = user.objectId{
                                            self.userIds.append(objectId)
                                        }
                                        if let username = user.username{
                                            self.userNames.append(username)
                                        }
                                        self.tableView.reloadData()//Eşleşmenin gözükmesi için tableviewi yeniliyoruz.
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    //TableView Methodları
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userIds.count//2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as! MatchTableViewCell
        
        cell.matchUserName.text = userNames[indexPath.row]//sırayla alma
        cell.matchUserPhoto.image = images[indexPath.row]
        
        return cell
    }
}
