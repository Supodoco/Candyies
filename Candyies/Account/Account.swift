//
//  Account.swift
//  Candyies
//
//  Created by Supodoco on 04.09.2022.
//

import UIKit

class Account: UIViewController {
    let switchToAdmin = UISwitch()

    override func viewDidLoad() {
        super.viewDidLoad()
        switchToAdmin.isOn = true
        switchToAdmin.frame = CGRect(x: 50, y: 300, width: 120, height: 50)
        switchToAdmin.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        view.addSubview(switchToAdmin)
        
    }
    @objc func tapped() {
//        navigationController?.show(LoginController(), sender: nil)
        if switchToAdmin.isOn {
            isAdminViewModel.shared.admin = true
        } else {
            isAdminViewModel.shared.admin = false
        }
        print(isAdminViewModel.shared.admin)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
