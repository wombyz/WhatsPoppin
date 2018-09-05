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
import FacebookCore

class CreateEventVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
//    var Events = [Event]()
    var buttonPressed = false
    var imagePicker = UIImagePickerController()
//    var myEvent: Event!
    var eID = 0
    var coord: CLLocationCoordinate2D!
    var tableView = UITableView()
    var resultSearchController:UISearchController? = nil
    var userAddress: String! = nil
    var passedMapView: MKMapView! = nil
    let locationManager = CLLocationManager()
    
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
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search For Party Address"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = passedMapView
        locationSearchTable.textField = addressLbl
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
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//            }
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
        var addressCoordinate: String!
        let uuid = UUID().uuidString
        print(uuid)
        userAddress = addressLbl.text
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(userAddress) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    print(error as Any)
                    return
            }
            print("location below")
            print(location)
            
            let coordinate = location.coordinate
            
            let eventData = ["creator": AccessToken.current?.userId, "title": self.eventNameLbl.text, "description": self.descLbl.text, "suburb": self.suburbLbl.text, "eventType": self.eventTypeBtn.title(for: .normal), "gender": self.genderBtn.title(for: .normal), "address": self.addressLbl.text, "eventIsPublic": true, "uid": "\(uuid)"] as [String: Any]
                
                DataService.instance.createEvent(uid: uuid, eventData: eventData)
                DataService.instance.REF_EVENTS.child(uuid).updateChildValues(["coordinate": [coordinate.latitude, coordinate.longitude]])
//
//            } else {
//                print("no location...")
            }
        
        dismiss(animated: true, completion: nil)
        //image???
    }
    
    @IBAction func dismissCreateVC(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
