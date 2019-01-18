//
//  EmbededSettingsViewController.swift
//  LOSTLocations
//
//  Created by Adrien Villez on 9/24/18.
//  Copyright © 2018 AdrienVillez. All rights reserved.
//

import UIKit
import MessageUI

class EmbededSettingsViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var analyticsSwitch: UISwitch!
    @IBOutlet weak var analyticsLabel: UIButton!
    
    var mailComposer: MFMailComposeViewController?
    
    private let contactEmail: String = "avstudioapp@gmail.com"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // Manages how the Analytics Switch is deplayed at launch following its status:
        analyticsAreDisabled = UserDefaults.standard.bool(forKey: Helper.Defaults().AnalyticsDisabled)
        print("Settings view did appear and the analyticsAreDisabled is set as: \(analyticsAreDisabled)")
        if analyticsAreDisabled == true {
            analyticsSwitch.isOn = false
            print("Screen loaded, analytics are disabled, switch is off.")
        } else {
            analyticsSwitch.isOn = true
            print("Screen loaded, analytics are not disabled, switch is on.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        analyticsLabel.isUserInteractionEnabled = false
    }
    
    // MARK: - @IBActions
    @IBAction func rateAndReviewTapped(_ sender: UIButton) {
        let appleID = "1286799669"
        let appStoreLink = "https://itunes.apple.com/app/id\(appleID)?action=write-review"
        UIApplication.shared.open(URL(string: appStoreLink)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func analyticsSwitched(_ sender: UISwitch) {
        
        if sender.isOn {
            print("User turns the analytics switch on, saving UserDefaults as on.")
            UserDefaults.standard.set(false, forKey: Helper.Defaults().AnalyticsDisabled)
            analyticsAreDisabled = false
        } else {
            print("User turns the analytics swift off, saving UserDefaults as off")
            UserDefaults.standard.set(true, forKey: Helper.Defaults().AnalyticsDisabled)
            analyticsAreDisabled = true
        }
    }
    
    
    @IBAction func contactUsButtonTapped(_ sender: UIButton) {
        
        print("Contact Us Button Tapped!")
        
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


