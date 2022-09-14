//
//  Cart.swift
//  Candyies
//
//  Created by Supodoco on 04.09.2022.
//

import UIKit

class Cart: UIViewController {

    let labelCart = UILabel()
    let tableView = UITableView()
    let buttonTrash = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelCartConfigure()
        labelMakeConstraints()
        
        buttonTrashConfigure()
        buttonTrashMakeConstraints()
        
        tableViewConfigure()
        tableViewMakeConstraints()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func buttonTrashConfigure() {
        buttonTrash.setImage(UIImage(systemName: "trash")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        buttonTrash.addTarget(self, action: #selector(clearCart), for: .touchUpInside)
    }
    
    func buttonTrashMakeConstraints() {
        buttonTrash.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonTrash)
        NSLayoutConstraint.activate([
            buttonTrash.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonTrash.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15)
        ])
    }
    @objc func clearCart() {
        Singleton.shared.clearCart()
        let duration = 0.15
        UIView.animate(withDuration: duration, delay: 0) {
            self.buttonTrash.transform = CGAffineTransform(rotationAngle: .pi/6)
        }
        UIView.animate(withDuration: duration * 2, delay: duration) {
            self.buttonTrash.transform = CGAffineTransform(rotationAngle: -.pi/6)
        }
        UIView.animate(withDuration: duration, delay: duration * 3) {
            self.buttonTrash.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        tableView.reloadData()
    }

    func tableViewConfigure() {
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.identifier)
        tableView.register(BuyCell.self, forCellReuseIdentifier: BuyCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none

    }
    func tableViewMakeConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 22, right: 0)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: labelCart.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    func labelCartConfigure() {
        labelCart.text = Titles.cart.rawValue
        labelCart.font =  UIFont.systemFont(ofSize: 23, weight: .bold)
    }
    func labelMakeConstraints() {
        labelCart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelCart)
        NSLayoutConstraint.activate([
            labelCart.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            labelCart.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            labelCart.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    @objc func plusOne(sender: UITapGestureRecognizer) {
        let position = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: position) {
            if Singleton.shared.cartArray[indexPath.row].amount < 30 {
                let t = Singleton.shared.cartArray[indexPath.row]
                for i in Singleton.shared.cart {
                    if t == i.value {
                        Singleton.shared.data[i.key]?.amount += 1
                    }
                }
            }
            tableView.reloadData()
        }
    }
    
    @objc func minusOne(sender: UITapGestureRecognizer) {
        let position = sender.location(in: tableView)
        if let indexPath = tableView.indexPathForRow(at: position) {
            let t = Singleton.shared.cartArray[indexPath.row]
            for i in Singleton.shared.cart {
                if t == i.value {
                    Singleton.shared.data[i.key]?.amount -= 1
                }
            }
            tableView.reloadData()
        }
    }
    
    @objc func buy(sender: UITapGestureRecognizer) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let buyPage = storyboard.instantiateViewController(identifier: "BuyPage") as? BuyPage else { return }
        present(buyPage, animated: true)
    }
    
    func deliveryCount() -> Int {
        Singleton.shared.cartTotalPrice > Singleton.shared.freeDeliveryMinSum
        ? Singleton.shared.delivery.free : Singleton.shared.delivery.cost
    }
}

extension Cart: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if Singleton.shared.cart.isEmpty {
            let cell = UITableViewCell()
            let label: UILabel = {
                let label = UILabel()
                label.text = "Ваша корзина пуста"
                label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
                return label
            }()
            
            cell.addSubview(label)
            label.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 + 30, width: 200, height: 50)
            if let confettiImageView = UIImageView.fromGif(
                    frame: CGRect(
                        x: view.frame.width / 2 - 100,
                        y: view.frame.height / 2 - 200,
                        width: 200, height: 200),
                    resourceName: "hungry"
            ) {
                cell.addSubview(confettiImageView)
                confettiImageView.animationDuration = 1.3
                confettiImageView.startAnimating()
            }
            tableView.isScrollEnabled = false
            return cell
        }
        
        if indexPath.row < Singleton.shared.cart.count {
            tableView.isScrollEnabled = true
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ItemCell.identifier,
                for: indexPath) as? ItemCell else { return UITableViewCell() }
            print("indexPath --- \(indexPath.row)")
            cell.image.image = Singleton.shared.cartArray[indexPath.row].image
            cell.labelCost.text = String(Singleton.shared.cartArray[indexPath.row].price * Singleton.shared.cartArray[indexPath.row].amount) + " ₽"
            cell.labelName.text = Singleton.shared.cartArray[indexPath.row].name
            cell.buttonsMinus = CatalogCustomCell().buttonConfigure(cell.buttonsMinus, setTitle: "-")
            cell.buttonPlus = CatalogCustomCell().buttonConfigure(cell.buttonPlus, setTitle: "+")
            cell.buttonCounter.setTitle("\(Singleton.shared.cartArray[indexPath.row].amount)", for: .normal)
            cell.buttonCounter.setTitleColor(UIColor.black, for: .normal)
            
            
            let gesturePlus = UITapGestureRecognizer(
                target: self,
                action: #selector(plusOne(sender:))
            )
            cell.buttonPlus.addGestureRecognizer(gesturePlus)
            
            let gestureMinus = UITapGestureRecognizer(
                target: self,
                action: #selector(minusOne(sender:))
            )
            cell.buttonsMinus.addGestureRecognizer(gestureMinus)
            
            return cell
        } else if indexPath.row == Singleton.shared.cart.count {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: BuyCell.identifier,
                for: indexPath) as? BuyCell
            else { return UITableViewCell() }

            cell.labelCost.text = "\(deliveryCount()) ₽"
            cell.buttonConfigure(.white)
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: BuyCell.identifier,
                for: indexPath) as? BuyCell
            else { return UITableViewCell() }

            cell.labelCost.text = "\(Singleton.shared.cartTotalPrice + deliveryCount()) ₽"
            cell.buttonConfigure(.systemGreen)
            
            let gestureBuy = UITapGestureRecognizer(
                target: self,
                action: #selector(buy(sender:))
            )
            cell.addGestureRecognizer(gestureBuy)
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if Singleton.shared.cart.isEmpty  {
            return 1
        } else {
            return Singleton.shared.cart.count + 2
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < Singleton.shared.cart.count {
            return 130
        } else {
            return 60
        }
    }
}

