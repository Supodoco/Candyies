//
//  LoginController.swift
//  Candyies
//
//  Created by Supodoco on 15.09.2022.
//

import UIKit
import ParseSwift

class LoginController: UIViewController {
    
    var textFieldUsername = UITextField()
    var textFieldPassword = UITextField()
    var indicatorSignup = UIActivityIndicatorView()
    
    
    let buttonRegister: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGreen.cgColor
        button.setTitle("Регистрация", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    let labelNameOfApp: UILabel = {
        let label = UILabel()
        label.text = "Candyies".uppercased()
        label.textColor = .black
        label.font = UIFont(name: "PhosphateInline", size: 42)
        return label
    }()
    lazy var buttonLogin: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(buttonLoginTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Войти"
        textFieldUsername.text = "Qwertyas"
        textFieldPassword.text = "12345678"
        view.backgroundColor = .white
        labelNameOfAppMakeConstraints()
        textFieldsMakeConstraints()
        textFieldUsername.configure(placeholder: "Почта", imgName: "envelope")
        textFieldPassword.configure(placeholder: "Пароль", imgName: "lock.shield")
        textFieldPassword.isSecureTextEntry = true
        
//        buttonLoginConfigure()
        buttonsMakeConstraints()
        buttonRegister.addTarget(self, action: #selector(buttonRegisterTapped), for: .touchUpInside)
        buttonLogin.addTarget(self, action: #selector(buttonLoginTapped), for: .touchUpInside)

        
    }
    func buttonLoginConfigure() {
        buttonLogin.backgroundColor = .systemGreen
        buttonLogin.setTitle("Войти", for: .normal)
        buttonLogin.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        buttonLogin.setTitleColor(.white, for: .normal)
        buttonLogin.layer.cornerRadius = 8
    }
    
    @objc func buttonLoginTapped() {
        print("Tap login")
        
        signin()
        
    }
    @objc func buttonRegisterTapped() {
        print("Tap reg")
        signup()
    }
        
    func labelNameOfAppMakeConstraints() {
        view.addSubview(labelNameOfApp)
        labelNameOfApp.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelNameOfApp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelNameOfApp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            labelNameOfApp.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    func textFieldsMakeConstraints() {
        view.addSubview(textFieldUsername)
        view.addSubview(textFieldPassword)
        
        textFieldUsername.translatesAutoresizingMaskIntoConstraints = false
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textFieldUsername.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldUsername.topAnchor.constraint(equalTo: labelNameOfApp.bottomAnchor, constant: 40),
            textFieldUsername.widthAnchor.constraint(equalToConstant: 270),
            textFieldUsername.heightAnchor.constraint(equalToConstant: 45),
            
            textFieldPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textFieldPassword.topAnchor.constraint(equalTo: textFieldUsername.bottomAnchor, constant: 20),
            textFieldPassword.widthAnchor.constraint(equalToConstant: 270),
            textFieldPassword.heightAnchor.constraint(equalToConstant: 45)
        ])
        
    }
    func buttonsMakeConstraints() {
        buttonLogin.translatesAutoresizingMaskIntoConstraints = false
        buttonRegister.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(buttonLogin)
        view.addSubview(buttonRegister)
        
        
        NSLayoutConstraint.activate([
            buttonLogin.leadingAnchor.constraint(equalTo: textFieldPassword.leadingAnchor),
            buttonLogin.widthAnchor.constraint(equalToConstant: 110),
            buttonLogin.heightAnchor.constraint(equalToConstant: 45),
            buttonLogin.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 30),
            
            buttonRegister.trailingAnchor.constraint(equalTo: textFieldPassword.trailingAnchor),
            buttonRegister.widthAnchor.constraint(equalToConstant: 140),
            buttonRegister.heightAnchor.constraint(equalToConstant: 45),
            buttonRegister.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 30)
        ])
    }
    
    func signin() {
        guard let username = textFieldUsername.text,
              let password = textFieldPassword.text else { return }
        User.login(username: username, password: password) { results in
            
            switch results {
            case .success(let user):

                guard let currentUser = User.current else {
                    assertionFailure("Error: current user currently not stored locally")
                    return
                }

                if !currentUser.hasSameObjectId(as: user) {
                    assertionFailure("Error: these two objects should match")
                } else {
                    print("Successfully signed up user \(user)")
                    print("address: \(user.address ?? "")")
                }

            case .failure(let error):
                print("Error signing up \(error.description)")
            }
        }

    }
    
    func signup() {
        guard let username = textFieldUsername.text,
              let password = textFieldPassword.text else { return }
        guard password.count >= 8 else { print("password too short"); return }
        guard username.count >= 8 else { print("username too short"); return }
//        self.indicatorSignup.startAnimating()
        User.signup(username: username, password: password) { results in
            
            switch results {
            case .success(let user):
                
                guard let currentUser = User.current else {
                    assertionFailure("Error: current user currently not stored locally")
                    return
                }
                
                if !currentUser.hasSameObjectId(as: user) {
                    assertionFailure("Error: these two objects should match")
                } else {
                    print("Successfully signed up user \(user)")
                }
                
            case .failure(let error):
                assertionFailure("Error signing up \(error)")
            }
        }
    }
    
    func logout() {
        do {
            try User.logout()
            print("LogOut success")
        } catch {
            print("Error")
        }
    }
    
    func displayAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
}

struct User: ParseUser {
    
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    //: These are required by `ParseUser`.
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String: [String: String]?]?

    //: Your custom keys.
//    var customKey: String?
    var address: String?
        
}


extension UITextField {
    func configure(placeholder: String, imgName: String) {
        self.borderStyle = .roundedRect
        self.placeholder = placeholder
        self.layer.borderColor = UIColor.systemGreen.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 8
        let viewer = UIView()
        viewer.frame = CGRect(x: 0, y: 0, width: 35, height: 45)
        let imageView = UIImageView(image: UIImage(systemName: imgName)?.withTintColor(.black, renderingMode: .alwaysOriginal))
        imageView.contentMode = .center
        imageView.frame = CGRect(x: 5, y: 0, width: 35, height: 45)
        self.leftViewMode = .always
        viewer.addSubview(imageView)
        self.leftView = viewer
    }
}
