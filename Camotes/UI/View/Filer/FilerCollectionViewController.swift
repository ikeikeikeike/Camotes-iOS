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
    
    var searcher: UISearchController!

    deinit {
        notifyToken?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Objects
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

        // Searching
        searcher = UISearchController(searchResultsController: nil)
        searcher.searchResultsUpdater = self
        searcher.searchBar.autocapitalizationType = .none
        searcher.searchBar.sizeToFit()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searcher
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searcher.delegate = self
        searcher.dimsBackgroundDuringPresentation = false // default is YES
        searcher.searchBar.delegate = self    // so we can monitor text changes + others
        
        definesPresentationContext = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

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
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FilerCollectionReusableView", for: indexPath) as! FilerCollectionReusableView
            
            return reusableview
        }
        
        return UICollectionReusableView()
    }

    @IBAction func sortby(_ sender: UIBarButtonItem) {
        let handler = {(action: UIAlertAction!) in
            let title = action.title!
            sender.title = "Sorted by \(title) ▼"
            
            switch title {
            case "Name":
                self.files = self.files.sorted(byKeyPath: "name", ascending: false)
            case "Duration":
                self.files = self.files.sorted(byKeyPath: "duration", ascending: false)
            case "Size":
                print("not implimented")
            case "Oldest":
                self.files = self.files.sorted(byKeyPath: "date", ascending: true)
            case "Latest":
                self.files = self.files.sorted(byKeyPath: "date", ascending: false)
            default:
                self.files = self.files.sorted(byKeyPath: "date", ascending: false)
            }
            
            self.collectionView?.reloadData()
        }
        
        let alert = UIAlertController(title: "Sort by:", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let name = UIAlertAction(title: "Name", style: .default, handler: handler)
        let duration = UIAlertAction(title: "Duration", style: .default, handler: handler)
        let size = UIAlertAction(title: "Size", style: .default, handler: handler)
        let asc = UIAlertAction(title: "Oldest", style: .default, handler: handler)
        let date = UIAlertAction(title: "Latest", style: .default, handler: handler)
        
        alert.addAction(cancel)
        alert.addAction(name)
        alert.addAction(size)
        alert.addAction(duration)
        alert.addAction(asc)
        alert.addAction(date)
        
        present(alert, animated: true)
    }
}

extension FilerCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGFloat = (UIScreen.main.bounds.width / 2) - 5.0
        return CGSize(width: size, height: size - 20.0)
    }
}

extension FilerCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension FilerCollectionViewController: UISearchControllerDelegate {
    func presentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
}


extension FilerCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let cview = collectionView else { return }
        guard let text = searcher.searchBar.text else { return }
        
        files = useCase.files()
        if !text.isEmpty {
            files = files.filter("title CONTAINS[cd] %@ OR site BEGINSWITH[cd] %@", text, text)
        }
        
        cview.reloadData()
    }
}
