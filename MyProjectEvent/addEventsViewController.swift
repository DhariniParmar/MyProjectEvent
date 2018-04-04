//
//  addEventsViewController.swift
//  MyProjectEvent
//
//  Created by Student on 2018-04-03.
//  Copyright © 2018 Student. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

protocol addEventsVCDelegate: class {
    
    func EventsVCDidCancel()
    func EventsVC(_ control: addEventsViewController, didFinishAdd event: Event)
    func EventsVC(_ control: addEventsViewController, didFinishEdit  event: Event)
}

class addEventsViewController: UITableViewController, CLLocationManagerDelegate  {
    
    var managedObjectContext: NSManagedObjectContext!
    var pic: UIImage?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var eventNameTextField: UITextField!
    
   
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var eventLocationTextField: UITextField!
    
    @IBOutlet weak var addImage: UILabel!
    
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var CategoryLabel: UILabel!
    
    @IBOutlet var datePickerCell: UITableViewCell!
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var datePickerLabel: UILabel!
    
    @IBOutlet weak var latitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    
    weak var delegate: addEventsVCDelegate?
    
     var event:Event?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectCategory" {
            let controller = segue.destination as! CategorySelectViewController
            controller.selectedCategory = CategoryLabel.text!
        }
    }

    
    @IBAction func forwardGeoCodingToGPS(_ sender: Any) {
        
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString((eventLocationTextField.text)!, completionHandler: {
            placemarks, error in
            print("Found the location: \(String(describing: placemarks))")
            if let placemark = placemarks?.last {
                if  let latitude = placemark.location?.coordinate.latitude,
                    let longitude = placemark.location?.coordinate.longitude {
                    self.latitudeTextField.text = "\(String(describing: latitude))"
                    self.longitudeTextField.text = "\(String(describing: longitude))"
                    
                    
                }
            }
        })
        
    }
    
    var editEvent : Bool = false
    
    @IBAction func done(_ sender: Any) {
        
        event = Event(context: managedObjectContext)
    
        event!.eventName = eventNameTextField.text
        event!.eventLocation = eventLocationTextField.text
        
        if let image = pic {
            if (event?.hasPhoto)!{
                event?.imageId = Event.nextImageId() as NSNumber
            }
            if let data = UIImageJPEGRepresentation(image,  0.5) {
                do {
                    print("URL")
                } catch {
                    print("Photo saving error")
                }
            }
        }
        do {
            try managedObjectContext.save()
        } catch {
            print("Core Data Error")
        }
        navigationController?.popViewController(animated: true)
       
//        if !editEvent {
//            event = Event(context: managedObjectContext)
//        }
//        event!.eventName = eventNameTextField.text
//        event!.eventLocation = eventLocationTextField.text
//        do {
//            try managedObjectContext.save()
//        } catch {
//            print("Core Data Error")
//        }
//        if editEvent {
//            delegate?.EventsVC(self, didFinishEdit : event!)
//        } else {
//            delegate?.EventsVC(self, didFinishAdd : event!)
//        }
//        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //    let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

      //  return cell
        if indexPath.row == 3 {
            return datePickerCell
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    

    @IBAction func dateChanged(_ sender: Any) {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        datePickerLabel.text = formatter.string(from: datePicker.date)
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row==2{
            pickPhoto()
        } else {
            
        }
    }
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            showPhotoPickMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func showPhotoPickMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actCancel)
        let actPhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
        })
        alert.addAction(actPhoto)
        let actLibrary = UIAlertAction(title: "Choose From Library", style: .default, handler: { _ in
            self.choosePhotoFromLibrary() 
        })
        alert.addAction(actLibrary)
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView,
                            heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 2{
            if imageView.isHidden {
                return 44
            } else {
                return 280 }
        } else  {
            
        }
        return 88
}
}

extension addEventsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //grab the image returned
        //put the image in the tablecell imageView
        //tabel.reloaddata()
        let img = info[UIImagePickerControllerEditedImage] as! UIImage
        pic = img
        imageView.image = img
        imageView.frame = CGRect(x: 10, y: 5, width: 260, height: 260)
        imageView.autoresizesSubviews = true
        dismiss(animated: true, completion: nil)
    }
}


