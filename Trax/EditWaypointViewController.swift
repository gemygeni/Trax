//
//  EditWaypointViewController.swift
//  Trax
//
//  Created by AHMED GAMAL  on 3/12/20.
//  Copyright © 2020 AHMED GAMAL . All rights reserved.
//

import UIKit

class EditWaypointViewController: UIViewController , UITextFieldDelegate{
    
    var waypointToEdit : EditableWaypoint? {
        didSet{
            updateUI()
        }
    }
    private func updateUI(){
        if nameTextfield != nil && InfoTextfield != nil {
          nameTextfield.text =  waypointToEdit?.name
          InfoTextfield.text =  waypointToEdit?.info
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        nameTextfield.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        ListenToTextfields()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if let observer = nameObserver{ NotificationCenter.default.removeObserver(observer)}
        if let observer = infoObserver{ NotificationCenter.default.removeObserver(observer)}
    }
    private var nameObserver : NSObjectProtocol?
    private var infoObserver : NSObjectProtocol?
    
    
   private func ListenToTextfields(){
    let center = NotificationCenter.default
    nameObserver =  center.addObserver(forName: UITextField.textDidChangeNotification,
        object: nameTextfield,
        queue: OperationQueue.main,
        using: { (notification) in
            if let waypoint = self.waypointToEdit {
                waypoint.name = self.nameTextfield.text
            }
    })
    infoObserver =  center.addObserver(forName: UITextField.textDidChangeNotification,
           object: InfoTextfield,
           queue: OperationQueue.main,
           using: { (notification) in
               if let waypoint =   self.waypointToEdit {
                   waypoint.info = self.InfoTextfield.text
               }
       })
    }
  //we made unwind segue insted of it
//    @IBAction func done(_ sender: UIBarButtonItem) {
//        presentingViewController?.dismiss(animated: true)
//    }
    
   
    
    
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var InfoTextfield: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
