//
//  ViewController.swift
//  iTunesSearch
//
//  Created by Tolga Sayan on 20.10.2021.
//

import UIKit

class SearchViewController: UIViewController {
  
  struct TableView {
    struct CellIdentifiers {
      static let searchResultCell = "SearchResultCell"
      static let nothingFoundCell = "NothingFoundCell"
    }
  }
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  var searchResults = [SearchResult]()
  var hasSearched = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let celNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
    let celNib2 = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
    
    tableView.register(celNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
    tableView.register(celNib2, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
  }
  
  
}

extension SearchViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    let searchResult = SearchResult()
    
    for i in 0...2 {
      searchResult.name = String(format: "Fake Result %d for", i)
      searchResult.artistName = searchBar.text!
      searchResults.append(searchResult)
    }
    searchBar.resignFirstResponder()
    hasSearched = true
    tableView.reloadData()
  }
  
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    return .topAttached
  }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if !hasSearched {
      return 0
    } else if searchResults.count == 0 {
      return 1
    } else {
      return searchResults.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = TableView.CellIdentifiers.searchResultCell
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! SearchResultCell
    
    if searchResults.count == 0 {
      return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
    } else {
      let searchResult = searchResults[indexPath.row]
      cell.nameLabel.text = searchResult.name
      cell.artistNameLabel.text = searchResult.artistName
      
    }
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if searchResults.count == 0 {
      return nil
    } else {
      return indexPath
    }
  }
}
