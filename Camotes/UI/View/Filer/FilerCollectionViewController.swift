//
//  FilerCollectionViewController.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/05/20.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import UIKit
import RealmSwift

private let reuseID = "FilerCollectionViewCell"

class FilerCollectionViewController: UICollectionViewController {
    
    let useCase: FilerUseCase! = Injector.ct.resolve(FilerUseCase.self)
    var files: Results<FilerObject>!
    var notifyToken: NotificationToken? = nil
   
    deinit {
        notifyToken?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        files = useCase.files()
        notifyToken = files.observe { [weak self] (changes: RealmCollectionChange) in
            guard let cview = self?.collectionView else { return }
            
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                cview.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                cview.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                cview.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                cview.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return files.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! FilerCollectionViewCell
       
        let file = files[indexPath.row]
        cell.label.text = file.title
        cell.image.image = UIImage(data: (file.thumb))

        return cell
    }
   
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let file = files[indexPath.row]
        guard let url = URL(string: "compass://filer:\(file.id)") else {
            return
        }
        
        handleRoute(url, router: Routes.router)       
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */


}

extension FilerCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGFloat = (UIScreen.main.bounds.width / 2) - 5.0
        return CGSize(width: size, height: size - 20.0)
    }
}

