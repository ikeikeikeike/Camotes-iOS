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
        
//        resultsTableController = ResultsTableController()
//        resultsTableController.tableView.delegate = self
        
        searcher = UISearchController(searchResultsController: nil)
        searcher.searchResultsUpdater = self
        searcher.searchBar.sizeToFit()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searcher
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searcher.delegate = self
        searcher.dimsBackgroundDuringPresentation = false // default is YES
        searcher.searchBar.delegate = self    // so we can monitor text changes + others
        
        definesPresentationContext = true
        
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
        if let text = searcher.searchBar.text {
            print(text)
//            filteredItems = MasterViewController().data.filter{$0.localizedCaseInsensitiveContains(text)}
//            self.collectionView?.reloadData()
        }
    }
}
