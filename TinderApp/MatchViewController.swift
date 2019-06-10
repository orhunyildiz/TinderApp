//
//  MatchViewController.swift
//  TinderApp
//
//  Created by Orhun YILDIZ on 10.06.2019.
//  Copyright © 2019 Orhun YILDIZ. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //TableView Methodları
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as! MatchTableViewCell
        
        cell.matchUserName.text = "Deneme"
        cell.matchUserPhoto.image = UIImage(named: "araba")
        
        return cell
    }
}
