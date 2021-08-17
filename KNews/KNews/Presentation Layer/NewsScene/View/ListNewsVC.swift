//
//  ListNewsVC.swift
//  KNews
//
//  Created by Amin on 15/08/2021.
//

import UIKit
import RxSwift
import RxDataSources
import Toast_Swift

class ListNewsVC: UIViewController {
    
    @IBOutlet var uiTableView: UITableView!
    @IBOutlet var uiEmptyImage: UIImageView!
    
    var viewModel : ListNewsType!
    private var bag: DisposeBag!
    
    
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(
        configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsItemCell", for: indexPath) as! NewsItemCell
            cell.bindNewsItem(item: item)
            return cell
        })
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bag = DisposeBag()

        uiTableView.register(UINib(nibName: "NewsItemCell", bundle: nil), forCellReuseIdentifier: "newsItemCell")
        
        viewModel = ListNewsVM(useCase: ListNewsUsecase(repo: Repo(remote: Remotedatasource())))
        bind()
        setupSearchBar()

        viewModel.fetchNewsData(pagination: false)
        uiTableView.rx.setDelegate(self).disposed(by: bag)

    }
    
    func setupSearchBar() {
        
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search for something eg CNN"
        
        navigationItem.searchController = sc
    }
    
    func bind() {
        viewModel.loading.asObservable().bind{[weak self] isLoading in
            guard let self = self else { return }
            
            isLoading ? self.view.makeToastActivity(.center) : self.view.hideToastActivity()
        }.disposed(by: bag)
        
        viewModel.showError.asObservable().bind{ [unowned self] msg in
            view.makeToast(msg, duration: 3.0, position: .top)
            self.uiTableView.tableFooterView = nil
            ListNewsVC.isPaginating = false
        }.disposed(by: bag)
        
        viewModel.listNews.asObservable().bind(to: self.uiTableView.rx.items(dataSource: self.dataSource)).disposed(by: bag)
        
        viewModel.listNews.asObservable().bind{ items in
            self.uiTableView.isHidden =  items.isEmpty ? true : false
            self.uiTableView.tableFooterView = nil
            ListNewsVC.isPaginating = false

        }.disposed(by: bag)
        
        
        uiTableView.rx.modelSelected(NewsItem.self).subscribe { [weak self] (item) in
            guard let self = self else { return }
            guard let item = item.element else { return }
            
            let detailsVC = DetailsVC.init(nibName: "DetailsVC", bundle: nil)
            detailsVC.itemNews = item
            self.navigationController?.pushViewController(detailsVC, animated: true)
            
        }.disposed(by: bag)
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            
            return " \(dataSource.sectionModels[index].header)  "
        }
    }
}

extension ListNewsVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.layer.masksToBounds = true
            headerView.textLabel?.textColor = .black
            headerView.textLabel?.textAlignment = .center
            headerView.textLabel?.backgroundColor = .lightGray
            headerView.textLabel?.layer.cornerRadius = 10
            headerView.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        }

    }
}


// MARK: - UISearchResult Updating and UISearchControllerDelegate  Extension
  extension ListNewsVC: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        
        if text.isEmpty{
            viewModel.getCurrentNews()
        }else{
            viewModel.searchNews(with: text)
        }


    }
 }
