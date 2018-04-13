//
//  SettingsViewController.swift
//  LOSTLocations
//
//  Created by Adrien Villez on 9/9/17.
//  Copyright © 2017 AdrienVillez. All rights reserved.
//

import UIKit
import AVFoundation
import MessageUI
import Crashlytics

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate
{

    @IBOutlet weak var emailUsButton: UIButton!
    @IBOutlet weak var numbersButton: UIButton!
    
    private let contactEmail: String = "avstudioapp@gmail.com"
    
    let secretNumber: Int = 4
    var audioPlayer = AVAudioPlayer()
    var mailComposer: MFMailComposeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailUsButton.layer.cornerRadius = 4.0
        
        // sound file.
        let sound = Bundle.main.path(forResource: "smokeloop", ofType: "wav")
        // copy this syntax, it tells the compiler what to do when action is received
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
            try AVAudioSession.sharedInstance().setActive(true)
        }
        catch{
            print(error)
        }

    }


    @IBAction func exitViewControllerButtonTapped(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func sendEmailTapped(_ sender: UIButton)
    {
        if MFMailComposeViewController.canSendMail()
        {
            self.mailComposer = MFMailComposeViewController()
            
            self.mailComposer?.mailComposeDelegate = self
            
            self.mailComposer?.setToRecipients([contactEmail])
            self.mailComposer?.setSubject("Hello, I have some feedbacks for the Locations app.")
            
            self.present(self.mailComposer!, animated: true, completion: nil)
        }
        else
        {
            // User doesn't have any email account set, display an alert.
            let errorAlert = UIAlertController(title: nil, message: "No email account has been set up on this device.  Check your settings and press the 'Email Us' button again.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            errorAlert.addAction(okAction)
            present(errorAlert, animated: true, completion: nil)
        }
    }
    
    // Easter Egg:
    @IBAction func numbersButtonTapped(_ sender: UIButton)
    {
        print("Numbers were pressed.")
        
        let randomNumber: Int = Int(arc4random_uniform(30))
        
        if randomNumber == secretNumber
        {
            print("Playing the audio successfully.")
            audioPlayer.play()
            
            // Disabling the numbers button:
            numbersButton.isUserInteractionEnabled = false
            
            UIView.animate(withDuration: 2.0, delay: 2.0, options: .curveEaseOut, animations: {
                
                // Animation
                self.numbersButton.alpha = 0.0
                
            }, completion: { finished in
                UIView.animate(withDuration: 2.0, delay: 3, options: .curveEaseOut, animations: {
                    
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyMMdd:HHmm"
                    let convertedDate = dateFormatter.string(from: date)
                    
                    self.numbersButton.setTitleColor(UIColor.red, for: .normal)
                    self.numbersButton.setTitle("\(convertedDate) SYSTEM FAILURE", for: .normal)
                    
                    self.numbersButton.alpha = 1.0
                    
                }, completion: { finished in
                    UIView.animate(withDuration: 2.0, delay: 3, options: .curveEaseOut, animations: {
                        
                        self.numbersButton.alpha = 0.0
                        
                    }, completion: { finished in
                        
                    })
                })
            })
        }
        else
        {
            return
        }
    }
    
    
    // MARK: - MailComposerDelegate Methods
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        switch result.rawValue {
        case MFMailComposeResult.sent.rawValue:
            print("Email was sent.")
        case MFMailComposeResult.cancelled.rawValue:
            print("Email was cancelled.")
        case MFMailComposeResult.failed.rawValue:
            print("Email failed.")
        default:
            print("Email failed with the following error: \(error!).")
        }
        
        // The VC has to be dismissed:
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
