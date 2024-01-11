//
//  CatalogViewController.swift
//  yourProjectName
//
//  Created by Yaroslav on 16.10.2023.
//

import UIKit

class CatalogViewController: UIViewController {
    
    private let imageManager = ImageManager.shared
    private let model = CatalogModel()
    private var categoryModel: [CatalogUIModel] = []
    private lazy var catalogTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self // подписываемся на протокол
        tableView.dataSource = self  // подписываемся на протокол
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: "CatalogCell") // Identifier: "CatalogCell" - должен совпадать с тем что прописан в реализации делегата
        return tableView
    }()
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LAUNCHED")

        title = "Rybinsk Transport Cards" // устанавливаем заголовок
        view.backgroundColor = .white
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), //создаем ButtonItem для поиска
                                                style: .done,
                                                target: self,
                                                action: #selector(findButtonTapped))
        catalogTableView.refreshControl = refreshControl

        refreshControl.addTarget(self, action: #selector(reloaddButtonTapped), for: .valueChanged)
        navigationItem.rightBarButtonItem = rightBarButtonItem

        view.addSubview(catalogTableView)
        setupCatalogTableView()
        loadCatalog()
    }
    
    @objc
    private func findButtonTapped() {
        // Создаем UIAlertController
        let alertController = UIAlertController(title: "Поиск",
                                                message: nil,
                                                preferredStyle: .alert)

        // Добавляем текстовое поле для типа
        alertController.addTextField { textField in
            textField.placeholder = "Введите название"
        }

        // Добавляем кнопку Найти
        let findAction = UIAlertAction(title: "Найти", style: .default) { [weak self] _ in
            // код по обработке введенных данных
            if let searchText = alertController.textFields?.first?.text {
                self?.handleSearch(searchText)
            }
        }

        alertController.addAction(findAction)

        // Добавляем кнопку Отмена
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)

        // Показываем UIAlertController
        present(alertController, animated: true, completion: nil)
    }

    private func handleSearch(_ type: String? = nil) {
        
        model.loadCatalog(with: type) { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self?.categoryModel = data
                    self?.catalogTableView.reloadData()
                }
            case .failure(let error):
                print("error", error.localizedDescription)
            }
        }
    }

    
    @objc
    private func reloaddButtonTapped() {
        loadCatalog()
        refreshControl.endRefreshing()
    }
    
    // задаем отступы (в данном слечае прибито к краям экрана)
    private func setupCatalogTableView() {
        catalogTableView.translatesAutoresizingMaskIntoConstraints = false
        catalogTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        catalogTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        catalogTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        catalogTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
    private func loadCatalog() {
        model.loadCatalog { [weak self] result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
//                    print("loadCatalog data", data)
                    self?.categoryModel = data
                    self?.catalogTableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { // колечество ячеек в таблице
        categoryModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { // создание ячеек
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "CatalogCell", for: indexPath) as? CatalogTableViewCell else {
            return .init()
        }
        cell.cellConfigure(with: categoryModel[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { // меняет размер ячейки
        250
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedModel = categoryModel[indexPath.row].id

        let detailVC = DetailInformationViewController()

        detailVC.datailConfigure(with: selectedModel)

        navigationController?.pushViewController(detailVC, animated: true)
    }

}
