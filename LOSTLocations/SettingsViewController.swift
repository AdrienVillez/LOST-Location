//
//  SettingsViewController.swift
//  LOSTLocations
//
//  Created by Adrien Villez on 9/9/17.
//  Copyright © 2017 AdrienVillez. All rights reserved.
//

import UIKit
import AVFoundation
import Crashlytics

class SettingsViewController: UIViewController
{
    // @IBOutlet weak var emailUsButton: UIButton!
    @IBOutlet weak var numbersButton: UIButton!
    
    private let webViewControllerID: String = "WebViewController"
        
    let secretNumber: Int = 4
    var audioPlayer = AVAudioPlayer()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // emailUsButton.layer.cornerRadius = 8.0
        
        // sound file.
        let sound = Bundle.main.path(forResource: "smokeloop", ofType: "wav")
        // copy this syntax, it tells the compiler what to do when action is received
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
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
    
    @IBAction func privacyPolicyTapped(_ sender: UIButton) {
        // Send the user to the privacy policy website.
        
        // Creates an instance of webViewController and check that it isn't nil.
        let webViewViewController = storyboard?.instantiateViewController(withIdentifier: webViewControllerID) as? WebViewController
        guard let _ = webViewViewController else
        {
            return
        }
        
        // Sets the presentation mode:
        webViewViewController!.modalPresentationStyle = .popover
        webViewViewController!.modalTransitionStyle = .coverVertical
        present(webViewViewController!, animated: true, completion: nil)
    }
    
}
