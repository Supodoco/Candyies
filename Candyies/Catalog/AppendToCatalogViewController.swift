//
//  AppendToCatalogViewController.swift
//  Candyies
//
//  Created by Supodoco on 06.10.2022.
//

import UIKit

class AppendToCatalogViewController: UIViewController {
    
    let images = (0...15).map({ "img" + "\($0)"})
    var selectedImage = "img0"

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var imageView: UIImageView! {
        didSet {
            if let _ = cellData {
                imageView.image = cellData.image
            }
        }
    }
    @IBOutlet var imagePicker: UIPickerView!
    @IBOutlet var imageLinkTF: UITextField!
    
    @IBOutlet var titleTF: UITextField!
    @IBOutlet var priceTF: UITextField!
    @IBOutlet var weightTF: UITextField!
    
    @IBOutlet var categorySegmentControl: UISegmentedControl!
    @IBOutlet var descriptionTextView: UITextView!
    
    @IBOutlet var updateButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    var cellData: CatalogModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = cellData {
            updateButton.setTitle("Обновить", for: .normal)
            updateButton.tintColor = .systemGreen
            titleLabel.text = "Редактирование товара"
            
            if cellData.imageDescription.hasPrefix("http") {
                imageLinkTF.text = cellData.imageDescription
            } else {
                selectedImage = cellData.imageDescription
            }
            titleTF.text = cellData.title
            priceTF.text = String(cellData.price)
            weightTF.text = String(cellData.weight)
            categorySegmentControl.selectedSegmentIndex = cellData.sales ? 0 : 1
            descriptionTextView.text = cellData.description
        } else {
            deleteButton.isHidden = true
        }
        descriptionTextView.layer.cornerRadius = 8
        imagePicker.delegate = self
        imagePicker.dataSource = self
        imageView.image = UIImage(named: selectedImage)
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        addDoneButtonOnKeyboard()
        
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        if view.frame.origin.y == 0 {
            view.frame.origin.y -= keyboardSize.height
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        titleTF.inputAccessoryView = doneToolbar
        priceTF.inputAccessoryView = doneToolbar
        weightTF.inputAccessoryView = doneToolbar
        imageLinkTF.inputAccessoryView = doneToolbar
        descriptionTextView.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        titleTF.resignFirstResponder()
        priceTF.resignFirstResponder()
        weightTF.resignFirstResponder()
        imageLinkTF.resignFirstResponder()
        descriptionTextView.resignFirstResponder()
    }
    @IBAction func sendUpdateButtonTapped() {
        guard let image = imageLinkTF.text == "" ? selectedImage : imageLinkTF.text,
              let title = titleTF.text,
              let price = Int(priceTF.text!),
              let weight = Int(weightTF.text!),
              let description = descriptionTextView.text
        else {
            customAlertShow(
                title: "Ошибка",
                message: "Некоторые поля заполнены неверно или пусты",
                cancelAction: false)
            return
        }
        let sales = categorySegmentControl.selectedSegmentIndex == 0 ? true : false

        if updateButton.tintColor == .systemGreen {
            CatalogService.shared.updateHandler(loadingModel: LoadingModel(
                image: image,
                title: title,
                weight: weight,
                price: price,
                description: description,
                sales: sales,
                id: cellData.id)) {
                    self.customAlertShow(
                        title: "Текущий товар",
                        message: "Обновить информацию о товаре?") {
                        self.dismiss(animated: true)
                    }
                }
        } else {
            CatalogService.shared.postHandler(
                image: image,
                title: title,
                price: price,
                weight: weight,
                sales: sales,
                description: description) {
                    self.customAlertShow(
                        title: "Новый товар",
                        message: "Добавить новый товар?") {
                        self.dismiss(animated: true)
                    }
                }
        }
        
        
    }
    @IBAction func deleteButtonTapped() {
        CatalogService.shared.deleteHandler(id: cellData.id) {
            self.customAlertShow(
                title: "Выбранный товар",
                message: "Удалить выбранный товар?") {
                self.dismiss(animated: true)
            }
        }
        
    }
    func customAlertShow(title: String, message: String, cancelAction: Bool = true, action: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertActionOk = UIAlertAction(title: "OK", style: .default) { _ in
            action?()
        }
        let alertActionCancel = UIAlertAction(title: "Отмена", style: .cancel)
        if cancelAction {
            alert.addAction(alertActionCancel)
        }
        alert.addAction(alertActionOk)
        self.present(alert, animated: true)
    }
}

extension AppendToCatalogViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        images.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        images[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        imageView.image = UIImage(named: images[row])
        selectedImage = images[row]
    }
}
