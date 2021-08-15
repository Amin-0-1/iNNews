//
//  ListNewsVC.swift
//  KNews
//
//  Created by Amin on 15/08/2021.
//

import UIKit
import RxSwift
import Toast_Swift

class ListNewsVC: UIViewController {

    @IBOutlet var uiTableView: UITableView!
    
    private var viewModel : ListNewsType!
    private var bag: DisposeBag!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiTableView.register(UINib(nibName: "NewsItemCell", bundle: nil), forCellReuseIdentifier: "newsItemCell")
        
        viewModel = ListNewsVM()
        viewModel.fetchNewsData()
        bag = DisposeBag()
        
        bind()

    }
    
    func bind() {
        viewModel.loading.asObservable().bind{[unowned self] isLoading in
            isLoading ? self.view.makeToastActivity(.center) : self.view.hideAllToasts()
        }.disposed(by: bag)
        
        viewModel.showError.asObservable().bind{ [unowned self] msg in
            view.makeToast(msg, duration: 3.0, position: .top)
        }.disposed(by: bag)
        
        viewModel.listNews.asObservable().bind(to: uiTableView.rx.items(cellIdentifier: "newsItemCell")) { row,item,cell in
            (cell as? NewsItemCell)?.bindNewsItem = item

        }.disposed(by: bag)
        
    }
}

//extension ListNewsVC: UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "newsItemCell") as! NewsItemCell //else {return UITableViewCell()}
//        cell.uiAuthor?.text = "Author"
//        cell.uiDescription?.text = "bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla "
//        cell.uiImage?.image = UIImage(systemName: "star")
//        cell.uiSource?.text = "https://www.google.com"
//        cell.uiTitle?.text = "this is title"
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Section header"
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//}



