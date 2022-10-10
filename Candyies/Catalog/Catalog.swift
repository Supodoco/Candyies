//
//  Catalog.swift
//  Candyies
//
//  Created by Supodoco on 04.09.2022.
//

import UIKit

class Catalog: UIViewController {
    
    // loading data
    private let catalogDataUrl = "https://pastebin.com/raw/an3SZrr1"
    private let salesDataUrl = "https://pastebin.com/raw/7L2K4fCK"
    
    var favorites = Array(repeating: 0, count: 15)
    
    // model
    let viewTotalSumAndDeliveryCost = UIView()
    let labelDelivery = UILabel()
    let labelTotalSum = UILabel()
    
    var collectionCatalog: UICollectionView?
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionCatalogConfigure()
        
        viewTotalSumAndDeliveryCostConfigure()
        viewTotalSumAndDeliveryCost.isHidden = true
        labelsConfigure()
        labelsMakeConstraints()
        modelConfigure()
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionCatalog?.addSubview(refreshControl)
    }
    @objc func refresh() {
        CatalogViewModel.shared.catalog = []
        modelConfigure()
        refreshControl.endRefreshing()
    }
    override func viewWillAppear(_ animated: Bool) {
        labelsConfigure()
        collectionCatalog?.reloadData()
        if CatalogViewModel.shared.cartTotalPrice == 0 {
            viewTotalSumAndDeliveryCost.isHidden = true
        }
        
    }
    
    private func collectionCatalogConfigure() {
        
        collectionCatalog = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        guard let collectionCatalog = collectionCatalog else { return }
        collectionCatalog.register(CatalogSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CatalogSectionHeader.identifier)
        collectionCatalog.register(CatalogCustomCell.self, forCellWithReuseIdentifier: CatalogCustomCell.identifier)
        collectionCatalog.dataSource = self
        collectionCatalog.delegate = self
        collectionCatalog.showsVerticalScrollIndicator = false
        view.addSubview(collectionCatalog)
        collectionCatalog.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionCatalog.backgroundColor = .white

        collectionCatalog.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionCatalog.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionCatalog.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionCatalog.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionCatalog.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        collectionCatalog.collectionViewLayout = createCompositionalLayout()
        
        
        
    }
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionIndex, env) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0: return self.firstLayoutSection()
            default: return self.secondLayoutSection()
            }
        }
    }
    
    private func firstLayoutSection() -> NSCollectionLayoutSection {
        
        var itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .absolute(view.frame.width / 2 + 90))
        if view.frame.width > 750 {
            itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                              heightDimension: .absolute(view.frame.width / 3 + 80))
        }
        print(view.frame.width / 10)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //        item.contentInsets.bottom = 15
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                               heightDimension: .estimated(500))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1),
                                  heightDimension: .estimated(44)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading)
        ]
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    private func secondLayoutSection() -> NSCollectionLayoutSection {
        var itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .absolute(view.frame.width / 2 + 110))
        if view.frame.width > 750 {
            itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.33),
                                              heightDimension: .absolute(view.frame.width / 3 + 110))
        }
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(500))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: .init(widthDimension: .fractionalWidth(1),
                                  heightDimension: .estimated(44)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .topLeading
            )
        ]
        
        return section
        
        
    }
    
    private func labelsConfigure() {
        labelDelivery.text = deliveryCounting()
        labelDelivery.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        labelDelivery.textColor = .systemGray
        labelTotalSum.text = "\(CatalogViewModel.shared.cartTotalPrice) ₽"
    }
    private func labelsMakeConstraints() {
        labelDelivery.translatesAutoresizingMaskIntoConstraints = false
        labelTotalSum.translatesAutoresizingMaskIntoConstraints = false
        viewTotalSumAndDeliveryCost.addSubview(labelDelivery)
        viewTotalSumAndDeliveryCost.addSubview(labelTotalSum)
        
        NSLayoutConstraint.activate([
            labelDelivery.leadingAnchor.constraint(equalTo: viewTotalSumAndDeliveryCost.leadingAnchor, constant: 15),
            labelDelivery.centerYAnchor.constraint(equalTo: viewTotalSumAndDeliveryCost.centerYAnchor),
            
            labelTotalSum.trailingAnchor.constraint(equalTo: viewTotalSumAndDeliveryCost.trailingAnchor, constant: -15),
            labelTotalSum.centerYAnchor.constraint(equalTo: viewTotalSumAndDeliveryCost.centerYAnchor)
        ])
    }
    private func viewTotalSumAndDeliveryCostConfigure() {
        viewTotalSumAndDeliveryCost.backgroundColor = .white
        viewTotalSumAndDeliveryCost.layer.shadowColor = UIColor.black.cgColor
        viewTotalSumAndDeliveryCost.layer.shadowRadius = 7
        viewTotalSumAndDeliveryCost.layer.shadowOpacity = 0.2
        viewTotalSumAndDeliveryCost.layer.shadowOffset = .zero
        
        view.addSubview(viewTotalSumAndDeliveryCost)
        viewTotalSumAndDeliveryCost.translatesAutoresizingMaskIntoConstraints = false
        
        viewTotalSumAndDeliveryCost.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        viewTotalSumAndDeliveryCost.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        viewTotalSumAndDeliveryCost.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        viewTotalSumAndDeliveryCost.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    private func deliveryCounting() -> String {
        CatalogViewModel.shared.freeDeliveryMinSum - CatalogViewModel.shared.cartTotalPrice <= 0 ?
        "Бесплатная доставка" : "\(CatalogViewModel.shared.freeDeliveryMinSum - CatalogViewModel.shared.cartTotalPrice) ₽ до бесплатной доставки"
    }
    private func modelConfigure() {
        CatalogService.shared.loadData(url: CatalogService.shared.catalogVaporURL) {
            DispatchQueue.main.async {
                self.collectionCatalog?.reloadData()
                print("Reload Interface - Catalog")
                CatalogViewModel.shared.loaded.0 = true
                CatalogViewModel.shared.loaded.1 = true
            }
        }
    }
    private func returnIndexPath(_ sender: UITapGestureRecognizer) -> IndexPath? {
        let position = sender.location(in: collectionCatalog)
        if let indexPath = collectionCatalog?.indexPathForItem(at: position) {
            return indexPath
        } else {
            return nil
        }
    }
    
    
    private func modelCalculateAmount(_ indexPath: IndexPath, _ calculate: Counter) {
        if indexPath.section == 0 {
            CatalogViewModel.shared.changeAmount(
                id: CatalogViewModel.shared.sectionOne[indexPath.row].id,
                calculate: calculate
            )
        } else {
            CatalogViewModel.shared.changeAmount(
                id: CatalogViewModel.shared.sectionTwo[indexPath.row].id,
                calculate: calculate
            )
        }
    }
    
    @objc func buttonPriceConfigure(sender: UITapGestureRecognizer) {
        guard let indexPath = returnIndexPath(sender) else { return }
        viewTotalSumAndDeliveryCost.isHidden = false
        modelCalculateAmount(indexPath, .plus)
        labelsConfigure()
        collectionCatalog?.reloadData()
    }
    
    @objc func plusOne(sender: UITapGestureRecognizer) {
        guard let indexPath = returnIndexPath(sender) else { return }
            modelCalculateAmount(indexPath, .plus)
            labelsConfigure()
            collectionCatalog?.reloadData()
    }
    
    @objc func minusOne(sender: UITapGestureRecognizer) {
        guard let indexPath = returnIndexPath(sender) else { return }
            modelCalculateAmount(indexPath, .minus)
            if CatalogViewModel.shared.cartTotalPrice == 0 {
                viewTotalSumAndDeliveryCost.isHidden = true
            }
            labelsConfigure()
            collectionCatalog?.reloadData()
    }
    
}

extension Catalog: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if CatalogViewModel.shared.catalog.isEmpty {
            return 6
        } else {
            if section == 0 {
                return CatalogViewModel.shared.sectionOne.count
            } else {
                return CatalogViewModel.shared.sectionTwo.count
            }
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionCatalog?.dequeueReusableCell(
            withReuseIdentifier: CatalogCustomCell.identifier,
            for: indexPath
        ) as? CatalogCustomCell else { return UICollectionViewCell() }
        
        if !CatalogViewModel.shared.sectionTwo.isEmpty && !CatalogViewModel.shared.sectionOne.isEmpty {
            print("Collections Configure")
            let sec = indexPath.section == 0 ? CatalogViewModel.shared.sectionOne : CatalogViewModel.shared.sectionTwo
            
            cell.configure(image: sec[indexPath.row].image,
                           name: sec[indexPath.row].title,
                           weight: sec[indexPath.row].weight,
                           amount: sec[indexPath.row].amount,
                           description: sec[indexPath.row].description
            )
            
            cell.loadingView.isHidden = true
            cell.loadingViewSecond.isHidden = true
            cell.imageView.alpha = 1
            
            cell.buttonMinus = cell.buttonConfigure(cell.buttonMinus, setTitle: "-")
            cell.buttonPlus  = cell.buttonConfigure(cell.buttonPlus, setTitle: "+")
            cell.buttonPrice = cell.buttonConfigure(
                cell.buttonPrice,
                setTitle: "\(sec[indexPath.row].price) ₽"
            )
            
            if sec[indexPath.row].amount == 0 {
                cell.buttonPrice.isHidden = false
                cell.buttonPlus.isHidden = true
                cell.buttonMinus.isHidden = true
                cell.labelCounter.isHidden = true
            } else {
                cell.buttonPrice.isHidden = true
                cell.buttonPlus.isHidden = false
                cell.buttonMinus.isHidden = false
                cell.labelCounter.isHidden = false
            }
            
            let gesture = UITapGestureRecognizer(
                target: self,
                action: #selector(buttonPriceConfigure(sender:))
            )
            cell.buttonPrice.addGestureRecognizer(gesture)
            
            let gesturePlusCount = UITapGestureRecognizer(
                target: self,
                action: #selector(plusOne(sender:))
            )
            cell.buttonPlus.addGestureRecognizer(gesturePlusCount)
            
            let gestureMinusCount = UITapGestureRecognizer(
                target: self,
                action: #selector(minusOne(sender:))
            )
            cell.buttonMinus.addGestureRecognizer(gestureMinusCount)
            
            
        } else if !CatalogViewModel.shared.loaded.0 && !CatalogViewModel.shared.loaded.1 {
            Timer.scheduledTimer(withTimeInterval: 1.4, repeats: true) { timer in
                UIView.animate(withDuration: 0.6) {
                    cell.imageView.alpha = 0.5
                    cell.loadingViewSecond.alpha = 0.5
                    cell.loadingView.alpha = 0.5
                } completion: { _ in
                    UIView.animate(withDuration: 0.8) {
                        cell.imageView.alpha = 0.9
                        cell.loadingViewSecond.alpha = 0.9
                        cell.loadingView.alpha = 0.9
                    }
                }
                if CatalogViewModel.shared.loaded.0 && CatalogViewModel.shared.loaded.1 {
                    timer.invalidate()
                    cell.imageView.layer.removeAllAnimations()
                    cell.loadingViewSecond.layer.removeAllAnimations()
                    cell.loadingView.layer.removeAllAnimations()
                    cell.layoutIfNeeded()
                    print("Timer stoped")
                }
            }
            print("Timer fire")
        } 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CatalogCustomCell else { return }
        UIView.animate(withDuration: 0.2, animations: {
            cell.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        }, completion: { finished in
            print("sec - \(indexPath.section), row - \(indexPath.row)")
            let sec = indexPath.section == 0 ? CatalogViewModel.shared.sectionOne : CatalogViewModel.shared.sectionTwo
            let cellData = sec[indexPath.row]
            let detailItem = DetailItemController(
                image: cell.imageView.image ?? UIImage(),
                label: "\(cell.nameOfItem.text ?? "") · \(cell.weightOfItem.text ?? "")"
                + "\(cell.desriptionData.text!.count > 0 ? " · \(cell.desriptionData.text ?? "")" : "")",
                cellData: cellData
            )
            self.present(detailItem, animated: true)
            UIView.animate(withDuration: 0.2) {
                cell.transform = .identity
            }
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CatalogSectionHeader.identifier,
            for: indexPath) as? CatalogSectionHeader
        else { return CatalogSectionHeader() }
        print("header")
        headerView.label.text = indexPath.section == 0 ? Titles.sales.rawValue : Titles.catalog.rawValue
        headerView.editButton.addTarget(self, action: #selector(appendToCatalog), for: .touchUpInside)
        if isAdminViewModel.shared.admin {
            headerView.editButton.isHidden = false
        } else {
            headerView.editButton.isHidden = true
        }
        return headerView
    }
    @objc private func appendToCatalog() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let editScreen = storyboard.instantiateViewController(
            withIdentifier: "AppendToCatalogViewController") as? AppendToCatalogViewController
        else { return }
        present(editScreen, animated: true)
    }
}
