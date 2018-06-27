//
//  CreateEventVC.swift
//  WhatsPoppin
//
//  Created by Liam Ottley on 7/06/18.
//  Copyright © 2018 Liam Ottley. All rights reserved.
//

import UIKit
import PhotosUI
import Photos
import NotificationCenter
import CoreLocation
import Firebase
import MapKit

class CreateEventVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
//    var Events = [Event]()
    var buttonPressed = false
    var imagePicker = UIImagePickerController()
//    var myEvent: Event!
    var eID = 0
    var coord: CLLocationCoordinate2D!
    var tableView = UITableView()
    var resultSearchController:UISearchController? = nil
    
    var passedMapView: MKMapView! = nil
    
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var eventNameLbl: UITextView!
    @IBOutlet weak var descLbl: UITextView!
    @IBOutlet weak var ageRangeLbl: UITextField!
    @IBOutlet weak var suburbLbl: UITextField!
    @IBOutlet weak var eventTypeBtn: UIButton!
    @IBOutlet weak var genderBtn: UIButton!
    @IBOutlet weak var ageRange: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var suburb: UILabel!
    @IBOutlet weak var eventType: UILabel!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var selectImgBtn: UIButton!
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var addressLbl: UITextField!
    @IBOutlet weak var address: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typePicker.dataSource = self
        typePicker.delegate = self
        thumbImg.layer.cornerRadius = thumbImg.frame.size.width/2
        thumbImg.clipsToBounds = true
        descLbl.delegate = self
        ageRangeLbl.delegate = self
        suburbLbl.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(CreateEventVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CreateEventVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    func hideOrRemoveFieldsForPickerView() {
        // if the picker view is there, hide all others
        if typePicker.isHidden == false {
            eventTypeBtn.isHidden = true
            genderBtn.isHidden = true
            suburbLbl.isHidden = true
            ageRangeLbl.isHidden = true
            ageRange.isHidden = true
            gender.isHidden = true
            suburb.isHidden = true
            eventType.isHidden = true
            createBtn.isHidden = true
            cancelBtn.isHidden = true
            addressLbl.isHidden = true
            address.isHidden = true
        } else {
            eventTypeBtn.isHidden = false
            genderBtn.isHidden = false
            suburbLbl.isHidden = false
            ageRangeLbl.isHidden = false
            ageRange.isHidden = false
            gender.isHidden = false
            suburb.isHidden = false
            eventType.isHidden = false
            createBtn.isHidden = false
            cancelBtn.isHidden = false
            addressLbl.isHidden = false
            address.isHidden = false
            
        }
        
    }
    
    @IBAction func genTypePickerBtnPressed(sender: AnyObject) {
        typePicker.isHidden = false
        hideOrRemoveFieldsForPickerView()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) ->Int{
        
        if buttonPressed == true {
            return genders.count
        } else if buttonPressed == false {
            return eventTypes.count
        } else {
            return 1
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if buttonPressed == true {
            return genders[row]
        } else if buttonPressed == false {
            return eventTypes[row]
        } else {
            return "nil"
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if buttonPressed == true {
            genderBtn.isHidden = false
            genderBtn.setTitle("\(genders[row])", for: .normal)
            typePicker.isHidden = true
            
        } else if buttonPressed == false {
            eventTypeBtn.isHidden = false
            eventTypeBtn.setTitle("\(eventTypes[row])", for: .normal)
            typePicker.isHidden = true
        }
        hideOrRemoveFieldsForPickerView()
        print(buttonPressed)
    }
    
    
    @IBAction func genderButtonPressed(_ sender: UIButton) {
        typePicker.isHidden = false
        buttonPressed = true
        hideOrRemoveFieldsForPickerView()
        print(buttonPressed)
    }
    
    @IBAction func eventTypeButtonPressed(_ sender: UIButton) {
        typePicker.isHidden = false
        buttonPressed = false
        hideOrRemoveFieldsForPickerView()
        print(buttonPressed)
    }
    
    
    @IBAction func selectImagePressed(_ sender: UIButton) {
        
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(image, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let theInfo: NSDictionary = info as NSDictionary
        let img: UIImage = theInfo.object(forKey: UIImagePickerControllerOriginalImage) as! UIImage
        
        thumbImg.image = img
        
        self .dismiss(animated: true, completion: nil)
        thumbImg.isHidden = false
        selectImgBtn.isHidden = true
        //        selectImgBtn.alpha = 0.0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        ageRangeLbl.resignFirstResponder()
        suburbLbl.resignFirstResponder()
        addressLbl.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
        self.view.frame.origin.y = 0
    }
    

    @IBAction func createBtnPressed(_ sender: UIButton){
        let uuid = UUID().uuidString
        print(uuid)
        let eventData = ["creator": Auth.auth().currentUser?.uid, "title": eventNameLbl.text, "description": descLbl.text, "suburb": suburbLbl.text, "eventType": eventTypeBtn.title(for: .normal), "gender": genderBtn.title(for: .normal)] as [String: Any]
        
        DataService.instance.createEvent(uid: uuid, eventData: eventData)
        
        //image???
    }
}

    
//    func performSearch() {
//        matchingItems.removeAll()
//        let request = MKLocalSearchRequest()
//        request.naturalLanguageQuery = destinationTextField.text
//        request.region = mapView.region
//        //pass search in
//        let search = MKLocalSearch(request: request)
//
//        search.start { (response, error) in
//            if error != nil {
//                self.showAlert("An error occurred please try again")
//            } else if response!.mapItems.count == 0 {
//                self.showAlert("no results, please search again for a different location!")
//            } else {
//                for mapItem in response!.mapItems {
//                    self.matchingItems.append(mapItem as MKMapItem)
//                    self.tableView.reloadData()
//                    self.shouldPresentLoadingView(false)
//                }
//            }
//        }
//    }
//}
//
//extension CreateEventVC: UITextFieldDelegate {
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//        if textField == destinationTextField {
//
//            tableView.frame = CGRect(x: 20, y: view.frame.height, width: view.frame.width - 40, height: view.frame.height - 170)
//            tableView.layer.cornerRadius = 5.0
//            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "loactionCell")
//
//            tableView.delegate = self
//            tableView.dataSource = self
//
//            tableView.tag = 18
//            tableView.rowHeight = 60
//
//            view.addSubview(tableView)
//            animateTableView(shouldShow: true)
//
//            UIView.animate(withDuration: 0.2, animations: {
//                self.destinationCircle.backgroundColor = UIColor.red
//                self.destinationCircle.borderColor = UIColor.init(red: 199/255, green: 0/255, blue: 0/255, alpha: 1.0)
//            })
//        }
//}
//
//extension CreateEventVC: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "locationCell")
//        let mapItem = matchingItems[indexPath.row]
//        cell.textLabel?.text = mapItem.name
//        cell.detailTextLabel?.text = mapItem.placemark.title
//        return cell
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return matchingItems.count
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        shouldPresentLoadingView(true)
//
//        let passenegerCoordinate = manager?.location?.coordinate
//
//        let passengerAnnotation = PassengerAnnotation(coordinate: passenegerCoordinate!, key: (currentUserId)
//            mapView.addAnnotation(passengerAnnotation)
//
//            destinationTextField.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
//
//        let selectedMapItem = matchingItems[indexPath.row]
//
//        DataService.instance.REF_USERS.child(currentUserId!).updateChildValues(["tripCoordinate": [selectedMapItem.placemark.coordinate.latitude, selectedMapItem.placemark.coordinate.longitude]])
//
//        dropPinFor(placemark: selectedMapItem.placemark)
//
//        searchMapKitForResultsWithPolyline(forMapItem: selectedMapItem)
//
//        animateTableView(shouldShow: false)
//        print("selected!")
//}
