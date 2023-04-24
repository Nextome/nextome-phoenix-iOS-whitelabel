//
//  SplashScreen.swift
//  nextome-phoenix-iOS-whitelabel
//
//  Created by Anna Labellarte on 29/03/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var settingsEditedImageView: UIImageView!
    
    let viewModel = LoginViewModel()
    let openMapSegue = "openMap"

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        viewModel.updateSettings()
        settingsEditedImageView.isHidden = !viewModel.settings.hasBeenEdited()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func onEnterClicked(_ sender: Any) {
        performSegue(withIdentifier: "openMap", sender: self)
    }
}
