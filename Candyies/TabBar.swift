//
//  TabBar.swift
//  Candyies
//
//  Created by Supodoco on 04.09.2022.
//

import UIKit

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black
        for i in 0...4 {
            tabBar.items![i].selectedImage = tabBar.items![i].selectedImage!.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        }
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
