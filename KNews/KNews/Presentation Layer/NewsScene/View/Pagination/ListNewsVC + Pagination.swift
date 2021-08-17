//
//  ListNewsVC + Pagination.swift
//  KNews
//
//  Created by Amin on 16/08/2021.
//

import UIKit

extension ListNewsVC : UIScrollViewDelegate{
    static var isPaginating = false
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (uiTableView.contentSize.height + 50) - (scrollView.frame.size.height) {
            
            guard ListNewsVC.isPaginating == false else {
                // already paginating
                return
            }
            ListNewsVC.isPaginating = true
            uiTableView.tableFooterView = createSnipperFooter()
            viewModel.fetchNewsData(pagination: true)
        }
    }
    
    private func createSnipperFooter()->UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 100))
        let indicator = UIActivityIndicatorView()
        indicator.center = footerView.center
        footerView.addSubview(indicator)
        indicator.startAnimating()
        return footerView
    }
}
