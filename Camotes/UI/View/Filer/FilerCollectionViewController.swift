//
//  FilerCollectionViewController.swift
//  Camotes
//
//  Created by Tatsuo Ikeda on 2018/05/20.
//  Copyright © 2018 Tatsuo Ikeda. All rights reserved.
//

import UIKit
import RealmSwift
import MZDownloadManager

private let reuseID = "FilerCollectionViewCell"

class FilerCollectionViewController: UICollectionViewController {

    let useCase: FilerUseCase! = Injector.ct.resolve(FilerUseCase.self)
    var downloadManager: MZDownloadManager!

    var files: Results<FilerObject>!
    var notifyToken: NotificationToken?

    var searcher: UISearchController!

    deinit {
        notifyToken?.invalidate()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Objects
        files = useCase.files()
        notifyToken = files.observe { [weak self] (changes: RealmCollectionChange) in
            guard let collectionView = self?.collectionView else { return }

            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                collectionView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
                collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
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

}

// MARK: - Action

extension FilerCollectionViewController {
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

extension FilerCollectionViewController: MZDownloadManagerDelegate {

    func downloadRequestStarted(_ downloadModel: MZDownloadModel, index: Int) {
//        let indexPath = IndexPath.init(row: index, section: 0)
//        tableView.insertRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }

    func downloadRequestDidPopulatedInterruptedTasks(_ downloadModels: [MZDownloadModel]) {
//        tableView.reloadData()
    }

    func downloadRequestDidUpdateProgress(_ downloadModel: MZDownloadModel, index: Int) {
//        self.refreshCellForIndex(downloadModel, index: index)
    }

    func downloadRequestDidPaused(_ downloadModel: MZDownloadModel, index: Int) {
//        self.refreshCellForIndex(downloadModel, index: index)
    }

    func downloadRequestDidResumed(_ downloadModel: MZDownloadModel, index: Int) {
//        self.refreshCellForIndex(downloadModel, index: index)
    }

    func downloadRequestCanceled(_ downloadModel: MZDownloadModel, index: Int) {

//        self.safelyDismissAlertController()

//        let indexPath = IndexPath.init(row: index, section: 0)
//        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
    }

    func downloadRequestFinished(_ downloadModel: MZDownloadModel, index: Int) {

//        self.safelyDismissAlertController()

//        downloadManager.presentNotificationForDownload("Ok", notifBody: "Download did completed")

//        let indexPath = IndexPath.init(row: index, section: 0)
//        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
//
//        let docDirectoryPath : NSString = (MZUtility.baseFilePath as NSString).appendingPathComponent(downloadModel.fileName) as NSString
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: MZUtility.DownloadCompletedNotif as String), object: docDirectoryPath)
    }

    func downloadRequestDidFailedWithError(_ error: NSError, downloadModel: MZDownloadModel, index: Int) {
//        self.safelyDismissAlertController()
//        self.refreshCellForIndex(downloadModel, index: index)
//
//        debugPrint("Error while downloading file: \(downloadModel.fileName)  Error: \(error)")
    }

    //Oppotunity to handle destination does not exists error
    //This delegate will be called on the session queue so handle it appropriately
    func downloadRequestDestinationDoestNotExists(_ downloadModel: MZDownloadModel, index: Int, location: URL) {
//        let myDownloadPath = MZUtility.baseFilePath + "/Default folder"
//        if !FileManager.default.fileExists(atPath: myDownloadPath) {
//            try! FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes: nil)
//        }
//        let fileName = MZUtility.getUniqueFileNameWithPath((myDownloadPath as NSString).appendingPathComponent(downloadModel.fileName as String) as NSString)
//        let path =  myDownloadPath + "/" + (fileName as String)
//        try! FileManager.default.moveItem(at: location, to: URL(fileURLWithPath: path))
//        debugPrint("Default folder path: \(myDownloadPath)")
    }
}

extension FilerCollectionViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let collectionView = collectionView else { return }
        guard let text = searcher.searchBar.text else { return }

        files = useCase.files()
        if !text.isEmpty {
            files = files.filter("title CONTAINS[cd] %@ OR site BEGINSWITH[cd] %@", text, text)
        }

        collectionView.reloadData()
    }
}
