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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionCatalogConfigure()
        
        viewTotalSumAndDeliveryCostConfigure()
        viewTotalSumAndDeliveryCost.isHidden = true
        labelsConfigure()
        labelsMakeConstraints()
        modelConfigure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        labelsConfigure()
        collectionCatalog?.reloadData()
        if Singleton.shared.cartTotalPrice == 0 {
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
            case 0: return self.secondLayoutSection()
            default: return self.firstLayoutSection()
            }
        }
    }
    private func firstLayoutSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .absolute(view.frame.width / 2 + 110))
        
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
    private func secondLayoutSection() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .absolute(view.frame.width / 2 + 90))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        //        item.contentInsets.bottom = 15
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension:
                .absolute(view.frame.width / 2 + 90))
        
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
    
    private func labelsConfigure() {
        labelDelivery.text = deliveryCounting()
        labelDelivery.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        labelDelivery.textColor = .systemGray
        labelTotalSum.text = "\(Singleton.shared.cartTotalPrice) ₽"
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
        Singleton.shared.freeDeliveryMinSum - Singleton.shared.cartTotalPrice <= 0 ?
        "Бесплатная доставка" : "\(Singleton.shared.freeDeliveryMinSum - Singleton.shared.cartTotalPrice) ₽ до бесплатной доставки"
    }
    private func modelConfigure() {
        loadData(0, url: salesDataUrl) {
            DispatchQueue.main.async {
                self.collectionCatalog?.reloadData()
                print("Reload Interface - Sales")
                Singleton.shared.loaded.0 = true
                print(Singleton.shared.loaded.0)
                print(Singleton.shared.sectionOne)
            }
        }
        loadData(1, url: catalogDataUrl) {
            DispatchQueue.main.async {
                self.collectionCatalog?.reloadData()
                print("Reload Interface - Catalog")
                Singleton.shared.loaded.1 = true
                print(Singleton.shared.loaded.1)
                print(Singleton.shared.sectionTwo)
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
    
    
    func modelCalculateAmount(_ indexPath: IndexPath, _ calculate: Counter) {
        let counter = returnCounter(indexPath)
        if calculate == .plus {
            Singleton.shared.data[indexPath.row + counter]?.amount += 1
        } else {
            Singleton.shared.data[indexPath.row + counter]?.amount -= 1
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
        let counter = returnCounter(indexPath)
        if let amount = Singleton.shared.data[indexPath.row + counter]?.amount {
            if amount < 20 {
                modelCalculateAmount(indexPath, .plus)
                labelsConfigure()
                collectionCatalog?.reloadData()
            }
        }
    }
    
    @objc func minusOne(sender: UITapGestureRecognizer) {
        guard let indexPath = returnIndexPath(sender) else { return }
        let counter = returnCounter(indexPath)
        if let amount = Singleton.shared.data[indexPath.row + counter]?.amount {
            if amount > 0 {
                modelCalculateAmount(indexPath, .minus)
                if Singleton.shared.cartTotalPrice == 0 {
                    viewTotalSumAndDeliveryCost.isHidden = true
                }
                labelsConfigure()
                collectionCatalog?.reloadData()
            }
        }
    }
    
    func returnCounter(_ indexPath: IndexPath) -> Int {
        indexPath.section == 0 ? 0 : Singleton.shared.counter
    }
    
}

extension Catalog: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if Singleton.shared.data.isEmpty {
            return 6
        } else {
            if section == 0 {
                return Singleton.shared.sectionOne.count
            } else {
                return Singleton.shared.sectionTwo.count
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
        
        if !Singleton.shared.sectionTwo.isEmpty && !Singleton.shared.sectionOne.isEmpty {
            print("Collections Configure")
            let sec = indexPath.section == 0 ? Singleton.shared.sectionOne : Singleton.shared.sectionTwo
            let counter = returnCounter(indexPath)
            
            cell.configure(image: sec[indexPath.row + counter]?.image ?? UIImage(named: "imgDefault") ?? UIImage(),
                           name: sec[indexPath.row + counter]?.name ?? "Тортик",
                           weight: sec[indexPath.row + counter]?.weight ?? 0,
                           amount: sec[indexPath.row + counter]?.amount ?? 0)
            
            cell.loadingView.isHidden = true
            cell.loadingViewSecond.isHidden = true
            cell.imageView.alpha = 1
            
            cell.buttonMinus = cell.buttonConfigure(cell.buttonMinus, setTitle: "-")
            cell.buttonPlus  = cell.buttonConfigure(cell.buttonPlus, setTitle: "+")
            cell.buttonPrice = cell.buttonConfigure(
                cell.buttonPrice,
                setTitle: "\(sec[indexPath.row + counter]?.price ?? 1000) ₽"
            )
            
            if sec[indexPath.row + counter]?.amount == 0 {
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
            
            
        } else if !Singleton.shared.loaded.0 && !Singleton.shared.loaded.1 {
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
                if Singleton.shared.loaded.0 && Singleton.shared.loaded.1 {
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
        
        headerView.label.text = indexPath.section == 0 ? Titles.sales.rawValue : Titles.catalog.rawValue
        
        return headerView
    }
}
