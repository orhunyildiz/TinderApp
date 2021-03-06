//
//  HomeViewController.swift
//  TinderApp
//
//  Created by Orhun YILDIZ on 7.05.2019.
//  Copyright © 2019 Orhun YILDIZ. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var interestTextField: UITextField!
    
    var data:[String] = ["Seçiniz","Kadın","Erkek"] //Picker View Elemanlarımız
    var current_username: String?
    
    var imagePicker = UIImagePickerController()
    //Pickerviewlar
    var genderPickerView = UIPickerView()
    var interestPickerView = UIPickerView()
    
    //Seçilen değerleri değişkende tutmak
    var selectedGender:String?
    var selectedInterest:String?
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = current_username
        profileImage.setRounded()
        
        imagePicker.delegate = self
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        interestPickerView.delegate = self
        interestPickerView.dataSource = self
        
        genderPickerView.tag = 1
        interestPickerView.tag = 2
        
        genderTextField.inputView = genderPickerView
        interestTextField.inputView = interestPickerView
        
        doneButton()
        self.errorLabel.isHidden = true
        
        if let currentUser = PFUser.current(){
            if let gender = currentUser["gender"]{
                genderTextField.text = gender as? String
            }
            if let interest = currentUser["interest"]{
                interestTextField.text = interest as? String
            }
            
            if let photo = currentUser["profilePhoto"] as? PFFileObject{
                photo.getDataInBackground { (data, error) in
                    if let myImageData = data{
                        if let image = UIImage(data: myImageData){
                            self.profileImage.image = image
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func changeImage(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "Profil Resmi", message: "Resim Seçiniz", preferredStyle: .actionSheet) //Alttan çıkan uyarı barı
        
        let pictureGallery = UIAlertAction(title: "Resimler", style: .default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum){
                self.imagePicker.sourceType = UIImagePickerController.SourceType.savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)//kapanması
            }
        }
        
        let camera = UIAlertAction(title: "Kamera", style: .default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true, completion: nil)//kapanması
            }
        }
        
        actionSheet.addAction(pictureGallery)
        actionSheet.addAction(camera)
        actionSheet.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    //Profil resmini anlık değiştiriyoruz, veritabanına kaydetmiyoruz!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            profileImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //PickerView Metodları
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 //PickerView'da gözükecek olan bileşen sayısı
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count //İçindeki veri sayısı
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row] //Satırlarda gözükecek olan elemanlar
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1{ //Hangi pickerView seçildi.
            selectedGender = data[row]
            genderTextField.text = selectedGender //Seçilen değer textfielda yazıldı.
        }else if pickerView.tag == 2{
            selectedInterest = data[row]
            interestTextField.text = selectedInterest
        }else{
            return
        }
    }
    
    //Bitti butonu için gerekli işlemler
    func doneButton(){
        let toolBar = UIToolbar()//ToolBar nesnesi oluşturuldu.
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Bitti", style: .plain, target: self, action: #selector(dismissPicker))
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        genderTextField.inputAccessoryView = toolBar
        interestTextField.inputAccessoryView = toolBar
        
    }
    
    @objc func dismissPicker(){
        view.endEditing(true) //İşlem bittiğinde kapat
    }
    
    @IBAction func save(_ sender: Any) {
        PFUser.current()?["gender"] = self.selectedGender
        PFUser.current()?["interest"] = self.selectedInterest
        
        if let image = profileImage.image{
            if let imageData = image.pngData(){
                PFUser.current()?["profilePhoto"] = PFFileObject(name: "photo.png", data: imageData)
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if error != nil{
                        if let saveError = error as NSError?{
                            if let errorDetail = saveError.userInfo["error"] as? String{
                                self.errorLabel.isHidden=false
                                self.errorLabel.text=errorDetail
                            }
                        }
                    }else{
                        print("Profil guncelleme basarılı")
                        let swipeVC = self.storyboard?.instantiateViewController(withIdentifier: "SwipeVC") as! ViewController
                        self.present(swipeVC, animated: true, completion: nil)
                    }
                })
            }
        }
        
        
        
    }
    
}

extension UIImageView {
    func setRounded() {
        self.layer.cornerRadius = 25
        self.layer.masksToBounds = true
    }
}
