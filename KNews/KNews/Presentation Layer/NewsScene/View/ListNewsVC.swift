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
    
    private var viewModel : ListNewsType!
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
        uiTableView.register(CustomHeaderCell.self,forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        viewModel = ListNewsVM()
        bind()


        viewModel.fetchNewsData()
        uiTableView.rx.setDelegate(self).disposed(by: bag)

    }
    
    func bind() {
        viewModel.loading.asObservable().bind{[weak self] isLoading in
            guard let self = self else { return }
            
            isLoading ? self.view.makeToastActivity(.center) : self.view.hideToastActivity()
        }.disposed(by: bag)
        
        viewModel.showError.asObservable().bind{ [unowned self] msg in
            view.makeToast(msg, duration: 3.0, position: .top)
        }.disposed(by: bag)
        
        viewModel.listNews.asObservable().bind(to: self.uiTableView.rx.items(dataSource: self.dataSource)).disposed(by: bag)
        
        viewModel.listNews.asObservable().bind{ items in
            print("--------------",items.count)
            self.uiTableView.isHidden =  items.isEmpty ? true : false
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
            headerView.textLabel?.layer.cornerRadius = headerView.textLabel!.frame.height / 2
            headerView.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        }

    }
}

class CustomHeaderCell: UITableViewHeaderFooterView {
    var title = UILabel()
    var view : UIView!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 50))
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        view.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(view)
        view.addSubview(title)
        view.backgroundColor = .gray
        // Center the image vertically and place it near the leading
        // edge of the view. Constrain its width and height to 50 points.
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            view.widthAnchor.constraint(equalToConstant: 50),
            view.heightAnchor.constraint(equalToConstant: 50),
            view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Center the label vertically, and use it to fill the remaining
            // space in the header view.
            title.heightAnchor.constraint(equalToConstant: 30),
            title.leadingAnchor.constraint(equalTo: view.trailingAnchor,
                                           constant: 8),
            title.trailingAnchor.constraint(equalTo:
                                                contentView.layoutMarginsGuide.trailingAnchor),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
