//
//  ViewController.swift
//  APICall
//
//  Created by Nishanth on 07/08/24.
//

import UIKit

class ViewController: UIViewController {

    var viewModel: DetailsViewModel?
    
    @IBOutlet weak var detailTableView: UITableView!
    private let networkStatus = NetworkStatus()

    @IBOutlet weak var loaderActivity: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkStatus.startMonitoring()


        Task{
            let isConnected = await networkStatus.networkStatus()
            await self.fetchData(bool: isConnected)
        }
        // Do any additional setup after loading the view.
    }
    
    
    
    private func fetchData(bool: Bool) async{
        self.viewModel = DetailsViewModel()
        self.viewModel?.delegate = self
        await self.viewModel?.fetchData(isApiCalled: false, networkStatus: bool)
    }
    
    
    private func alertView(message: String){
        DispatchQueue.main.async {
            let alertVc = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "Done", style: .destructive))
            
            self.present(alertVc, animated: true, completion: nil)
        }
    }
    
    private func loadData(){
        
        DispatchQueue.main.async {
            self.loaderActivity.stopAnimating()
            self.detailTableView.reloadData()
        }
    }

    
}
extension ViewController: UpdateData{
    func updateData(success: Bool, error: String?) {
        if(success){
            self.loadData()
        }
        else{
            alertView(message: error ?? "")
        }
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel?.tableViewCellModel?.numberOfSection() ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.tableViewCellModel?.numberOfRowsInSection() ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsListCell", for: indexPath) as? DetailsListCell else{
            return UITableViewCell.init()
        }
        let descriptionDetails = self.viewModel?.tableViewCellModel?.cellForRowAtIndexPath(index: indexPath.row)
        cell.titleLabelText.text = "Title : \(descriptionDetails?.title ?? "")"
        cell.descriptionLabelText.text = "Description : \(descriptionDetails?.detaildescription ?? "")"
        cell.dateLabelText.text = "Date : \(descriptionDetails?.dateUrl ?? "")"
        if let imageData = descriptionDetails?.imageUrl{
            cell.loadImage(from: imageData)
        }
        return cell
    }
    


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

